`timescale 1ns/1ps

// =============================================================================
// tb_desc_ram — 16 words x 128 bits, one descriptor per layer
//
//   [1] write all 16 words, read them all back
//   [2] per-byte check on one word (descriptor fields are bytes, not lanes)
//   [3] registered read: address at T, data at T+1
//   [4] no write: r_data holds
//   [5] address 15 and address 0 are distinct (top of the table)
// =============================================================================

module tb_desc_ram;

    logic clk = 0;
    logic w_en = 0;
    logic [3:0] w_addr = 0;
    logic [127:0] w_data = 0;
    logic [3:0] r_addr = 0;
    logic [127:0] r_data;

    always #5 clk = ~clk;

    desc_ram dut (

        .clk(clk),
        .w_en(w_en),
        .w_addr(w_addr),
        .w_data(w_data),
        .r_addr(r_addr),
        .r_data(r_data)

    );

    int checks = 0;
    int fails = 0;

    // every byte distinct, so a shifted descriptor shows up
    function automatic logic [127:0] pat(input int i);

        logic [127:0] w;

        w = '0;

        for (int k = 0; k < 16; k++) begin

            w[8*k +: 8] = 8'(i*16 + k);

        end

        pat = w;

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

    task automatic wr(input logic [3:0] i);

        w_en = 1'b1;
        w_addr = i;
        w_data = pat(32'(i));
        tick();
        w_en = 1'b0;

    endtask

    task automatic rd(input logic [3:0] i, output logic [127:0] d);

        r_addr = i;
        tick();
        d = r_data;

    endtask

    logic [127:0] d;

    initial begin

        $dumpfile("sim/tb_desc_ram.vcd");
        $dumpvars(0, tb_desc_ram);

        $display("=== tb_desc_ram ===");

        $display("[1] write 16 words, read back");
        for (int i = 0; i < 16; i++) wr(4'(i));

        for (int i = 0; i < 16; i++) begin

            rd(4'(i), d);
            chk($sformatf("word %0d", i), d, pat(32'(i)));

        end

        $display("[2] byte check on word 5");
        rd(4'd5, d);

        for (int k = 0; k < 16; k++) begin

            checks++;

            if (d[8*k +: 8] !== 8'(5*16 + k)) begin

                fails++;
                $display("  FAIL byte %0d got %02x want %02x", k, d[8*k +: 8], 5*16 + k);

            end

        end

        $display("[3] registered read");
        rd(4'd0, d);
        r_addr = 4'd9;

        checks++;

        if (r_data !== d) begin

            fails++;
            $display("  FAIL latency: data changed in the same clock");

        end

        tick();

        checks++;

        if (r_data !== pat(9)) begin

            fails++;
            $display("  FAIL latency: wrong data one clock later");

        end

        $display("[4] no write, value holds");
        for (int i = 0; i < 10; i++) tick();

        checks++;

        if (r_data !== pat(9)) begin

            fails++;
            $display("  FAIL hold: r_data drifted with no write");

        end

        $display("[5] word 0 and word 15 are distinct");
        begin

            logic [127:0] d0;
            logic [127:0] d15;

            rd(4'd0, d0);
            rd(4'd15, d15);

            checks++;

            if (d0 === d15) begin

                fails++;
                $display("  FAIL word 0 and word 15 hold the same data");

            end

            chk("word 15", d15, pat(15));

        end

        $display("");
        $display("checks: %0d   failures: %0d", checks, fails);

        if (fails != 0) $fatal(1, "%0d failures", fails);

        $display("RESULT: ALL PASS");
        $finish;

    end

endmodule
