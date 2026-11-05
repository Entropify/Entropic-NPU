`timescale 1ns/1ps
`default_nettype none

module tb_adder_tree;

    logic clk = 0, rst = 1;

    logic freeze  = 0;
    logic capture = 0;

    logic signed [31:0] d0 = 0, d1 = 0, d2 = 0, d3 = 0, d4 = 0,
                        d5 = 0, d6 = 0, d7 = 0, d8 = 0;

    logic signed [31:0] sum;

    int checks = 0;
    int fails  = 0;

    adder_tree dut (
        .clk     (clk),
        .rst     (rst),
        .freeze  (freeze),
        .capture (capture),
        .d0      (d0), .d1 (d1), .d2 (d2), .d3 (d3), .d4 (d4),
        .d5      (d5), .d6 (d6), .d7 (d7), .d8 (d8),
        .sum     (sum)
    );

    always #5 clk = ~clk;        // 100 MHz

    task tick(); begin @(posedge clk); #1; end endtask

    // drive all nine inputs at once
    task set_d(input signed [31:0] v0, v1, v2, v3, v4, v5, v6, v7, v8);
    begin
        d0 = v0; d1 = v1; d2 = v2; d3 = v3; d4 = v4;
        d5 = v5; d6 = v6; d7 = v7; d8 = v8;
    end endtask

    // drive all nine inputs to the same value
    task set_all(input signed [31:0] v);
    begin
        set_d(v, v, v, v, v, v, v, v, v);
    end endtask

    // pulse capture for exactly one clock
    task capture_now();
    begin
        capture = 1;
        tick();
        capture = 0;
    end endtask

    task check_sum(input signed [31:0] want, input string what);
    begin
        checks = checks + 1;
        if (sum !== want) begin
            fails = fails + 1;
            $display("      FAIL  %-46s sum = %0d, wanted %0d", what, sum, want);
        end else
            $display("      pass  %-46s sum = %0d", what, sum);
    end endtask

    initial begin

        $dumpfile("sim/tb_adder_tree.vcd");
        $dumpvars(0, tb_adder_tree);

        repeat(3) tick(); rst = 0; tick();          // reset first

        // ---- [1] reset ----
        $display("\n[1] reset");
        check_sum(0, "sum is 0 after reset");

        // ---- [2] the basic sum ----
        $display("\n[2] 1 + 2 + ... + 9");
        set_d(32'sd1, 32'sd2, 32'sd3, 32'sd4, 32'sd5,
              32'sd6, 32'sd7, 32'sd8, 32'sd9);
        capture_now();
        check_sum(45, "sum of 1..9");

        // ---- [3] negative inputs ----
        $display("\n[3] negatives: -1 + -2 + ... + -9");
        set_d(-32'sd1, -32'sd2, -32'sd3, -32'sd4, -32'sd5,
              -32'sd6, -32'sd7, -32'sd8, -32'sd9);
        capture_now();
        check_sum(-45, "sum of -1..-9 (signed inputs)");

        // ---- [4] cancellation ----
        $display("\n[4] 100 and -100 cancel");
        set_d(32'sd100, -32'sd100, 32'sd0, 32'sd0, 32'sd0,
              32'sd0,   32'sd0,   32'sd0, 32'sd0);
        capture_now();
        check_sum(0, "100 + (-100) + zeros");

        // ---- [5] no capture means no change ----
        $display("\n[5] inputs change but capture stays low");
        set_all(32'sd777);
        repeat(3) tick();                            // capture is 0
        check_sum(0, "holds the old value: capture was never asserted");

        // ---- [6] freeze beats capture ----
        $display("\n[6] freeze asserted together with capture");
        freeze  = 1;
        set_all(32'sd1234);
        capture = 1; tick(); capture = 0;
        check_sum(0, "frozen: nothing captured, sum still holds");
        freeze = 0;

        // ---- [7] a realistic single-product extreme ----
        $display("\n[7] nine products of -128 x 255");
        set_all(32'sd32640);
        capture_now();
        check_sum(293760, "9 x 32640");

        // ---- [8] the worst case in the whole network (FC layer) ----
        $display("\n[8] the FC-layer worst case");
        set_all(32'sd7049640);
        capture_now();
        check_sum(63446760, "9 x 7,049,640 = 63.4M, proves int32 is enough");

        // ---- summary ----
        $display("\n==================================================");
        $display("  checks: %0d    failures: %0d", checks, fails);
        if (fails == 0) $display("  RESULT: ALL PASS");
        else            $display("  RESULT: *** %0d FAILURES ***", fails);
        $display("==================================================\n");

        if (checks < 8) $fatal(1, "only %0d checks ran", checks);
        if (fails  != 0) $fatal(1, "verification failed");
        $finish;

    end

endmodule

`default_nettype wire
