// =============================================================================
// tb_gap.sv  --  global average pooling (16 channels, 4 per beat)
//
// GAP does not know the map size: it accumulates from `first` to `last`, then
// emits 4 beats (groups 0..3). So the testbench defines the map: 121 positions
// (11x11) x 4 groups = 484 beats for a full map.
//
// What it is trying to break:
//   * gc never advancing  -> EMIT stuck on group 0, valid_out stuck high
//   * first clearing instead of LOADING -> the first pixel of every map is lost
//   * first missing entirely -> map n inherits map n-1's sums
//   * >>7 written as >>6 or >>8
//   * 16-bit accumulator overflow (max legal sum is 121*255 = 30,855)
//   * group/lane index crossing -> two channels merged, the rest stuck at 0
//   * valid_out not a 4-cycle burst, or g_out not in step with its bytes
//   * a gap on the bus changing the result
//
// Run from the project root:
//   $ verilator --binary --timing --trace -Wno-fatal --top-module tb_gap \
//         --Mdir sim/build/vgap sim/tb_gap.sv rtl/compute/gap.sv
//   $ ./sim/build/vgap/Vtb_gap        (writes sim/tb_gap.vcd)
//   $ gtkwave -a sim/tb_gap.gtkw sim/tb_gap.vcd
// =============================================================================
`timescale 1ns/1ps
`default_nettype none

module tb_gap;

    localparam int POS = 121;        // 11 x 11 positions per map
    localparam int NCH = 16;         // 16 channels = 4 groups x 4 lanes

    logic clk = 0, rst = 1, valid_in = 0, first = 0, last = 0;
    logic [1:0] g;
    logic [7:0] in0, in1, in2, in3;

    logic       valid_out;
    logic [1:0] g_out;
    logic [7:0] out0, out1, out2, out3;

    int checks = 0, fails = 0;

    int expv [0:15];                 // per-channel constant for the map being sent
    int want [0:15];                 // expected GAP output per channel
    int got  [0:15];                 // captured output per channel
    int gseq [0:3];                  // g_out seen on each emit beat

    gap dut (
        .clk(clk), .rst(rst),
        .valid_in(valid_in), .g(g), .first(first), .last(last),
        .in0(in0), .in1(in1), .in2(in2), .in3(in3),
        .valid_out(valid_out), .g_out(g_out),
        .out0(out0), .out1(out1), .out2(out2), .out3(out3)
    );

    always #5 clk = ~clk;

    task tick(); begin @(posedge clk); #1; end endtask

    // expected value: truncating sum/128 for a constant map
    function int ea(input int v, input int n);
        ea = (n * v) >> 7;
    endfunction

    // ------------------------------------------------------------------ drive
    // one beat = 4 channels of one group. first/last ride on specific beats.
    task beat(input logic [1:0] gg, input int v0, v1, v2, v3,
              input logic fst, input logic lst);
        begin
            g = gg;
            in0 = v0[7:0]; in1 = v1[7:0]; in2 = v2[7:0]; in3 = v3[7:0];
            first = fst; last = lst; valid_in = 1'b1;
            tick();
            valid_in = 1'b0; first = 1'b0; last = 1'b0;
        end
    endtask

    // a full 121-position map, channels take their value from expv[]
    task send_map(input logic gap_mode);
        begin
            for (int pos = 0; pos < POS; pos++) begin
                for (int gg = 0; gg < 4; gg++) begin
                    beat(2'(gg),
                         expv[4*gg], expv[4*gg+1], expv[4*gg+2], expv[4*gg+3],
                         (pos == 0)   && (gg == 0),
                         (pos == POS-1) && (gg == 3));
                    // gap_mode: stall the bus twice every 7th beat, like a
                    // real producer waiting on a buffer
                    if (gap_mode && ((pos % 7) == 3) && (gg == 1)) begin
                        tick(); tick();
                    end
                end
            end
        end
    endtask

    // a map with a single position (4 beats: g = 0,1,2,3)
    task send_one_position();
        begin
            for (int gg = 0; gg < 4; gg++)
                beat(2'(gg),
                     expv[4*gg], expv[4*gg+1], expv[4*gg+2], expv[4*gg+3],
                     (gg == 0), (gg == 3));
        end
    endtask

    // ------------------------------------------------------------------ check
    task collect();
        int guard, gi, seen;
        begin
            for (int i = 0; i < NCH; i++) got[i] = -1;
            for (int i = 0; i < 4;    i++) gseq[i] = -1;
            seen = 0; guard = 0;
            while (!valid_out && guard < 60) begin tick(); guard = guard + 1; end
            while (valid_out && seen < 4) begin
                gi = {28'd0, g_out, 2'd0};
                got[gi+0] = 32'(out0); got[gi+1] = 32'(out1);
                got[gi+2] = 32'(out2); got[gi+3] = 32'(out3);
                gseq[seen] = 32'(g_out);
                seen = seen + 1;
                tick();
            end
            checks = checks + 1;
            if (seen != 4) begin
                fails = fails + 1;
                $display("      FAIL  %-40s only %0d of 4 emit beats", "emit burst length", seen);
            end
        end
    endtask

    // compare all 16 channels against want[]
    task chk_map(input string what);
        int bad, fb;
        begin
            bad = 0; fb = -1;
            for (int c = 0; c < NCH; c++) begin
                checks = checks + 1;
                if (got[c] !== want[c]) begin
                    fails = fails + 1;
                    bad = bad + 1;
                    if (fb < 0) begin
                        fb = c;
                        $display("      FAIL  %-40s ch%0d got %0d, wanted %0d",
                                 what, c, got[c], want[c]);
                    end
                end
            end
            if (bad == 0) $display("      pass  %-40s all 16 channels", what);
            else          $display("             ... %0d of 16 channels wrong", bad);
        end
    endtask

    task chk_val(input int g, w, input string what);
        begin
            checks = checks + 1;
            if (g !== w) begin
                fails = fails + 1;
                $display("      FAIL  %-40s got %0d, wanted %0d", what, g, w);
            end else
                $display("      pass  %-40s %0d", what, g);
        end
    endtask

    task do_reset();
        begin
            rst = 1; tick(); tick(); rst = 0; tick();
        end
    endtask

    // =====================================================================
    initial begin

        $dumpfile("sim/tb_gap.vcd");
        $dumpvars(0, tb_gap);

        repeat(3) tick();
        rst = 0;
        tick();

        // ---------------- [1] reset ----------------
        $display("\n[1] reset");
        chk_val(32'(valid_out), 0, "valid_out low");
        chk_val(32'(g_out), 0, "g_out low");

        // ---------------- [2] flat map: 128 everywhere ----------------
        // 121 x 128 = 15,488, >>7 = 121. Proves the pixel count AND the shift.
        $display("\n[2] flat map of 128 over 121 positions (expect 121)");
        for (int c = 0; c < NCH; c++) expv[c] = 128;
        send_map(1'b0);
        collect();
        for (int c = 0; c < NCH; c++) want[c] = ea(128, POS);
        chk_map("flat 128 -> 121");

        // ---------------- [3] per-channel ramp: no channel crosses ----------------
        $display("\n[3] per-channel ramp 100..175 (all 16 channels distinct)");
        for (int c = 0; c < NCH; c++) expv[c] = 100 + 5*c;
        send_map(1'b0);
        collect();
        for (int c = 0; c < NCH; c++) want[c] = ea(expv[c], POS);
        chk_map("ramp per channel");

        // ---------------- [4] maximum: no accumulator overflow ----------------
        // 121 x 255 = 30,855, >>7 = 241  (the clamp at 255 is unreachable)
        $display("\n[4] flat map of 255 (expect 241, proves 16 bits is enough)");
        for (int c = 0; c < NCH; c++) expv[c] = 255;
        send_map(1'b0);
        collect();
        for (int c = 0; c < NCH; c++) want[c] = ea(255, POS);
        chk_map("flat 255 -> 241");

        // ---------------- [5] two maps back to back ----------------
        // If `first` does not reseed, map B would come out ~283 (saturated 255)
        // instead of 189.
        $display("\n[5] two maps back to back (reseed test)");
        for (int c = 0; c < NCH; c++) expv[c] = 100;
        send_map(1'b0); collect();
        for (int c = 0; c < NCH; c++) want[c] = ea(100, POS);
        chk_map("map A (100) -> 94");

        for (int c = 0; c < NCH; c++) expv[c] = 200;
        send_map(1'b0); collect();
        for (int c = 0; c < NCH; c++) want[c] = ea(200, POS);
        chk_map("map B (200) -> 189");

        // ---------------- [6] a one-position map ----------------
        $display("\n[6] one-position map (4 beats only)");
        for (int c = 0; c < NCH; c++) expv[c] = 255;
        send_one_position();
        collect();
        for (int c = 0; c < NCH; c++) want[c] = ea(255, 1);
        chk_map("single pixel 255 -> 1");

        // ---------------- [7] g_out stays in step with its bytes ----------------
        $display("\n[7] emit burst: g_out = 0,1,2,3 and valid_out falls after 4");
        chk_val(gseq[0], 0, "emit beat 0 label");
        chk_val(gseq[1], 1, "emit beat 1 label");
        chk_val(gseq[2], 2, "emit beat 2 label");
        chk_val(gseq[3], 3, "emit beat 3 label");
        chk_val(32'(valid_out), 0, "valid_out falls after the burst");

        // ---------------- [8] gaps between beats must not matter ----------------
        $display("\n[8] same map with stalls on the bus");
        for (int c = 0; c < NCH; c++) expv[c] = 100 + 3*c;
        send_map(1'b1);
        collect();
        for (int c = 0; c < NCH; c++) want[c] = ea(expv[c], POS);
        chk_map("gapped map matches");

        // ---------------- summary ----------------
        $display("\n==================================================");
        $display("  checks: %0d    failures: %0d", checks, fails);
        if (fails == 0) $display("  RESULT: ALL PASS");
        else            $display("  RESULT: *** %0d FAILURES ***", fails);
        $display("==================================================\n");

        if (checks < 100) $fatal(1, "only %0d checks ran", checks);
        if (fails  != 0)  $fatal(1, "verification failed");
        $finish;

    end

endmodule

`default_nettype wire
