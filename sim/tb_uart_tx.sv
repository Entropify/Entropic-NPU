`timescale 1ns/1ps

// =============================================================================
// tb_uart_tx — the bench plays the RECEIVER
//
// A monitor process watches the tx pin: it waits for the falling edge, samples
// 8 data bits at 1.5, 2.5 ... 8.5 bit times, then checks the stop bit at 9.5.
// Every decoded byte is pushed into a queue, so the test body can send first and
// check afterwards without racing a 1-clock event.
//
// What this bench is trying to break:
//   * MSB-first shifting          -> [2] 0x01 / 0x80 come out reversed
//   * a registered tx output      -> the start bit is a clock late; every byte
//                                    decodes shifted or not at all
//   * a short/late stop bit       -> stop_fail counter
//   * busy the wrong width        -> [3] busy must be high for 10 bit times
//   * a send accepted while busy  -> [4] the in-flight byte must stay intact
//   * no divider reload on send   -> [6] first byte after a long idle
//
// Sections
//   [1] idle state: tx high, busy low
//   [2] six killer bytes
//   [3] busy width == 10 bit times
//   [4] send while busy is ignored AND does not corrupt the frame
//   [5] back to back
//   [6] first byte after a long idle
// =============================================================================

module tb_uart_tx;

    localparam int CLK_HZ = 100_000_000;
    localparam int BAUD   = 115_200;
    localparam int CPB    = CLK_HZ / BAUD;      // 868

    logic       clk  = 0;
    logic       rst  = 1;
    logic       send = 0;
    logic [7:0] data = 0;
    logic       tx;
    logic       busy;

    always #5 clk = ~clk;

    uart_tx #(.CLK_HZ(CLK_HZ), .BAUD(BAUD)) dut (
        .clk  (clk),
        .rst  (rst),
        .send (send),
        .data (data),
        .tx   (tx),
        .busy (busy)
    );

    // ---- receiver monitor ------------------------------------------------
    logic [7:0] rxfifo [$];
    int         stop_fail = 0;
    int         n_frames  = 0;

    task automatic tick();
        @(posedge clk);
        #1;
    endtask

    task automatic wait_clk(input int n);
        repeat (n) tick();
    endtask

    task automatic receive_one();
        logic [7:0] b;
        while (tx !== 1'b0) tick();         // start bit edge
        wait_clk(CPB + CPB/2);              // move to the middle of bit 0
        for (int i = 0; i < 8; i++) begin
            b[i] = tx;
            wait_clk(CPB);
        end
        if (tx !== 1'b1) stop_fail++;       // now at 9.5 bits: stop must be high
        rxfifo.push_back(b);
        n_frames++;
    endtask

    initial begin
        forever receive_one();
    end

    // ---- driver ----------------------------------------------------------
    task automatic send_now(input logic [7:0] b);
        while (busy) tick();
        data = b;
        send = 1'b1;
        tick();                             // one-clock send pulse
        send = 1'b0;
    endtask

    int checks = 0;
    int fails  = 0;

    task automatic expect_byte(input logic [7:0] e, input string what);
        int t = 0;
        while (rxfifo.size() == 0 && t < 14*CPB) begin
            tick();
            t++;
        end
        checks++;
        if (rxfifo.size() == 0) begin
            fails++;
            $display("  FAIL [%s] no byte on the wire (wanted %02x)", what, e);
        end else begin
            automatic logic [7:0] g = rxfifo.pop_front();
            if (g !== e) begin
                fails++;
                $display("  FAIL [%s] decoded %02x wanted %02x", what, g, e);
            end
        end
    endtask

    initial begin
        $dumpfile("sim/tb_uart_tx.vcd");
        $dumpvars(0, tb_uart_tx);

        $display("=== tb_uart_tx  (%0d clocks per bit) ===", CPB);

        // ------------------------------------------------------------------
        $display("[1] idle state");
        wait_clk(5);
        checks++;
        if (busy !== 1'b0) begin fails++; $display("  FAIL busy high after reset"); end
        rst = 0;
        wait_clk(10);

        checks++;
        for (int i = 0; i < 2000; i++) begin
            tick();
            if (tx !== 1'b1) begin
                fails++;
                $display("  FAIL tx not high while idle at t=%0t", $time);
                break;
            end
        end

        // ------------------------------------------------------------------
        $display("[2] six killer bytes");
        send_now(8'h00); expect_byte(8'h00, "0x00");
        send_now(8'hFF); expect_byte(8'hFF, "0xFF");
        send_now(8'h55); expect_byte(8'h55, "0x55");
        send_now(8'hAA); expect_byte(8'hAA, "0xAA");
        send_now(8'h01); expect_byte(8'h01, "0x01 lsb-order");
        send_now(8'h80); expect_byte(8'h80, "0x80 msb-order");

        // ------------------------------------------------------------------
        $display("[3] busy width is 10 bit times");
        send_now(8'h81);
        begin
            int n = 0;
            while (busy) begin
                tick();
                n++;
            end
            checks++;
            if (n < 10*CPB - 2 || n > 10*CPB + 2) begin
                fails++;
                $display("  FAIL busy lasted %0d clocks, wanted %0d", n, 10*CPB);
            end
        end
        expect_byte(8'h81, "busy width byte");

        // ------------------------------------------------------------------
        $display("[4] send while busy is ignored and does not corrupt the frame");
        send_now(8'hA5);
        wait_clk(3*CPB);                    // mid-frame
        checks++;
        if (busy !== 1'b1) begin fails++; $display("  FAIL busy low mid-frame"); end
        data = 8'h11;                       // a byte that must NOT appear
        send = 1'b1;
        tick();
        send = 1'b0;
        expect_byte(8'hA5, "in-flight byte survived");
        wait_clk(2*CPB);
        checks++;
        if (rxfifo.size() != 0) begin
            fails++;
            $display("  FAIL spurious byte %02x appeared", rxfifo.pop_front());
        end

        // ------------------------------------------------------------------
        $display("[5] back to back");
        send_now(8'hC3);
        send_now(8'h3C);                    // send_now waits for !busy first
        expect_byte(8'hC3, "b2b 1");
        expect_byte(8'h3C, "b2b 2");

        // ------------------------------------------------------------------
        $display("[6] first byte after a long idle");
        wait_clk(5000);
        send_now(8'h5A);
        expect_byte(8'h5A, "after idle");

        // ------------------------------------------------------------------
        $display("[7] every frame had a high stop bit");
        checks++;
        if (stop_fail != 0) begin
            fails++;
            $display("  FAIL %0d frame(s) with a low stop bit", stop_fail);
        end

        // ------------------------------------------------------------------
        $display("");
        $display("frames: %0d   checks: %0d   failures: %0d", n_frames, checks, fails);

        if (checks < 12) $fatal(1, "only %0d checks ran", checks);
        if (fails != 0)  $fatal(1, "%0d failures", fails);

        $display("RESULT: ALL PASS");
        $finish;
    end

endmodule
