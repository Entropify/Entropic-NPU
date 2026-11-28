`timescale 1ns/1ps

// =============================================================================
// tb_bias_ram — 64 words x 128 bits
//
//   [1] write all 64 words, read them all back
//   [2] per-lane check on one word (a lane swap hides in a whole-word compare)
//   [3] registered read: address at T, data at T+1
//   [4] no write: r_data holds
// =============================================================================

module tb_bias_ram;

    logic clk = 0;
    logic w_en = 0;
    logic [5:0] w_addr = 0;
    logic [127:0] w_data = 0;
    logic [5:0] r_addr = 0;
    logic [127:0] r_data;

    always #5 clk = ~clk;

    bias_ram dut (

        .clk(clk),
        .w_en(w_en),
        .w_addr(w_addr),
        .w_data(w_data),
        .r_addr(r_addr),
        .r_data(r_data)

    );

    int checks = 0;
    int fails = 0;

    // four distinct 32-bit lanes per word
    function automatic logic [127:0] pat(input int i);

        pat = {32'(i*4+3), 32'(i*4+2), 32'(i*4+1), 32'(i*4)};

    endfunction

    task automatic tick();

        @(posedge clk);
        #1;

    endtask

    task automatic chk(input string what, input logic [127:0] got, input logic [127:0] exp);

        checks++;

        if (got !== exp) begin

            fails++;
            $display("  FAIL [%s] got %032x want %032x", what, got, exp);

        end

    endtask

    task automatic wr(input logic [5:0] i);

        w_en = 1'b1;
        w_addr = i;
        w_data = pat(32'(i));
        tick();
        w_en = 1'b0;

    endtask

    task automatic rd(input logic [5:0] i, output logic [127:0] d);

        r_addr = i;
        tick();
        d = r_data;

    endtask

    logic [127:0] d;

    initial begin

        $dumpfile("sim/tb_bias_ram.vcd");
        $dumpvars(0, tb_bias_ram);

        $display("=== tb_bias_ram ===");

        $display("[1] write 64 words, read back");
        for (int i = 0; i < 64; i++) wr(6'(i));

        for (int i = 0; i < 64; i++) begin

            rd(6'(i), d);
            chk($sformatf("word %0d", i), d, pat(32'(i)));

        end

        $display("[2] lane check on word 7");
        rd(6'd7, d);

        for (int k = 0; k < 4; k++) begin

            checks++;

            if (d[32*k +: 32] !== 32'(7*4+k)) begin

                fails++;
                $display("  FAIL lane %0d got %08x want %08x", k, d[32*k +: 32], 7*4+k);

            end

        end

        $display("[3] registered read");
        rd(6'd0, d);
        r_addr = 6'd5;

        checks++;

        if (r_data !== d) begin

            fails++;
            $display("  FAIL latency: data changed in the same clock");

        end

        tick();

        checks++;

        if (r_data !== pat(5)) begin

            fails++;
            $display("  FAIL latency: wrong data one clock later");

        end

        $display("[4] no write, value holds");
        for (int i = 0; i < 10; i++) tick();

        checks++;

        if (r_data !== pat(5)) begin

            fails++;
            $display("  FAIL hold: r_data drifted with no write");

        end

        $display("");
        $display("checks: %0d   failures: %0d", checks, fails);

        if (fails != 0) $fatal(1, "%0d failures", fails);

        $display("RESULT: ALL PASS");
        $finish;

    end

endmodule
