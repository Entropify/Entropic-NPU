// =============================================================================
// tb_argmax.sv  --  testbench for argmax (N signed logits in, class index out)
//
// What it is trying to break:
//   * unsigned comparison (every negative logit would win)
//   * best/best_idx not reseeded per inference (answer 2 = answer 1)
//   * seed value 0 instead of int32_min (all-negative set reports slot 0)
//   * collect mask missing (junk lanes become classes)
//   * compare walking past n_classes (stale slots win)
//   * wrong slot addressing (g*4+l) -- caught by the 16-class test hitting slot 15
//   * bias not added, or added to the wrong lane
//   * tie-breaking (must be lowest index: strict '>')
//   * valid_out not a single-cycle pulse
//   * err not raised for n_classes > max_classes
//   * err not raised when last_in arrives on the wrong group
//
// NOTE: g is [1:0] today, so only 16 classes are reachable (slot 15). Once g
// becomes [2:0] for the 26-class letter model, add a 7-beat 26-class case.
//
// Run from the project root:
//   $ verilator --binary --timing --trace -Wno-fatal --top-module tb_argmax \
//         --Mdir sim/build/vargmax sim/tb_argmax.sv rtl/compute/argmax.sv
//   $ ./sim/build/vargmax/Vtb_argmax        (writes sim/tb_argmax.vcd)
//   $ gtkwave -a sim/tb_argmax.gtkw sim/tb_argmax.vcd
// =============================================================================
`timescale 1ns/1ps
`default_nettype none

module tb_argmax;

    logic clk = 0, rst = 1, valid_in = 0, last_in = 0;
    logic [1:0] g;
    logic [5:0] n_classes;

    logic signed [31:0] logit0, logit1, logit2, logit3;
    logic signed [31:0] bias0, bias1, bias2, bias3;

    logic               valid_out;
    logic [4:0]         class_index;
    logic signed [31:0] max_val;
    logic               err;

    int checks = 0, fails = 0;
    int got_cls, got_val;
    logic got_ok;

    argmax dut (
        .clk(clk), .rst(rst),
        .valid_in(valid_in), .g(g), .last_in(last_in), .n_classes(n_classes),
        .logit0(logit0), .logit1(logit1), .logit2(logit2), .logit3(logit3),
        .bias0(bias0), .bias1(bias1), .bias2(bias2), .bias3(bias3),
        .valid_out(valid_out), .class_index(class_index),
        .max_val(max_val), .err(err)
    );

    always #5 clk = ~clk;

    task tick(); begin @(posedge clk); #1; end endtask

    // one beat: four logits, four biases, and the "this is the last group" flag
    task send(input logic [1:0] gg, input int v0, v1, v2, v3,
              input int b0, b1, b2, b3, input logic last);
        begin
            g = gg;
            logit0 = v0; logit1 = v1; logit2 = v2; logit3 = v3;
            bias0  = b0; bias1  = b1; bias2  = b2; bias3  = b3;
            last_in = last; valid_in = 1;
            tick();
            valid_in = 0; last_in = 0;
        end
    endtask

    // same, with all biases zero
    task send0(input logic [1:0] gg, input int v0, v1, v2, v3, input logic last);
        begin
            send(gg, v0, v1, v2, v3, 0, 0, 0, 0, last);
        end
    endtask

    // wait for the answer, capture it, let valid_out fall
    task wait_out();
        int guard = 0;
        begin
            got_ok = 1'b0;
            while (!valid_out && guard < 120) begin tick(); guard = guard + 1; end
            if (valid_out) begin
                got_ok  = 1'b1;
                got_cls = class_index;
                got_val = max_val;
            end
            tick();
        end
    endtask

    task chk_cls(input int want, input string what);
        begin
            checks = checks + 1;
            if (!got_ok) begin
                fails = fails + 1;
                $display("      FAIL  %-46s no valid_out", what);
            end else if (got_cls !== want) begin
                fails = fails + 1;
                $display("      FAIL  %-46s class %0d, wanted %0d", what, got_cls, want);
            end else
                $display("      pass  %-46s class %0d", what, got_cls);
        end
    endtask

    task chk_val(input int want, input string what);
        begin
            checks = checks + 1;
            if (!got_ok) begin
                fails = fails + 1;
                $display("      FAIL  %-46s no valid_out", what);
            end else if (got_val !== want) begin
                fails = fails + 1;
                $display("      FAIL  %-46s max_val %0d, wanted %0d", what, got_val, want);
            end else
                $display("      pass  %-46s max_val %0d", what, got_val);
        end
    endtask

    task chk_flag(input logic got, want, input string what);
        begin
            checks = checks + 1;
            if (got !== want) begin
                fails = fails + 1;
                $display("      FAIL  %-46s got %b, wanted %b", what, got, want);
            end else
                $display("      pass  %-46s %b", what, got);
        end
    endtask

    task do_reset();
        begin
            rst = 1; tick(); tick(); rst = 0; tick();
        end
    endtask

    // =====================================================================
    initial begin

        $dumpfile("sim/tb_argmax.vcd");
        $dumpvars(0, tb_argmax);

        repeat(3) tick();
        rst = 0;
        tick();

        // ---------------- [1] reset ----------------
        $display("\n[1] reset");
        chk_flag(valid_out, 1'b0, "valid_out low");
        chk_flag(err, 1'b0, "err low");

        // ---------------- [2] 4 classes, max in each position ----------------
        $display("\n[2] 4 classes, max in each of the four slots");
        n_classes = 6'd4;

        send0(2'd0, 9, 5, 2, 7, 1'b1); wait_out();
        chk_cls(0, "max in slot 0");
        chk_val(9, "value from slot 0");

        send0(2'd0, 5, 9, 2, 7, 1'b1); wait_out();
        chk_cls(1, "max in slot 1");

        send0(2'd0, 5, 7, 9, 2, 1'b1); wait_out();
        chk_cls(2, "max in slot 2");

        send0(2'd0, 5, 7, 2, 9, 1'b1); wait_out();
        chk_cls(3, "max in slot 3");
        chk_flag(valid_out, 1'b0, "valid_out is a single-cycle pulse");

        // ---------------- [3] all negative ----------------
        $display("\n[3] every logit negative (signed compare)");
        send0(2'd0, -5, -2, -9, -7, 1'b1); wait_out();
        chk_cls(1, "least negative wins: index 1");
        chk_val(-2, "max_val is -2");

        // ---------------- [4] 10 classes, junk in masked lanes ----------------
        $display("\n[4] 10 classes over 3 beats, junk in lanes 10-11");
        n_classes = 6'd10;
        send0(2'd0, 1, 2, 3, 4, 1'b0);
        send0(2'd1, 5, 6, 7, 8, 1'b0);
        send0(2'd2, 9, 1, 500, 600, 1'b1);      // slots 8,9 real; 500/600 masked
        wait_out();
        chk_cls(8, "junk in masked lanes ignored, slot 8 wins");
        chk_val(9, "value 9");

        // ---------------- [5] bias per lane ----------------
        $display("\n[5] bias lifts a lower logit");
        n_classes = 6'd4;
        send(2'd0, 10, 9, 0, 0,   0, 50, 0, 0, 1'b1);
        wait_out();
        chk_cls(1, "bias 50 lifts index 1 above index 0");
        chk_val(59, "max_val includes the bias");

        // ---------------- [6] tie ----------------
        $display("\n[6] tie at the top");
        send0(2'd0, 5, 5, 2, 1, 1'b1); wait_out();
        chk_cls(0, "tie: lowest index wins");

        // ---------------- [7] single class ----------------
        $display("\n[7] n_classes = 1");
        n_classes = 6'd1;
        send0(2'd0, 7, 99, 99, 99, 1'b1); wait_out();
        chk_cls(0, "only class 0 is legal");
        chk_val(7, "its value");

        // ---------------- [8] 16 classes: the top reachable slot ----------------
        $display("\n[8] 16 classes, max in slot 15 (last group, last lane)");
        n_classes = 6'd16;
        send0(2'd0, 1,  2,  3,  4,  1'b0);
        send0(2'd1, 5,  6,  7,  8,  1'b0);
        send0(2'd2, 9, 10, 11, 12,  1'b0);
        send0(2'd3, 13, 14, 15, 900, 1'b1);
        wait_out();
        chk_cls(15, "slot 15 addressed correctly");
        chk_val(900, "value 900");

        // ---------------- [9] back-to-back inferences ----------------
        $display("\n[9] second inference does not inherit the first");
        n_classes = 6'd4;
        send0(2'd0, 5, 9, 2, 7, 1'b1); wait_out();
        chk_cls(1, "inference A: index 1");
        send0(2'd0, 1, 2, 3, 8, 1'b1); wait_out();
        chk_cls(3, "inference B: index 3 (best reseeded)");

        // ---------------- [10] n_classes > max_classes ----------------
        $display("\n[10] n_classes larger than the hardware capacity");
        do_reset();
        n_classes = 6'd40;
        send0(2'd0, 1, 2, 3, 4, 1'b1);
        repeat(8) tick();
        chk_flag(err, 1'b1, "err raised for 40 classes");
        chk_flag(valid_out, 1'b0, "no answer emitted");

        // ---------------- [11] last_in on the wrong group ----------------
        $display("\n[11] last_in on the wrong group (beat count mismatch)");
        do_reset();
        n_classes = 6'd10;                     // 10 classes => last group must be g=2
        send0(2'd0, 1, 2, 3, 4, 1'b1);         // claims last at g=0
        repeat(8) tick();
        chk_flag(err, 1'b1, "err raised for a group-count mismatch");
        chk_flag(valid_out, 1'b0, "no answer emitted");

        // ---------------- summary ----------------
        $display("\n==================================================");
        $display("  checks: %0d    failures: %0d", checks, fails);
        if (fails == 0) $display("  RESULT: ALL PASS");
        else            $display("  RESULT: *** %0d FAILURES ***", fails);
        $display("==================================================\n");

        if (checks < 18) $fatal(1, "only %0d checks ran", checks);
        if (fails  != 0) $fatal(1, "verification failed");
        $finish;

    end

endmodule

`default_nettype wire
