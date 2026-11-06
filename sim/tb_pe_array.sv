
// tb_pe_array.sv  --  thorough testbench for pe_array (9 taps x 4 lanes)
//
// What it is trying to break:
//   * reset not reaching all 36 MACs / 4 trees
//   * wrong latency (dot must appear 1 clock AFTER done)
//   * weight bus indexing: tap/lane transposed, or lsb misaligned per lane
//   * missing $signed() on the weight slices
//   * tree fed acc_q[lane][tap] instead of acc_q[tap][lane]
//   * control (valid/first/last/freeze) not reaching every MAC
//   * a job starting before the previous one is captured (no busy state)
//
// Run from the project root:
//   iverilog -g2012 -Wall -s tb_pe_array -o sim/build/pe_sim \
//       sim/tb_pe_array.sv rtl/compute/pe_array.sv rtl/compute/mac.sv rtl/compute/adder_tree.sv
//   ./sim/build/pe_sim

`timescale 1ns/1ps
`default_nettype none

module tb_pe_array;

    localparam int TP = 9;          // taps
    localparam int LN = 4;          // lanes

    logic clk = 0, rst = 1;

    logic valid = 0, first = 0, last = 0, freeze = 0;

    logic [8*TP-1:0]      act    = '0;
    logic [8*TP*LN-1:0]   weight = '0;

    logic [32*LN-1:0]     dot;
    logic                 done;
    logic [32*TP*LN-1:0]  acc_debug;

    int   checks = 0;
    int   fails  = 0;
    int   t_wd   = 0;
    logic got    = 0;

  
    pe_array dut (
        .clk       (clk),
        .rst       (rst),
        .valid     (valid),
        .first     (first),
        .last      (last),
        .freeze    (freeze),
        .act       (act),
        .weight    (weight),
        .dot       (dot),
        .done      (done),
        .acc_debug (acc_debug)
    );

    always #5 clk = ~clk;               // 100 MHz

    task tick(); begin @(posedge clk); #1; end endtask


    // stimulus helpers

    // act[t] = base + step*t
    task set_act(input int base, input int step);
        int t;
        for (t = 0; t < TP; t++) act[8*t +: 8] = (base + step*t) & 255;
    endtask

    task set_act_uniform(input int v);
        int t;
        for (t = 0; t < TP; t++) act[8*t +: 8] = v & 255;
    endtask

    // weight[t][l] = base + step_l*l + step_t*t
    task set_wgt(input int base, input int step_l, input int step_t);
        int t, l;
        for (t = 0; t < TP; t++)
            for (l = 0; l < LN; l++)
                weight[8*(LN*t + l) +: 8] = (base + step_l*l + step_t*t) & 255;
    endtask

    task set_wgt_uniform(input int v);
        int t, l;
        for (t = 0; t < TP; t++)
            for (l = 0; l < LN; l++)
                weight[8*(LN*t + l) +: 8] = v & 255;
    endtask

    // every weight negative:  -(10*l + t + 1)
    task set_wgt_neg();
        int t, l;
        for (t = 0; t < TP; t++)
            for (l = 0; l < LN; l++)
                weight[8*(LN*t + l) +: 8] = (-(10*l + t + 1)) & 255;
    endtask

    // 1 on one lane only, 0 on the rest
    task set_wgt_one_lane(input int lsel);
        int t, l;
        for (t = 0; t < TP; t++)
            for (l = 0; l < LN; l++)
                weight[8*(LN*t + l) +: 8] = (l == lsel) ? 8'd1 : 8'd0;
    endtask

    // one beat: valid for exactly one clock, stickers then cleared
    task beat(input logic f, input logic l);
    begin
        valid = 1; first = f; last = l;
        tick();
        valid = 0; first = 0; last = 0;
    end endtask

    task wait_done(input int limit);
    begin
        t_wd = 0; got = 0;
        while (t_wd < limit && !got) begin
            tick();
            t_wd = t_wd + 1;
            if (done) got = 1;
        end
        if (!got) begin
            checks = checks + 1;
            fails  = fails + 1;
            $display("      FAIL  no done within %0d ticks", limit);
        end
    end endtask


    // checking helpers

    task check_dot(input int lane, input signed [31:0] want, input string what);
        logic signed [31:0] v;
    begin
        v = $signed(dot[32*lane +: 32]);
        checks = checks + 1;
        if (v !== want) begin
            fails = fails + 1;
            $display("      FAIL  lane %0d  %-38s dot = %0d, wanted %0d",
                     lane, what, v, want);
        end else
            $display("      pass  lane %0d  %-38s dot = %0d", lane, what, v);
    end endtask

    task check_dot4(input signed [31:0] d0, d1, d2, d3, input string what);
    begin
        check_dot(0, d0, what);
        check_dot(1, d1, what);
        check_dot(2, d2, what);
        check_dot(3, d3, what);
    end endtask

    task check_done(input logic want, input string what);
    begin
        checks = checks + 1;
        if (done !== want) begin
            fails = fails + 1;
            $display("      FAIL  %-44s done = %b", what, done);
        end else
            $display("      pass  %-44s done = %b", what, done);
    end endtask

    task check_acc(input int tap, input int lane, input signed [31:0] want, input string what);
        logic signed [31:0] v;
    begin
        v = $signed(acc_debug[32*(LN*tap + lane) +: 32]);
        checks = checks + 1;
        if (v !== want) begin
            fails = fails + 1;
            $display("      FAIL  acc(%0d,%0d) %-26s = %0d, wanted %0d",
                     tap, lane, what, v, want);
        end else
            $display("      pass  acc(%0d,%0d) %-26s = %0d", tap, lane, what, v);
    end endtask

    // =====================================================================
    initial begin

        $dumpfile("sim/tb_pe_array.vcd");
        $dumpvars(0, tb_pe_array);

        repeat(3) tick();
        rst = 0;
        tick();

        // ---------------- [1] reset ----------------
        $display("\n[1] reset");
        check_dot4(0, 0, 0, 0, "zero after reset");
        check_done(1'b0, "done low after reset");

        // ---------------- [2] latency ----------------
        // act=1, w=1, one beat -> each MAC does 1x1, tree = 9.
        // Expected: done at T+3, dot at T+4 (the tree adds one clock).
        $display("\n[2] latency: single beat, act=1 w=1 -> dot = 9");
        set_act_uniform(1);
        set_wgt_uniform(1);
        beat(1'b1, 1'b1);                                   // returns in T+1
        check_done(1'b0, "T+1: done low");
        tick();
        check_done(1'b0, "T+2: done low");
        tick();
        check_done(1'b1, "T+3: done HIGH");
        check_dot4(0, 0, 0, 0, "T+3: dot is still the old value");
        tick();
        check_dot4(9, 9, 9, 9, "T+4: dot updated");

        // ---------------- [3] the checksum beat ----------------
        // act[t] = t+1, weight[t][l] = 10*l + (t+1)
        // dot[l] = sum_t (10l + t+1)(t+1) = 450*l + 285
        $display("\n[3] checksum: all 36 weights + all 9 activations in one beat");
        set_act(1, 1);
        set_wgt(1, 10, 1);
        beat(1'b1, 1'b1);
        wait_done(20);
        tick();                                             // tree clock
        check_dot4(285, 735, 1185, 1635, "checksum");
        // and the raw per-MAC products, spot-checked in both indices
        check_acc(0, 0,   1, "act1 x w1");
        check_acc(0, 3,  31, "act1 x w31");
        check_acc(2, 1,  39, "act3 x w13");
        check_acc(4, 2, 125, "act5 x w25");
        check_acc(8, 0,  81, "act9 x w9");
        check_acc(8, 3, 351, "act9 x w39");

        // ---------------- [4] negative weights ----------------
        $display("\n[4] every weight negative");
        set_act(1, 1);
        set_wgt_neg();
        beat(1'b1, 1'b1);
        wait_done(20);
        tick();
        check_dot4(-285, -735, -1185, -1635, "negated");

        // ---------------- [5] lane independence ----------------
        // Only one lane has non-zero weights: only that lane may move.
        $display("\n[5] lane independence");
        set_act(1, 1);
        set_wgt_one_lane(0);
        beat(1'b1, 1'b1);
        wait_done(20);
        tick();
        check_dot4(45, 0, 0, 0, "only lane 0 weighted");

        set_wgt_one_lane(2);
        beat(1'b1, 1'b1);
        wait_done(20);
        tick();
        check_dot4(0, 0, 45, 0, "only lane 2 weighted");

        // ---------------- [6] multi-beat accumulation ----------------
        // weight[t][l] = l+1 ; acts = (t+1), 2(t+1), 3(t+1) over 3 beats
        // each MAC = (l+1)*6*(t+1); tree = (l+1)*6*45 = 270*(l+1)
        $display("\n[6] three beats accumulate (conv2 shape)");
        set_wgt(1, 1, 0);
        set_act(1, 1);  beat(1'b1, 1'b0);
        set_act(2, 2);  beat(1'b0, 1'b0);
        set_act(3, 3);  beat(1'b0, 1'b1);
        wait_done(20);
        tick();
        check_dot4(270, 540, 810, 1080, "three beats");

        // ---------------- [7] first wipes the old total ----------------
        $display("\n[7] a new first beat wipes the previous total");
        set_act_uniform(1);
        set_wgt_uniform(1);
        beat(1'b1, 1'b1);
        wait_done(20);
        tick();
        check_dot4(9, 9, 9, 9, "old totals gone");

        // ---------------- [8] freeze mid-job ----------------
        $display("\n[8] freeze in the middle of a job");
        set_act_uniform(1);
        set_wgt_uniform(1);
        beat(1'b1, 1'b0);               // beat 1
        beat(1'b0, 1'b0);               // beat 2
        tick(); tick();                 // let both accumulators settle
        check_dot4(9, 9, 9, 9, "dot still holds the last completed job");
        freeze = 1;
        tick();
        check_dot4(9, 9, 9, 9, "frozen: dot unchanged");
        check_done(1'b0, "frozen: done low");
        tick();
        check_done(1'b0, "frozen again: done still low");
        freeze = 0;
        beat(1'b0, 1'b1);               // beat 3 = last
        wait_done(20);
        tick();
        check_dot4(27, 27, 27, 27, "3 beats x 9 taps");

        // ---------------- [9] a beat held across a freeze ----------------
        $display("\n[9] final beat presented while frozen");
        set_wgt_uniform(1);
        set_act_uniform(1);
        beat(1'b1, 1'b0);               // beat 1 -> 1 per MAC
        freeze = 1;
        // freeze holds the PIPELINE REGISTERS; it does not latch the inputs.
        // So the beat must stay asserted until the first clock after release,
        // otherwise it was never sampled at all.
        valid = 1; last = 1;
        tick();                         // frozen: nothing is sampled
        freeze = 0;
        tick();                         // released: the held beat is sampled here
        valid = 0; last = 0;
        wait_done(20);
        tick();
        check_dot4(18, 18, 18, 18, "held beat landed exactly once");

        // ---------------- [10] junk with valid = 0 ----------------
        $display("\n[10] worst-case junk on the bus, valid = 0");
        valid = 0;
        set_act_uniform(255);
        set_wgt_uniform(255);           // 255 = -1 as a signed byte
        repeat(4) tick();
        check_dot4(18, 18, 18, 18, "nothing moved");
        set_act_uniform(1);
        set_wgt_uniform(1);
        beat(1'b1, 1'b1);
        wait_done(20);
        tick();
        check_dot4(9, 9, 9, 9, "clean job after the junk");

        // ---------------- [11] stickers without data ----------------
        $display("\n[11] first/last asserted with valid = 0");
        valid = 0; first = 1; last = 1;
        repeat(3) tick();
        first = 0; last = 0;
        check_done(1'b0, "stray first/last did not fire done");
        check_dot4(9, 9, 9, 9, "dot unchanged");

        // ---------------- summary ----------------
        $display("\n==================================================");
        $display("  checks: %0d    failures: %0d", checks, fails);
        if (fails == 0) $display("  RESULT: ALL PASS");
        else            $display("  RESULT: *** %0d FAILURES ***", fails);
        $display("==================================================\n");

        if (checks < 60) $fatal(1, "only %0d checks ran", checks);
        if (fails  != 0) $fatal(1, "verification failed");
        $finish;

    end

endmodule

`default_nettype wire
