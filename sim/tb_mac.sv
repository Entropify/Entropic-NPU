`timescale 1ns/1ps
`default_nettype none




module tb_mac;

    logic clk = 0, rst = 1;


    logic valid = 0;
    logic first = 0;
    logic last = 0;
    logic freeze = 0;

    logic signed [7:0] weight = 0;
    logic [7:0] activation = 0;


    logic signed [31:0] acc;

    logic valid_out;
    logic done;

    int checks = 0;
    int fails = 0;
    int t = 0;

    logic got = 0;

    mac dut (.clk(clk),
             .rst(rst), 
             .valid(valid), 
             .first(first), 
             .last(last),
             .freeze(freeze), 
             .weight(weight),
             .activation(activation),
             .acc(acc),
             .valid_out(valid_out),
             .done(done)
             );



    always #5 clk = ~clk; // 100 MHz clk (10ns clkperiod)



    task tick(); 
        
        @(posedge clk) #1; 
        
    endtask


    task beat(input signed [7:0] w, input [7:0] a, input logic f, input logic l);

        weight = w; 
        activation = a; 
        first = f; 
        last = l; 
        valid = 1;

        tick();

        valid = 0;
        first = 0;
        last = 0;
        weight = 0;
        activation = 0;

    endtask



    task wait_done(input int limit);

        t = 0;
        got = 0;

        while (t < limit && !got) begin 
            tick(); t = t + 1; 
            if (done) got = 1; 
        end
        
            if (!got) begin
            checks = checks + 1;
            fails = fails + 1;
            $display("FAIL  not done in %0d ticks", limit);
        end
    endtask



    task check_acc(input signed [31:0] want, input string what);

        checks = checks + 1;


        if (acc !== want) begin
            fails = fails + 1;
            $display("FAIL  %-46s acc = %0d, wanted %0d", what, acc, want);
        
        end else $display("pass  %-46s acc = %0d", what, acc);
            
    endtask



    task check_flags(input logic wd, input logic wv, input string what);

        checks = checks + 1;


        if (done !== wd || valid_out !== wv) begin

            fails = fails + 1;
            $display("FAIL  %-46s done=%b valid_out=%b", what, done, valid_out);

        end 

        else $display("pass  %-46s done=%b valid_out=%b", what, done, valid_out);

    endtask



    initial begin

        $dumpfile("sim/tb_mac.vcd");        // run from the project root
        $dumpvars(0, tb_mac);

        repeat(3) tick();
        rst = 0; 
        tick();



        //reset 
        $display("\n[1] reset");
        check_acc(0, "acc is 0 after reset");
        check_flags(1'b0, 1'b0, "done and valid_out are 0 after reset");



        // single beat first=1 and last=1
        $display("\n[2] single beat (first=1, last=1)");

        beat(8'sd3, 8'd7, 1'b1, 1'b1);  
        wait_done(20);  
        check_acc(21, "+3 x +7");

        beat(-8'sd3, 8'd7, 1'b1, 1'b1);  
        wait_done(20);  
        check_acc(-21, "-3 x +7");

        beat(-8'sd128, 8'd255, 1'b1, 1'b1);  
        wait_done(20);  
        check_acc(-32640, "-128 x 255 (extreme)");

        beat(-8'sd3, 8'd249, 1'b1, 1'b1);  
        wait_done(20);  
        check_acc(-747, "-3 x 249 (249 is -7 unsigned)");



        // several beats into ONE dot product
        $display("\n[3] three beats: 2x5 + 4x5 + 6x5 = 10 + 20 + 30");

        beat(8'sd2, 8'd5, 1'b1, 1'b0);
        beat(8'sd4, 8'd5, 1'b0, 1'b0);
        beat(8'sd6, 8'd5, 1'b0, 1'b1);

        wait_done(20);
        check_acc(60, "sum of the three products");



        // first=1 starts a NEW sum
        $display("\n[4] a new batch with first=1 wipes the previous sum");
        beat(8'sd7, 8'd2, 1'b1, 1'b1);
        wait_done(20);
        check_acc(14, "new sum only: the old 60 must be gone");



        // valid=0 means the beat is ignored
        $display("\n[5] junk on the bus with valid=0 must do nothing");

        beat(8'sd5, 8'd5, 1'b1, 1'b1);
        wait_done(20);
        check_acc(25, "baseline");

        valid = 0; 
        first = 0; 
        last = 0; 
        weight = -8'sd128; 
        activation = 8'd255;

        tick();

        weight = 0; 
        activation = 0;

        repeat(4) tick();
        check_acc(25, "unchanged after a tick with valid=0");



        // first/last are meaningless without valid
        $display("\n[6] first=1 and last=1 but valid=0 must do nothing");

        valid = 0; 
        first = 1; 
        last = 1; 
        weight = -8'sd128; 
        activation = 8'd255;

        tick();

        first = 0; 
        last = 0; 
        weight = 0; 
        activation = 0;

        repeat(4) tick();
        check_acc(25, "unchanged after a stray first/last with valid=0");



        // freeze holds EVERYTHING
        $display("\n[7] freeze in the middle of a sum");
        beat(8'sd2, 8'd5, 1'b1, 1'b0);
        beat(8'sd4, 8'd5, 1'b0, 1'b0);

        repeat(4) tick();

        check_acc(30, "two beats accumulated before the freeze");
        freeze = 1;

        repeat(3) begin
            tick();
            check_acc(30, "acc holds while frozen");
            check_flags(1'b0, 1'b0, "done stays 0 while frozen");
        end

        freeze = 0;



        // a beat held across a freeze is not lost
        $display("\n[8] final beat held across a freeze");

        weight = 8'sd6; 
        activation = 8'd5; 
        first = 0; 
        last = 1; 
        valid = 1;
        freeze = 1;

        repeat(3) tick();
        freeze = 0;
        tick();

        valid = 0; 
        last = 0; 
        weight = 0; 
        activation = 0;

        wait_done(20);
        check_acc(60, "held final beat landed: 30 + 30");



        // freeze while a batch is in flight
        $display("\n[9] freeze while a batch is in flight");

        beat(8'sd1, 8'd2, 1'b1, 1'b0);
        beat(8'sd1, 8'd4, 1'b0, 1'b0);
        beat(8'sd1, 8'd6, 1'b0, 1'b1);

        tick();                              
        check_flags(1'b0, 1'b1, "in the window: valid_out high, done low");

        freeze = 1;

        repeat(2) begin
            tick();
            check_flags(1'b0, 1'b0, "frozen: acc did not change, so valid_out must be 0");
        end

        freeze = 0;
        wait_done(20);
        check_acc(12, "batch completed: 2 + 4 + 6");



        // summary

        $display("\n==================================================");

        $display("  checks: %0d    failures: %0d", checks, fails);
        if (fails == 0) $display("  RESULT: ALL PASS");
        else $display("  RESULT: *** %0d FAILURES ***", fails);

        $display("==================================================\n");

        if (checks < 20) $fatal(1, "only %0d checks ran, the suite did not exercise the design", checks);
        if (fails != 0) $fatal(1, "verification failed");

        $finish;

    end


endmodule


`default_nettype wire
