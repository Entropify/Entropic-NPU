`timescale 1ns/1ps

// =============================================================================
// tb_crc32 — reflected CRC-32 against known answers
//
// Every expected value below was produced by the same algorithm in Python and
// cross-checked against zlib.crc32, so a mismatch means the RTL is wrong, not
// the bench.
//
// What this bench is trying to break:
//   * wrong polynomial (0x04C11DB7 instead of 0xEDB88320)  -> [4] golden vector
//   * wrong shift direction                                 -> [4]
//   * init = 0 instead of 0xFFFFFFFF                        -> [6] zero bytes
//   * missing final XOR                                     -> [1],[3],[4]
//   * state not carried between bytes                       -> [4] 9 bytes
//   * init not clearing state                               -> [8]
//   * a byte being folded twice / skipped                   -> [7]
//
// Sections
//   [1] reset value: register FFFFFFFF -> port 00000000
//   [2] init holds that value
//   [3] empty frame
//   [4] "123456789" -> 0xCBF43926   (the universal check vector)
//   [5] single bytes 0x00 and 0xFF
//   [6] four zero bytes -> 0x2144DF1C  (proves init is not zero)
//   [7] one flipped bit changes everything
//   [8] init mid-stream restarts the fingerprint
//   [9] valid low: the value holds
// =============================================================================

module tb_crc32;

    logic        clk   = 0;
    logic        rst   = 1;
    logic        init  = 0;
    logic        valid = 0;
    logic [7:0]  data  = 0;
    logic [31:0] crc;

    always #5 clk = ~clk;

    crc32 dut (
        .clk   (clk),
        .rst   (rst),
        .init  (init),
        .valid (valid),
        .data  (data),
        .crc   (crc)
    );

    int checks = 0;
    int fails  = 0;

    task automatic tick();
        @(posedge clk);
        #1;
    endtask

    task automatic chk(input string what, input logic [31:0] got, input logic [31:0] exp);
        checks++;
        if (got !== exp) begin
            fails++;
            $display("  FAIL [%s] got %08X want %08X", what, got, exp);
        end
    endtask

    task automatic do_init();
        init = 1'b1; valid = 1'b0; data = 8'h00;
        tick();
        init = 1'b0;
    endtask

    task automatic feed(input logic [7:0] b);
        valid = 1'b1; data = b;
        tick();
        valid = 1'b0;
    endtask

    task automatic feed_123456789();
        feed(8'h31); feed(8'h32); feed(8'h33);
        feed(8'h34); feed(8'h35); feed(8'h36);
        feed(8'h37); feed(8'h38); feed(8'h39);
    endtask

    initial begin
        $dumpfile("sim/tb_crc32.vcd");
        $dumpvars(0, tb_crc32);

        $display("=== tb_crc32 ===");

        // ------------------------------------------------------------------
        $display("[1] reset value");
        tick();
        chk("after reset", crc, 32'h0000_0000);   // FFFFFFFF complemented
        rst = 0;
        tick();
        chk("after reset released", crc, 32'h0000_0000);

        // ------------------------------------------------------------------
        $display("[2] init holds the same value");
        do_init();
        chk("after init", crc, 32'h0000_0000);

        // ------------------------------------------------------------------
        $display("[3] empty frame");
        do_init();
        chk("empty payload", crc, 32'h0000_0000);

        // ------------------------------------------------------------------
        $display("[4] golden vector  \"123456789\"");
        do_init();
        feed_123456789();
        chk("123456789", crc, 32'hCBF4_3926);

        // ------------------------------------------------------------------
        $display("[5] single bytes");
        do_init();
        feed(8'h00);
        chk("single 0x00", crc, 32'hD202_EF8D);

        do_init();
        feed(8'hFF);
        chk("single 0xFF", crc, 32'hFF00_0000);

        // ------------------------------------------------------------------
        $display("[6] four zero bytes (init must not be zero)");
        do_init();
        feed(8'h00); feed(8'h00); feed(8'h00); feed(8'h00);
        chk("0000_0000", crc, 32'h2144_DF1C);

        // ------------------------------------------------------------------
        $display("[7] one flipped bit changes the answer");
        do_init();
        feed(8'h30);                       // '0' instead of '1'
        feed(8'h32); feed(8'h33);
        feed(8'h34); feed(8'h35); feed(8'h36);
        feed(8'h37); feed(8'h38); feed(8'h39);
        chk("023456789", crc, 32'hDC8F_2D65);
        checks++;
        if (crc == 32'hCBF4_3926) begin
            fails++;
            $display("  FAIL one flipped bit gave the same CRC");
        end

        // ------------------------------------------------------------------
        $display("[8] init mid-stream restarts");
        do_init();
        feed_123456789();
        do_init();                          // throw it away
        feed_123456789();
        chk("re-run after init", crc, 32'hCBF4_3926);

        // ------------------------------------------------------------------
        $display("[9] valid low: value holds");
        begin
            logic [31:0] held;
            held = crc;
            for (int i = 0; i < 20; i++) tick();
            chk("held for 20 clocks", crc, held);
        end

        // ------------------------------------------------------------------
        $display("");
        $display("checks: %0d   failures: %0d", checks, fails);

        if (checks < 11) $fatal(1, "only %0d checks ran", checks);
        if (fails != 0)  $fatal(1, "%0d failures", fails);

        $display("RESULT: ALL PASS");
        $finish;
    end

endmodule
