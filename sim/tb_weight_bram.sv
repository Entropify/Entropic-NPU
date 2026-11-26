`timescale 1ns/1ps

// =============================================================================
// tb_weight_bram — 288-bit weight store, two banks
//
// What this bench is trying to break:
//   * the read path indexing with w_addr instead of r_addr  -> [1] reads from 0
//     upwards after the last write was beat 127
//   * a missing bank decode      -> [2] re-reads bank A after filling bank B
//   * a combinational read       -> [3] address at T, data must be at T+1
//   * a write visible immediately -> [4] read-first
//   * a transposed beat layout   -> [5] every one of the 36 bytes is checked
//                                  against beat[4t+l] = w[4g+l][t], plus an
//                                  explicit tap/lane swap guard
//   * an off-by-one at a bank edge -> [6] beat 0 and beat 127 of both banks
//
// Sections
//   [1] bank A: 128 beats written, then read 0..127 in order
//   [2] bank B: 128 beats written and read; bank A re-read untouched
//   [3] read latency is exactly one clock
//   [4] read-first on a same-address write
//   [5] beat layout: 4 groups x 36 bytes, kernel built in the testbench
//   [6] bank edges
// =============================================================================

module tb_weight_bram;

    localparam int NB = 128;            // beats per bank

    logic              clk    = 0;
    logic              w_en   = 0;
    logic [7:0]        w_addr = 0;
    logic [287:0]      w_data = 0;
    logic [7:0]        r_addr = 0;
    logic [287:0]      r_data;

    always #5 clk = ~clk;

    weight_bram #(.BEATBITS(7)) dut (
        .clk    (clk),
        .w_en   (w_en),
        .w_addr (w_addr),
        .w_data (w_data),
        .r_addr (r_addr),
        .r_data (r_data)
    );

    int checks = 0;
    int fails  = 0;

    task automatic tick();
        @(posedge clk);
        #1;
    endtask

    // whole-beat compare; on failure it names the offending byte by tap/lane
    task automatic chkw(input string what, input logic [287:0] got, input logic [287:0] exp);
        checks++;
        if (got !== exp) begin
            fails++;
            if (fails <= 20) begin
                $display("  FAIL [%s] t=%0t", what, $time);
                for (int i = 0; i < 36; i++)
                    if (got[8*i +: 8] !== exp[8*i +: 8])
                        $display("     byte %0d (tap %0d, lane %0d): got %02x want %02x",
                                 i, i/4, i%4, got[8*i +: 8], exp[8*i +: 8]);
            end
        end
    endtask

    task automatic chkb(input string what, input logic [7:0] got, input logic [7:0] exp);
        checks++;
        if (got !== exp) begin
            fails++;
            if (fails <= 20)
                $display("  FAIL [%s] t=%0t got %02x want %02x", what, $time, got, exp);
        end
    endtask

    task automatic wr(input logic bank, input int beat, input logic [287:0] d);
        w_en   = 1'b1;
        w_addr = {bank, beat[6:0]};
        w_data = d;
        tick();
        w_en   = 1'b0;
    endtask

    task automatic rd(input logic bank, input int beat, output logic [287:0] d);
        r_addr = {bank, beat[6:0]};
        tick();                     // BRAM is registered: data lands after this edge
        d = r_data;
    endtask

    // ---- test patterns ----------------------------------------------------
    // every one of the 36 bytes is distinct, so any shift or rotation shows
    function automatic logic [287:0] pat(input logic bank, input int beat);
        logic [287:0] w;
        for (int i = 0; i < 36; i++)
            w[8*i +: 8] = 8'((bank ? 128 : 0) + i*7 + beat*3);
        pat = w;
    endfunction

    // a plausible int8 kernel value for output channel ch, tap t (range -100..105)
    function automatic logic signed [7:0] wval(input int ch, input int t);
        int v;
        v = ch*11 + t*5 - 100;
        wval = v[7:0];
    endfunction

    // build one beat for output-channel group g straight from the format rule:
    //   beat byte (4*t + l) = w[channel 4*g + l][tap t]
    function automatic logic [287:0] mkbeat(input int g);
        logic [287:0] w;
        w = '0;
        for (int t = 0; t < 9; t++)
            for (int l = 0; l < 4; l++)
                w[8*(4*t+l) +: 8] = wval(4*g + l, t);
        mkbeat = w;
    endfunction

    logic [287:0] got;
    logic [7:0]   gb;

    initial begin
        $dumpfile("sim/tb_weight_bram.vcd");
        $dumpvars(0, tb_weight_bram);

        $display("=== tb_weight_bram  (2 banks x %0d beats x 288 bits) ===", NB);

        // ------------------------------------------------------------------
        $display("[1] bank A: write %0d beats, then read 0..%0d", NB, NB-1);
        for (int i = 0; i < NB; i++)
            wr(1'b0, i, pat(1'b0, i));

        // NOTE: the last write was beat 127. Reading from 0 catches any read
        // path that indexes with w_addr instead of r_addr.
        for (int i = 0; i < NB; i++) begin
            rd(1'b0, i, got);
            chkw("bankA readback", got, pat(1'b0, i));
        end

        // ------------------------------------------------------------------
        $display("[2] bank B: write %0d beats and read back; re-read bank A", NB);
        for (int i = 0; i < NB; i++)
            wr(1'b1, i, pat(1'b1, i));

        for (int i = 0; i < NB; i++) begin
            rd(1'b1, i, got);
            chkw("bankB readback", got, pat(1'b1, i));
        end

        for (int i = 0; i < NB; i++) begin
            rd(1'b0, i, got);
            chkw("bankA survived bankB writes", got, pat(1'b0, i));
        end

        // ------------------------------------------------------------------
        $display("[3] read latency: exactly one clock");
        rd(1'b0, 0, got);
        chkw("word 0 visible", got, pat(1'b0, 0));

        r_addr = {1'b0, 7'd5};
        chkw("address change NOT visible this clock", r_data, pat(1'b0, 0));
        tick();
        chkw("visible one clock later", r_data, pat(1'b0, 5));

        r_addr = {1'b1, 7'd9};
        chkw("still holding bank A beat 5", r_data, pat(1'b0, 5));
        tick();
        chkw("bank B beat 9 after one clock", r_data, pat(1'b1, 9));

        // ------------------------------------------------------------------
        $display("[4] read-first: same-cycle read of the written address is OLD");
        w_en   = 1'b1;
        w_addr = {1'b0, 7'd40};
        w_data = 288'hDEAD_BEEF;
        r_addr = {1'b0, 7'd40};
        tick();
        chkw("read-first returns old contents", r_data, pat(1'b0, 40));

        w_en = 1'b0;
        tick();
        chkw("write landed", r_data, 288'hDEAD_BEEF);

        // ------------------------------------------------------------------
        // Four output groups = 16 channels. Each beat is built with the format
        // rule, written, read back, and checked byte by byte at slice
        // [8*(4t+l) +: 8] — the same slice pe_array taps.
        $display("[5] beat layout: 4 groups x 9 taps x 4 lanes");
        for (int g = 0; g < 4; g++) begin
            wr(1'b0, 20+g, mkbeat(g));
            rd(1'b0, 20+g, got);

            for (int t = 0; t < 9; t++)
                for (int l = 0; l < 4; l++) begin
                    gb = got[8*(4*t+l) +: 8];
                    chkb($sformatf("layout g%0d tap%0d lane%0d", g, t, l), gb, wval(4*g+l, t));
                end

            // transposition guard: byte 4 holds tap 1 lane 0, NOT tap 0 lane 1
            chkb("byte 4 is tap1/lane0", got[8*(4*1+0) +: 8], wval(4*g+0, 1));
            checks++;
            if (got[8*(4*1+0) +: 8] === wval(4*g+1, 0)) begin
                fails++;
                $display("  FAIL byte 4 matches tap0/lane1 — beat is lane-major");
            end
        end

        // ------------------------------------------------------------------
        $display("[6] bank edges");
        rd(1'b0, 0,   got); chkw("bankA beat 0",   got, pat(1'b0, 0));
        rd(1'b0, 127, got); chkw("bankA beat 127", got, pat(1'b0, 127));
        rd(1'b1, 0,   got); chkw("bankB beat 0",   got, pat(1'b1, 0));
        rd(1'b1, 127, got); chkw("bankB beat 127", got, pat(1'b1, 127));

        // ------------------------------------------------------------------
        $display("");
        $display("checks: %0d   failures: %0d", checks, fails);

        if (checks < 500) $fatal(1, "only %0d checks ran — a loop exited early", checks);
        if (fails != 0)   $fatal(1, "%0d failures", fails);

        $display("RESULT: ALL PASS");
        $finish;
    end

endmodule
