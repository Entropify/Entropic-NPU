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



    always #5 clk = ~clk;       // 100 MHz clk



    task tick(); begin @(posedge clk); #1; end endtask


    task beat(input signed [7:0] w, input [7:0] a, input logic f, input logic l);
    begin
        weight = w; activation = a; first = f; last = l; valid = 1;
        tick();
        valid = 0; first = 0; last = 0; weight = 0; activation = 0;   // clear the bus!
    end endtask



    task wait_done(input int limit);
    begin
        t = 0; got = 0;
        while (t < limit && !got) begin tick(); t = t + 1; if (done) got = 1; end
        if (!got) begin fails = fails + 1; $display("      FAIL  no done in %0d ticks", limit); end
    end endtask



    task check_acc(input signed [31:0] want, input string what);
    begin

        checks = checks + 1;


        if (acc !== want) begin
            fails = fails + 1;
            $display("      FAIL  %-46s acc = %0d, wanted %0d", what, acc, want);
        
        end else $display("      pass  %-46s acc = %0d", what, acc);
            
    end endtask



    initial begin

        repeat(3) tick(); rst = 0; tick();          // reset FIRST
        // cases

        $display("  checks: %0d    failures: %0d", checks, fails);
        if (fails != 0) $fatal(1, "verification failed");    // non-zero exit
        $finish;

    end


endmodule


`default_nettype wire
