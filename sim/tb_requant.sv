// =============================================================================
// tb_requant.sv  --  thorough testbench for requant (4 lanes, 32-bit acc -> byte)
//
// What it is trying to break:
//   * bias added AFTER the shift        (819 would give 255 instead of 13)
//   * bias added AFTER the clamp        (-1000+1500 would give 23 instead of 8)
//   * truncation instead of rounding    (every value 1 low)
//   * no rounding at all                (exact halves round down)
//   * wrap instead of saturate          (256 -> 0, 300 -> 44)
//   * missing $signed on acc/bias       (negatives -> 255 instead of 0)
//   * shift == 0 falling through to the rounding path
//   * a lane using another lane's acc/bias
//   * valid_out pulse wrong in length or position
//   * q moving while valid_in is low
//
// Run from the project root:
//   $ verilator --binary --timing --trace -Wno-fatal --top-module tb_requant \
//         --Mdir sim/build/vrq sim/tb_requant.sv rtl/compute/requant.sv
//   $ ./sim/build/vrq/Vtb_requant        (writes sim/tb_requant.vcd)
//   $ gtkwave -a sim/tb_requant.gtkw sim/tb_requant.vcd
// =============================================================================
`timescale 1ns/1ps
`default_nettype none

module tb_requant;

    logic clk = 0, rst = 1, valid_in = 0;

    logic signed [31:0] acc0, acc1, acc2, acc3;
    logic signed [31:0] bias0, bias1, bias2, bias3;
    logic        [ 5:0] shift;

    logic [7:0] q0, q1, q2, q3;
    logic       valid_out;

    int checks = 0;
    int fails  = 0;

    // ---------------------------------------------------------------------
    requant dut (
        .clk       (clk),
        .rst       (rst),
        .valid_in  (valid_in),
        .acc0      (acc0),
        .acc1      (acc1),
        .acc2      (acc2),
        .acc3      (acc3),
        .bias0     (bias0),
        .bias1     (bias1),
        .bias2     (bias2),
        .bias3     (bias3),
        .shift     (shift),
        .q0        (q0),
        .q1        (q1),
        .q2        (q2),
        .q3        (q3),
        .valid_out (valid_out)
    );

    always #5 clk = ~clk;               // 100 MHz

    task tick(); begin @(posedge clk); #1; end endtask

    // exactly one clock of valid_in
    task pulse_valid(); begin valid_in = 1; tick(); valid_in = 0; end endtask

    // ---------------------------------------------------------------------
    // stimulus
    // ---------------------------------------------------------------------
    task set_all(
        input int a0, a1, a2, a3,
        input int b0, b1, b2, b3,
        input logic [5:0] sh
    );
        begin
            acc0 = a0; acc1 = a1; acc2 = a2; acc3 = a3;
            bias0 = b0; bias1 = b1; bias2 = b2; bias3 = b3;
            shift = sh;
        end
    endtask

    // one scalar case, lane 0 only: pulse, check q0, then let valid_out fall
    task one(input int a, b, input logic [5:0] sh, input int want, input string what);
        begin
            set_all(a, 0, 0, 0, b, 0, 0, 0, sh);
            pulse_valid();
            check_q0(want[7:0], what);
            tick();
        end
    endtask

    // ---------------------------------------------------------------------
    // checkers
    // ---------------------------------------------------------------------
    task check_q0(input logic [7:0] want, input string what);
        begin
            checks = checks + 1;
            if (q0 !== want) begin
                fails = fails + 1;
                $display("      FAIL  %-46s q0 = %0d, wanted %0d", what, q0, want);
            end else
                $display("      pass  %-46s q0 = %0d", what, q0);
        end
    endtask

    task check_q4(input logic [7:0] w0, w1, w2, w3, input string what);
        begin
            checks = checks + 1;
            if (q0 !== w0 || q1 !== w1 || q2 !== w2 || q3 !== w3) begin
                fails = fails + 1;
                $display("      FAIL  %-46s %0d/%0d/%0d/%0d, wanted %0d/%0d/%0d/%0d",
                         what, q0, q1, q2, q3, w0, w1, w2, w3);
            end else
                $display("      pass  %-46s %0d/%0d/%0d/%0d", what, q0, q1, q2, q3);
        end
    endtask

    task check_flag(input logic want, input string what);
        begin
            checks = checks + 1;
            if (valid_out !== want) begin
                fails = fails + 1;
                $display("      FAIL  %-46s valid_out = %b", what, valid_out);
            end else
                $display("      pass  %-46s valid_out = %b", what, valid_out);
        end
    endtask

    // =====================================================================
    initial begin

        $dumpfile("sim/tb_requant.vcd");
        $dumpvars(0, tb_requant);

        repeat(3) tick();
        rst = 0;
        tick();

        // ---------------- [1] reset ----------------
        $display("\n[1] reset");
        check_q4(0, 0, 0, 0, "all four lanes zero");
        check_flag(1'b0, "valid_out low after reset");

        // ---------------- [2] latency + four independent lanes ----------------
        // same acc in lanes 0-2, different bias per lane:
        //   lane0 6062+819  = 6881 -> 108
        //   lane1 6062+0    = 6062 ->  95
        //   lane2 6062-819  = 5243 ->  82
        //   lane3 0         =    0 ->   0
        $display("\n[2] four lanes, per-lane bias, latency, hold");
        set_all(6062, 6062, 6062, 0,  819, 0, -819, 0,  6'd6);
        pulse_valid();
        check_q4(108, 95, 82, 0, "each lane uses its own bias");
        check_flag(1'b1, "valid_out high 1 cycle after valid_in");
        tick();
        check_flag(1'b0, "valid_out is a single-cycle pulse");
        check_q4(108, 95, 82, 0, "q holds while valid_in is low");

        // ---------------- [3] rounding at shift 6 ----------------
        // step = 64, half = 32
        $display("\n[3] rounding (shift 6, half step = 32)");
        one(32,    0, 6'd6,   1, "acc 32  = 0.50 step -> rounds UP to 1");
        one(31,    0, 6'd6,   0, "acc 31  = 0.48 step -> rounds down to 0");
        one(33,    0, 6'd6,   1, "acc 33  = 0.52 step -> 1");
        one(95,    0, 6'd6,   1, "acc 95  = 1.48 step -> 1");
        one(96,    0, 6'd6,   2, "acc 96  = 1.50 step -> rounds UP to 2");

        // ---------------- [4] order of operations ----------------
        $display("\n[4] order: bias before shift, bias before clamp");
        one(0,     819,  6'd6,  13, "bias 819 alone -> 13, not 255");
        one(-1000, 1500, 6'd6,   8, "acc -1000 + bias 1500 -> 8, not 23");
        one(60000, -9000,6'd6, 255, "huge acc still saturates");

        // ---------------- [5] saturation ----------------
        $display("\n[5] saturation, never wrap");
        one(16384, 0, 6'd6, 255, "16384/64 = 256 -> 255 (not 0)");
        one(300,   0, 6'd6,   5, "300/64 = 4.7 -> 5 (small, not clamped)");
        one(16000, 0, 6'd6, 250, "16000/64 = 250.5 -> 250");
        one(16288, 0, 6'd6, 255, "16288/64 = 254.5 -> 255");
        one(16287, 0, 6'd6, 254, "16287/64 = 254.48 -> 254");
        one(100000,0, 6'd6, 255, "far above range -> 255");

        // ---------------- [6] negatives and ReLU ----------------
        $display("\n[6] floor at 0 is the ReLU");
        one(-1,    0, 6'd6,   0, "-1 -> 0");
        one(-5000, 0, 6'd6,   0, "-5000 -> 0");
        one(0,  -5000, 6'd6,  0, "negative bias alone -> 0");
        one(63,    0, 6'd6,   1, "63/64 = 0.98 -> 1");
        one(-32,   0, 6'd6,   0, "-0.5 step -> 0 after clamp");

        // ---------------- [7] shift = 0 ----------------
        $display("\n[7] shift 0: no scaling, still clamps");
        one(0,     0, 6'd0,   0, "0 -> 0");
        one(200,   0, 6'd0, 200, "200 -> 200 (identity)");
        one(255,   0, 6'd0, 255, "255 -> 255");
        one(256,   0, 6'd0, 255, "256 -> 255 (saturate, not 0)");
        one(-5,    0, 6'd0,   0, "-5 -> 0");
        one(0,   100, 6'd0, 100, "bias only -> 100");
        one(0,   300, 6'd0, 255, "bias alone saturates");

        // ---------------- [8] the shift is the gain knob ----------------
        // same acc = 6881, different shifts
        $display("\n[8] same accumulator, four shifts");
        one(6881, 0, 6'd4,  255, "s=4  -> 430 -> saturates");
        one(6881, 0, 6'd6,  108, "s=6  -> 108 (the working point)");
        one(6881, 0, 6'd8,   27, "s=8  -> 27");
        one(6881, 0, 6'd12,   2, "s=12 -> 2");

        // ---------------- [9] all four lanes at once, distinct ----------------
        // lane0 saturates, lane1 normal, lane2 goes negative, lane3 tiny
        $display("\n[9] four lanes: saturate / normal / clamp to 0 / small");
        set_all(50000, 6062, -819, 100,  0, 819, 0, 0,  6'd6);
        pulse_valid();
        check_q4(255, 108, 0, 2, "one job, four different outcomes");
        tick();

        // ---------------- [10] back-to-back beats ----------------
        // conv1 produces one group per clock, so requant gets valid_in every
        // cycle for thousands of cycles. Two beats with no gap must each land.
        $display("\n[10] valid_in every cycle (conv1 streams 1 group/clock)");
        set_all(100, 200, 300, 400,  0, 0, 0, 0,  6'd6);
        valid_in = 1;
        tick();
        check_q4(2, 3, 5, 6, "beat A lands");
        set_all(500, 600, 700, 800,  0, 0, 0, 0,  6'd6);
        tick();
        check_q4(8, 9, 11, 13, "beat B lands on the very next clock");
        valid_in = 0;
        tick();
        check_q4(8, 9, 11, 13, "q holds after the stream stops");

        // ---------------- summary ----------------
        $display("\n==================================================");
        $display("  checks: %0d    failures: %0d", checks, fails);
        if (fails == 0) $display("  RESULT: ALL PASS");
        else            $display("  RESULT: *** %0d FAILURES ***", fails);
        $display("==================================================\n");

        if (checks < 38) $fatal(1, "only %0d checks ran", checks);
        if (fails  != 0) $fatal(1, "verification failed");
        $finish;

    end

endmodule

`default_nettype wire
