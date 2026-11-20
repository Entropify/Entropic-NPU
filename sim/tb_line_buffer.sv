
// tb_line_buffer.sv -- 3x3 sliding-window generator
//
// What it is trying to break:
//   * wrong tap order (ky*3+kx) -- a transposed window still "works"
//   * row rotation off by one   -- rows 1-2 fine, row 3 onward garbage
//   * chain depth 1 instead of 2 -- window 2 wide, corners right, diagonals off
//   * chain over-shifting          -- window slides more than one column per step
//   * stale warm-up rows leaking   -- first two rows of a map built from the
//                                     previous map's pixels
//   * W_run ignored                 -- runtime width is data, not a parameter
//   * ch_out misaligned             -- weights applied to the wrong channel
//   * valid_out advertising a window while the column is still being fed
//
// The map is synthetic: val(x,y,ch) = (3x + 17y + 59ch) mod 256, which is
// distinct in x, y and ch -- so a window shifted by one column, one row, or
// one channel can never accidentally match.
//
// Run from the project root:
//   $ verilator --binary --timing --trace -Wno-fatal --top-module tb_line_buffer \
//         --Mdir sim/build/vlb sim/tb_line_buffer.sv rtl/memory/line_buffer.sv
//   $ ./sim/build/vlb/Vtb_line_buffer     (writes sim/tb_line_buffer.vcd)
//   $ gtkwave -a sim/tb_line_buffer.gtkw sim/tb_line_buffer.vcd

`timescale 1ns/1ps
`default_nettype none

module tb_line_buffer;

    localparam int WM   = 24;    // instance WMAX
    localparam int CH   = 8;     // channels in the test map (2 groups)
    localparam int ROWS = 24;    // map height fed

    logic clk = 0, rst = 1;
    logic map_start = 0, valid_in = 0, advance = 0, sweep = 0;
    logic [5:0] W_run;
    logic [1:0] g;
    logic [7:0] din0, din1, din2, din3;
    logic [3:0] ch_sel;

    logic       valid_out;
    logic [3:0] ch_out;
    logic [71:0] tap;

    int checks = 0, fails = 0;          // window / label / validity checks
    int feed_checks = 0, feed_fails = 0; // the feed-clock contract, counted apart
    int win_count  = 0;
    int first_x = -1, first_y = -1;

    line_buffer #(.WMAX(WM)) dut (
        .clk(clk), .rst(rst),
        .W_run(W_run), .map_start(map_start),
        .valid_in(valid_in), .g(g),
        .din0(din0), .din1(din1), .din2(din2), .din3(din3),
        .advance(advance), .sweep(sweep), .ch_sel(ch_sel),
        .valid_out(valid_out), .ch_out(ch_out), .tap(tap)
    );

    always #5 clk = ~clk;

    task tick(); begin @(posedge clk); #1; end endtask

    // synthetic map: distinct in x, y and channel
    function automatic logic [7:0] val(input int x, input int y, input int c);
        val = 8'((3*x + 17*y + 59*c) % 256);
    endfunction

    // expected byte of tap t for the window of output (x-1, y-1), channel c
    function automatic logic [7:0] exp_tap(input int x, input int y,
                                           input int c, input int t);
        exp_tap = val(x - 2 + (t % 3), y - 2 + (t / 3), c);
    endfunction

    // check one complete window (called only where a window must exist)
    task chk_win(input int x, input int y, input int c);
        begin
            for (int t = 0; t < 9; t++) begin
                checks = checks + 1;
                if (tap[8*t +: 8] !== exp_tap(x, y, c, t)) begin
                    fails = fails + 1;
                    if (fails <= 20 || (fails % 2000 == 0))
                        $display("      FAIL  win(x=%0d,y=%0d,ch=%0d) tap%0d got %0d want %0d",
                                 x, y, c, t, tap[8*t +: 8], exp_tap(x, y, c, t));
                end
            end
            checks = checks + 1;
            if (ch_out !== 4'(c)) begin
                fails = fails + 1;
                if (fails <= 20)
                    $display("      FAIL  ch_out got %0d want %0d", ch_out, c);
            end
            checks = checks + 1;
            if (valid_out !== 1'b1) begin
                fails = fails + 1;
                if (fails <= 20)
                    $display("      FAIL  valid_out low at a real window (x=%0d,y=%0d)", x, y);
            end
        end
    endtask

    // a pass where no window may exist (warm-up columns/rows)
    task chk_no_win();
        begin
            checks = checks + 1;
            if (valid_out !== 1'b0) begin
                fails = fails + 1;
                if (fails <= 20)
                    $display("      FAIL  valid_out high during warm-up");
            end
        end
    endtask

    // feed + sweep one complete W-wide, ROWS-tall map and check every window
    task run_map(input int W);
        begin
            W_run = 6'(W);
            map_start = 1; tick(); map_start = 0;
            for (int y = 0; y < ROWS; y++) begin
                for (int x = 0; x < W; x++) begin

                    // ---- FEED: two beats, groups 0 and 1 ----
                    for (int gi = 0; gi < 2; gi++) begin
                        g    = 2'(gi);
                        din0 = val(x, y, 4*gi + 0);
                        din1 = val(x, y, 4*gi + 1);
                        din2 = val(x, y, 4*gi + 2);
                        din3 = val(x, y, 4*gi + 3);
                        valid_in = 1;
                        #1;
                        // contract: a window may not be advertised while its
                        // newest column is still being written
                        feed_checks = feed_checks + 1;
                        if (valid_out !== 1'b0) begin
                            feed_fails = feed_fails + 1;
                            if (feed_fails <= 3)
                                $display("      FAIL  valid_out high during feed (x=%0d,y=%0d,g=%0d)",
                                         x, y, gi);
                        end
                        tick();
                        valid_in = 0;
                    end

                    // ---- SWEEP: one pass per channel ----
                    sweep = 1;
                    for (int c = 0; c < CH; c++) begin
                        ch_sel = 4'(c);
                        if (c == CH - 1) advance = 1;
                        #1;
                        if (y >= 2 && x >= 2) begin
                            if (first_x < 0) begin
                                first_x = x; first_y = y;
                            end
                            win_count = win_count + 1;
                            chk_win(x, y, c);
                        end else begin
                            chk_no_win();
                        end
                        tick();
                        advance = 0;
                    end
                    sweep = 0;
                end
            end
        end
    endtask

    
    initial begin

        $dumpfile("sim/tb_line_buffer.vcd");
        $dumpvars(0, tb_line_buffer);

        repeat (3) tick();
        rst = 0;
        tick();

        //  [1] reset 
        $display("\n[1] reset");
        checks = checks + 1;
        if (valid_out !== 1'b0) begin fails = fails + 1; $display("      FAIL  valid_out not low"); end
        else $display("      pass  valid_out low");
        checks = checks + 1;
        if (ch_out !== 4'd0) begin fails = fails + 1; $display("      FAIL  ch_out not low"); end
        else $display("      pass  ch_out low");

        //  [2] full 24-wide map, every channel 
        $display("\n[2] full map, W_run = 24: every window of every channel");
        run_map(24);
        $display("      windows checked: %0d (expected %0d)", win_count, 22*22*CH);
        checks = checks + 1;
        if (win_count !== 22*22*CH) begin
            fails = fails + 1;
            $display("      FAIL  window count %0d, wanted %0d", win_count, 22*22*CH);
        end else $display("      pass  window count exact");

        checks = checks + 1;
        if (first_x !== 2 || first_y !== 2) begin
            fails = fails + 1;
            $display("      FAIL  first window at (x=%0d,y=%0d), wanted (2,2)", first_x, first_y);
        end else $display("      pass  first window at column 2, row 2 (warm-up = 2W+2)");

        //  [3] the feed-clock contract 
        $display("\n[3] valid_out must stay low while a column is being fed");
        if (feed_fails == 0)
            $display("      pass  %0d feed clocks, none advertised a window", feed_checks);
        else
            $display("      FAIL  %0d of %0d feed clocks advertised a window",
                     feed_fails, feed_checks);

        //  [4] runtime width: the same module, W_run = 16 
        $display("\n[4] same instance, W_run = 16 (width is data, not a parameter)");
        win_count = 0; first_x = -1; first_y = -1;
        run_map(16);
        $display("      windows checked: %0d (expected %0d)", win_count, 14*22*CH);
        checks = checks + 1;
        if (win_count !== 14*22*CH) begin
            fails = fails + 1;
            $display("      FAIL  window count %0d, wanted %0d", win_count, 14*22*CH);
        end else $display("      pass  window count exact at the new width");

        checks = checks + 1;
        if (first_x !== 2 || first_y !== 2) begin
            fails = fails + 1;
            $display("      FAIL  first window moved (x=%0d,y=%0d)", first_x, first_y);
        end else $display("      pass  warm-up unchanged");

        //  summary 
        $display("\n==================================================");
        $display("  window/label checks : %0d    failures: %0d", checks, fails);
        $display("  feed-clock contract : %0d    failures: %0d", feed_checks, feed_fails);
        if (fails == 0 && feed_fails == 0) $display("  RESULT: ALL PASS");
        else                    $display("  RESULT: *** %0d + %0d FAILURES ***", fails, feed_fails);
        $display("==================================================\n");

        if (checks < 70000) $fatal(1, "only %0d checks ran", checks);
        if (fails != 0 || feed_fails != 0) $fatal(1, "verification failed");
        $finish;

    end

endmodule

`default_nettype wire
