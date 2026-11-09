
// tb_pool.sv  --  testbench for pool (2x2 max pool, 4 lanes per beat)
//
// What it is trying to break:
//   * reset not reaching the output register
//   * output produced on an even row or an even column (parity gating wrong)
//   * one of the four 2x2 inputs not reaching the comparator
//   * a lane reading another lane's data (din[1] <- in2, out2 <- out1, ...)
//   * `prev` written one cycle late, so the pair max uses the wrong left pixel
//   * `rowbuff` indexed by x instead of x/2 (works for x=0,1 only)
//   * groups sharing storage (g ignored)
//   * g_out not aligned with the data it labels
//   * W/2 depth wrong for the 22-wide conv2 map (last column overflows)
//   * output count wrong (576 for 48x48, 121 for 22x22)
//
// Run from the project root:
//   $ verilator --binary --timing --trace -Wno-fatal --top-module tb_pool \
//         --Mdir sim/build/vpool sim/tb_pool.sv rtl/compute/pool.sv
//   $ ./sim/build/vpool/Vtb_pool        (writes sim/tb_pool.vcd)
//   $ gtkwave -a sim/tb_pool.gtkw sim/tb_pool.vcd

`timescale 1ns/1ps
`default_nettype none

module tb_pool;

    logic clk = 0, rst = 1, valid_in = 0;
    logic [1:0] g;
    logic [5:0] x, y;
    logic [7:0] in0, in1, in2, in3;
    logic       valid_out;
    logic [1:0] g_out;
    logic [7:0] out0, out1, out2, out3;

    // second instance: conv2's shape (22 wide -> 11 pooled columns)
    logic       b_valid_in = 0;
    logic [1:0] b_g;
    logic [5:0] b_x, b_y;
    logic [7:0] b_in0;
    logic       b_valid_out;
    logic [7:0] b_out0;

    int checks = 0, fails = 0, pulses = 0, sweep_err = 0;

    pool #(.W(48)) dut (
        .clk(clk), .rst(rst), .valid_in(valid_in),
        .g(g), .x(x), .y(y),
        .in0(in0), .in1(in1), .in2(in2), .in3(in3),
        .valid_out(valid_out), .g_out(g_out),
        .out0(out0), .out1(out1), .out2(out2), .out3(out3)
    );

    pool #(.W(22)) dut22 (
        .clk(clk), .rst(rst), .valid_in(b_valid_in),
        .g(b_g), .x(b_x), .y(b_y),
        .in0(b_in0), .in1(8'd0), .in2(8'd0), .in3(8'd0),
        .valid_out(b_valid_out), .g_out(),
        .out0(b_out0), .out1(), .out2(), .out3()
    );

    always #5 clk = ~clk;

    task tick(); begin @(posedge clk); #1; end endtask


    // stimulus

    // one beat, all four lanes, raw values
    task send4(input logic [1:0] gg, input int xx, yy,
               input int v0, v1, v2, v3);
        begin
            g = gg; x = xx[5:0]; y = yy[5:0];
            in0 = v0[7:0]; in1 = v1[7:0]; in2 = v2[7:0]; in3 = v3[7:0];
            valid_in = 1;
            tick();
            valid_in = 0;
            if (valid_out) pulses = pulses + 1;
        end
    endtask

    // one beat, lane 0 only (lanes 1-3 forced to zero)
    task send(input logic [1:0] gg, input int xx, yy, input int v);
        begin
            send4(gg, xx, yy, v, 0, 0, 0);
        end
    endtask

    // one beat on the 22-wide instance, lane 0 only
    task send_b(input int xx, yy, input int v);
        begin
            b_g = 2'd0; b_x = xx[5:0]; b_y = yy[5:0]; b_in0 = v[7:0];
            b_valid_in = 1;
            tick();
            b_valid_in = 0;
        end
    endtask


    // checkers

    task chk(input logic [7:0] got, input int want, input string what);
        begin
            checks = checks + 1;
            if (got !== want[7:0]) begin
                fails = fails + 1;
                $display("      FAIL  %-46s got %0d, wanted %0d", what, got, want);
            end else
                $display("      pass  %-46s %0d", what, got);
        end
    endtask

    task chk4(input logic [7:0] g0, g1, g2, g3,
              input int w0, w1, w2, w3, input string what);
        begin
            checks = checks + 1;
            if (g0 !== w0[7:0] || g1 !== w1[7:0] || g2 !== w2[7:0] || g3 !== w3[7:0]) begin
                fails = fails + 1;
                $display("      FAIL  %-46s got %0d/%0d/%0d/%0d wanted %0d/%0d/%0d/%0d",
                         what, g0, g1, g2, g3, w0, w1, w2, w3);
            end else
                $display("      pass  %-46s %0d/%0d/%0d/%0d", what, g0, g1, g2, g3);
        end
    endtask

    task chk2(input logic [1:0] got, input int want, input string what);
        begin
            checks = checks + 1;
            if (got !== want[1:0]) begin
                fails = fails + 1;
                $display("      FAIL  %-46s got %0d, wanted %0d", what, got, want);
            end else
                $display("      pass  %-46s %0d", what, got);
        end
    endtask

    task chk_int(input int got, want, input string what);
        begin
            checks = checks + 1;
            if (got !== want) begin
                fails = fails + 1;
                $display("      FAIL  %-46s got %0d, wanted %0d", what, got, want);
            end else
                $display("      pass  %-46s %0d", what, got);
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


    initial begin

        $dumpfile("sim/tb_pool.vcd");
        $dumpvars(0, tb_pool);


        repeat(3) tick();
        rst = 0;
        tick();

        //  [1] reset 
        $display("\n[1] reset");
        chk_flag(valid_out, 1'b0, "valid_out low");
        chk(out0, 0, "out0 zero");
        chk_flag(b_valid_out, 1'b0, "22-wide instance also reset");

        //  [2] even rows emit nothing 
        $display("\n[2] an upper row files, never emits");
        send(2'd0, 0, 0, 9);  send(2'd0, 1, 0, 9);
        send(2'd0, 2, 0, 9);  send(2'd0, 3, 0, 9);
        chk_flag(valid_out, 1'b0, "four beats, zero outputs");
        // even column on a lower row must also be silent
        send(2'd0, 0, 1, 9);
        chk_flag(valid_out, 1'b0, "lower row, even column: silent");

        //  [3] the max in each corner 
        $display("\n[3] max in each of the four 2x2 corners");
        rst = 1; tick(); rst = 0; tick();
        send(2'd0, 0, 0, 200); send(2'd0, 1, 0, 5);
        send(2'd0, 0, 1, 5);   send(2'd0, 1, 1, 5);
        chk(out0, 200, "max at (x, y)");

        rst = 1; tick(); rst = 0; tick();
        send(2'd0, 0, 0, 5);   send(2'd0, 1, 0, 200);
        send(2'd0, 0, 1, 5);   send(2'd0, 1, 1, 5);
        chk(out0, 200, "max at (x+1, y)");

        rst = 1; tick(); rst = 0; tick();
        send(2'd0, 0, 0, 5);   send(2'd0, 1, 0, 5);
        send(2'd0, 0, 1, 200); send(2'd0, 1, 1, 5);
        chk(out0, 200, "max at (x, y+1)");

        rst = 1; tick(); rst = 0; tick();
        send(2'd0, 0, 0, 5);   send(2'd0, 1, 0, 5);
        send(2'd0, 0, 1, 5);   send(2'd0, 1, 1, 200);
        chk(out0, 200, "max at (x+1, y+1)");

        //  [4] a whole 4x4 map 
        $display("\n[4] 4x4 map -> 2x2 result, every block checked");
        rst = 1; tick(); rst = 0; tick();
        send(2'd0, 0, 0, 1);  send(2'd0, 1, 0, 2);
        chk_flag(valid_out, 1'b0, "row 0: nothing");
        send(2'd0, 2, 0, 3);  send(2'd0, 3, 0, 4);
        send(2'd0, 0, 1, 5);
        chk_flag(valid_out, 1'b0, "row 1, even column: nothing");
        send(2'd0, 1, 1, 6);
        chk(out0, 6, "block (0,0) = max(1,2,5,6)");
        chk4(out0, out1, out2, out3, 6, 0, 0, 0, "lanes 1-3 not fed by lane 0");
        send(2'd0, 2, 1, 7);  send(2'd0, 3, 1, 8);
        chk(out0, 8, "block (1,0) = max(3,4,7,8)");
        send(2'd0, 0, 2, 9);  send(2'd0, 1, 2, 10);
        send(2'd0, 2, 2, 11); send(2'd0, 3, 2, 12);
        chk_flag(valid_out, 1'b0, "row 2: nothing");
        send(2'd0, 0, 3, 13); send(2'd0, 1, 3, 14);
        chk(out0, 14, "block (0,1) = max(9,10,13,14)");
        send(2'd0, 2, 3, 15); send(2'd0, 3, 3, 16);
        chk(out0, 16, "block (1,1) = max(11,12,15,16)");

        //  [5] lane independence 
        $display("\n[5] each lane keeps its own data");
        rst = 1; tick(); rst = 0; tick();
        send4(2'd0, 0, 0, 10, 20, 30, 40);
        send4(2'd0, 1, 0, 10, 20, 30, 40);
        send4(2'd0, 0, 1, 10, 20, 30, 40);
        send4(2'd0, 1, 1, 10, 20, 30, 40);
        chk4(out0, out1, out2, out3, 10, 20, 30, 40, "ascending");

        send4(2'd0, 0, 0, 40, 30, 20, 10);
        send4(2'd0, 1, 0, 40, 30, 20, 10);
        send4(2'd0, 0, 1, 40, 30, 20, 10);
        send4(2'd0, 1, 1, 40, 30, 20, 10);
        chk4(out0, out1, out2, out3, 40, 30, 20, 10, "permuted");

        //  [6] g_out rides with the data 
        $display("\n[6] g_out labels the byte it came with");
        rst = 1; tick(); rst = 0; tick();
        send4(2'd2, 0, 0, 7, 7, 7, 7);
        send4(2'd2, 1, 0, 7, 7, 7, 7);
        send4(2'd2, 0, 1, 7, 7, 7, 7);
        send4(2'd2, 1, 1, 7, 7, 7, 7);
        chk(out0, 7, "value out");
        chk2(g_out, 2, "g_out = 2, the group of that beat");

        //  [7] back-to-back groups 
        // conv1's stream: g=0 then g=1 on consecutive clocks, same pixel
        $display("\n[7] two groups, consecutive clocks (conv1's pattern)");
        rst = 1; tick(); rst = 0; tick();
        send(2'd0, 0, 0, 100);  send(2'd1, 0, 0, 200);   // x=0, upper row
        send(2'd0, 1, 0, 100);  send(2'd1, 1, 0, 200);   // x=1, upper row -> rowbuff both
        send(2'd0, 0, 1, 100);  send(2'd1, 0, 1, 200);   // x=0, lower row
        send(2'd0, 1, 1, 100);
        chk(out0, 100, "group 0 byte");
        chk2(g_out, 0, "labelled group 0");
        send(2'd1, 1, 1, 200);
        chk(out0, 200, "group 1 byte on the very next clock");
        chk2(g_out, 1, "labelled group 1");

        //  [8] full 48x48 sweep 
        // value = x, so every pooled byte must equal its (odd) column number,
        // which exercises all 24 rowbuff columns including x[5:1] = 23
        $display("\n[8] 48x48 sweep: value = x, expect out = x, count 576");
        rst = 1; tick(); rst = 0; tick();
        pulses   = 0;
        sweep_err = 0;
        for (int yy = 0; yy < 48; yy++) begin
            for (int xx = 0; xx < 48; xx++) begin
                send(2'd0, xx, yy, xx);
                if (valid_out) begin
                    if (out0 !== xx[7:0]) begin
                        if (sweep_err < 4)
                            $display("      (mismatch at x=%0d y=%0d: out0=%0d)", xx, yy, out0);
                        sweep_err = sweep_err + 1;
                    end
                end
            end
        end
        chk_int(sweep_err, 0, "every pooled byte equals its column");
        chk_int(pulses, 24*24, "576 outputs from 2304 pixels");

        //  [9] the 22-wide (conv2) shape 
        $display("\n[9] W = 22 instance: 11x11 outputs, last column ok");
        rst = 1; tick(); rst = 0; tick();
        pulses   = 0;
        sweep_err = 0;
        for (int yy = 0; yy < 22; yy++) begin
            for (int xx = 0; xx < 22; xx++) begin
                send_b(xx, yy, xx);
                if (b_valid_out) begin
                    pulses = pulses + 1;
                    if (b_out0 !== xx[7:0]) sweep_err = sweep_err + 1;
                end
            end
        end
        chk_int(pulses, 11*11, "121 outputs from 484 pixels");
        chk_int(sweep_err, 0, "22-wide map: all values correct");

        //  summary 
        $display("\n==================================================");
        $display("  checks: %0d    failures: %0d", checks, fails);
        if (fails == 0) $display("  RESULT: ALL PASS");
        else            $display("  RESULT: *** %0d FAILURES ***", fails);
        $display("==================================================\n");

        if (checks < 25) $fatal(1, "only %0d checks ran", checks);
        if (fails  != 0) $fatal(1, "verification failed");
        $finish;

    end

endmodule

`default_nettype wire
