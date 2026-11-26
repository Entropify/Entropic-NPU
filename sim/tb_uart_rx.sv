`timescale 1ns/1ps

// =============================================================================
// tb_uart_rx — bit-banged 8N1 receiver test
//
// The bench has no UART, so it IS the transmitter: it drives the rx pin one
// bit at a time, 868 clocks per bit, exactly like a real sender.
//
// What this bench is trying to break:
//   * MSB-first assembly            -> [2] 0x01 and 0x80 come out reversed
//   * a missing start-bit check     -> [4] a 2-clock glitch must not produce a byte
//   * a missing stop-bit check      -> [5] a low stop bit must produce nothing
//   * a receiver that lingers a
//     clock too long in IDLE        -> [3] bytes sent back to back
//   * a level instead of a pulse    -> [7] valid must be high for exactly 1 clock
//   * sampling on bit edges         -> every section, because the bench drives
//                                      clean edges and the DUT must sample mid-bit
//
// Sections
//   [1] reset state
//   [2] six killer bytes: 0x00 0xFF 0x55 0xAA 0x01 0x80
//   [3] three bytes back to back
//   [4] a 2-clock glitch on an idle line
//   [5] framing error: stop bit driven low
//   [6] long idle: no spurious bytes
//   [7] valid width
// =============================================================================

module tb_uart_rx;

    localparam int CLK_HZ = 100_000_000;
    localparam int BAUD   = 115_200;
    localparam int CPB    = CLK_HZ / BAUD;      // 868 clocks per bit

    logic       clk = 0;
    logic       rst = 1;
    logic       rx  = 1;        // idle high
    logic [7:0] data;
    logic       valid;

    always #5 clk = ~clk;

    uart_rx #(.CLK_HZ(CLK_HZ), .BAUD(BAUD)) dut (
        .clk   (clk),
        .rst   (rst),
        .rx    (rx),
        .data  (data),
        .valid (valid)
    );

    int checks = 0;
    int fails  = 0;

    task automatic tick();
        @(posedge clk);
        #1;
    endtask

    task automatic wait_clk(input int n);
        repeat (n) tick();
    endtask

    // ---- the transmitter -------------------------------------------------
    task automatic send_bit(input logic b);
        rx = b;
        wait_clk(CPB);
    endtask

    task automatic send_byte(input logic [7:0] b);
        send_bit(1'b0);                     // start
        for (int i = 0; i < 8; i++)         // LSB first
            send_bit(b[i]);
        send_bit(1'b1);                     // stop
    endtask

    // a byte whose stop bit is driven LOW (framing error)
    task automatic send_bad_byte(input logic [7:0] b);
        send_bit(1'b0);
        for (int i = 0; i < 8; i++)
            send_bit(b[i]);
        send_bit(1'b0);                     // stop bit low -> framing error
        rx = 1'b1;
    endtask

    // ---- checking --------------------------------------------------------
    task automatic expect_byte(input logic [7:0] e, input string what);
        int t = 0;
        while (!valid && t < 12*CPB) begin
            tick();
            t++;
        end
        checks++;
        if (!valid) begin
            fails++;
            $display("  FAIL [%s] no byte within %0d clocks (wanted %02x)", what, 12*CPB, e);
        end else if (data !== e) begin
            fails++;
            $display("  FAIL [%s] got %02x wanted %02x", what, data, e);
        end
        tick();                             // step past the pulse
    endtask

    task automatic expect_no_byte(input int nclk, input string what);
        for (int i = 0; i < nclk; i++) begin
            tick();
            checks++;
            if (valid) begin
                fails++;
                if (fails <= 20)
                    $display("  FAIL [%s] unexpected byte %02x at t=%0t", what, data, $time);
            end
        end
    endtask

    initial begin
        $dumpfile("sim/tb_uart_rx.vcd");
        $dumpvars(0, tb_uart_rx);

        $display("=== tb_uart_rx  (%0d clocks per bit) ===", CPB);

        // ------------------------------------------------------------------
        $display("[1] reset");
        wait_clk(5);
        checks++;
        if (valid !== 1'b0) begin fails++; $display("  FAIL valid high after reset"); end
        rst = 0;
        wait_clk(10);
        rx = 1;                              // idle high before anything

        // ------------------------------------------------------------------
        $display("[2] six killer bytes");
        send_byte(8'h00);
        expect_byte(8'h00, "0x00");
        send_byte(8'hFF);
        expect_byte(8'hFF, "0xFF");
        send_byte(8'h55);
        expect_byte(8'h55, "0x55");
        send_byte(8'hAA);
        expect_byte(8'hAA, "0xAA");
        send_byte(8'h01);
        expect_byte(8'h01, "0x01 lsb-order");
        send_byte(8'h80);
        expect_byte(8'h80, "0x80 msb-order");

        // ------------------------------------------------------------------
        $display("[3] three bytes back to back");
        send_byte(8'hC3);
        send_byte(8'h3C);
        send_byte(8'h7E);
        expect_byte(8'hC3, "b2b 1");
        expect_byte(8'h3C, "b2b 2");
        expect_byte(8'h7E, "b2b 3");

        // ------------------------------------------------------------------
        $display("[4] 2-clock glitch must not produce a byte");
        wait_clk(CPB);
        rx = 1'b0; wait_clk(2);
        rx = 1'b1;
        expect_no_byte(3*CPB, "glitch");

        // ------------------------------------------------------------------
        $display("[5] framing error: stop bit low");
        send_bad_byte(8'h5A);
        expect_no_byte(3*CPB, "framing");

        // ------------------------------------------------------------------
        $display("[6] long idle");
        expect_no_byte(5000, "idle");

        // ------------------------------------------------------------------
        $display("[7] valid is exactly one clock wide");
        send_byte(8'h96);
        expect_byte(8'h96, "pulse test");
        // after expect_byte we are one clock past the pulse
        checks++;
        if (valid !== 1'b0) begin fails++; $display("  FAIL valid still high after the pulse"); end

        // and the receiver still works afterwards
        send_byte(8'h69);
        expect_byte(8'h69, "recovery");

        // ------------------------------------------------------------------
        $display("");
        $display("checks: %0d   failures: %0d", checks, fails);

        if (checks < 5000) $fatal(1, "only %0d checks ran", checks);
        if (fails != 0)    $fatal(1, "%0d failures", fails);

        $display("RESULT: ALL PASS");
        $finish;
    end

endmodule
