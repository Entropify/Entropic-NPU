`timescale 1ns/1ps

// =============================================================================
// tb_featmap_bram — ping-pong feature-map store
//
// What this bench is trying to break:
//   * a missing bank decode            -> bank 1 writes land in bank 0
//   * an address that drops a bit      -> words alias, map reads back shifted
//   * an unregistered (combinational) read -> latency check fails
//   * a read that sees the just-written word -> read-first check fails
//   * an off-by-one at a bank boundary -> word DEPTH-1 / word 0 collide
//   * a byte lane mixed up             -> section [6] checks every byte of a
//                                         full 48x48x8 map through the packed
//                                         (row, col, group) address scheme
//
// Sections
//   [1] bank 0: 5120 words written, all read back
//   [2] bank 1: 5120 words written, all read back; bank 0 re-read untouched
//   [3] read latency is exactly one clock
//   [4] read-first: same-cycle read of the written address returns OLD data
//   [5] boundaries: word 0 and word 5119 of both banks
//   [6] full conv1-shaped map (48x48, 2 groups = 4608 words) via packed address
// =============================================================================

module tb_featmap_bram;

    localparam int DEPTH = 5120;

    logic        clk    = 0;
    logic        w_en   = 0;
    logic [13:0] w_addr = 0;
    logic [31:0] w_data = 0;
    logic [13:0] raddr  = 0;
    logic [31:0] rdata;

    always #5 clk = ~clk;

    featmap_bram #(.DEPTH(DEPTH)) dut (
        .clk    (clk),
        .w_en   (w_en),
        .w_addr (w_addr),
        .w_data (w_data),
        .raddr  (raddr),
        .rdata  (rdata)
    );

    int checks = 0;
    int fails  = 0;

    task automatic chk(input string what, input logic [31:0] got, input logic [31:0] exp);
        checks++;
        if (got !== exp) begin
            fails++;
            if (fails <= 25)
                $display("  FAIL [%s] t=%0t got %08x want %08x", what, $time, got, exp);
        end
    endtask

    task automatic tick();
        @(posedge clk);
        #1;
    endtask

    task automatic wr(input logic bank, input int word, input logic [31:0] d);
        w_en   = 1'b1;
        w_addr = {bank, word[12:0]};
        w_data = d;
        tick();
        w_en   = 1'b0;
    endtask

    task automatic rd(input logic bank, input int word, output logic [31:0] d);
        raddr = {bank, word[12:0]};
        tick();
        d = rdata;
    endtask

    // distinct pattern per bank, so a bank mix-up is loud
    function automatic logic [31:0] pat(input logic bank, input int word);
        pat = (bank ? 32'hA5A5_0000 : 32'h5A5A_0000) | {18'b0, bank, word[12:0]};
    endfunction

    // ---- full-map addressing scheme under test ----------------------------
    localparam int MAPW = 48;          // conv1 output width
    localparam int GRPS = 2;           // 8 channels / 4 per word
    localparam int RSTR = MAPW * GRPS; // 96 words per row

    function automatic logic [7:0] aval(input int row, input int col, input int ch);
        aval = 8'((3*col + 17*row + 59*ch) & 255);
    endfunction

    function automatic int map_word(input int row, input int col, input int g);
        map_word = row*RSTR + col*GRPS + g;
    endfunction

    logic [31:0] got;
    logic [31:0] wd;
    logic [7:0]  gotb;

    initial begin
        $dumpfile("sim/tb_featmap_bram.vcd");
        $dumpvars(0, tb_featmap_bram);

        $display("=== tb_featmap_bram  (DEPTH=%0d words/bank) ===", DEPTH);

        // ------------------------------------------------------------------
        $display("[1] bank 0: write %0d words, read all back", DEPTH);
        for (int i = 0; i < DEPTH; i++)
            wr(1'b0, i, pat(1'b0, i));

        for (int i = 0; i < DEPTH; i++) begin
            rd(1'b0, i, got);
            chk("bank0 readback", got, pat(1'b0, i));
        end

        // ------------------------------------------------------------------
        $display("[2] bank 1: write %0d words, then re-read bank 0", DEPTH);
        for (int i = 0; i < DEPTH; i++)
            wr(1'b1, i, pat(1'b1, i));

        for (int i = 0; i < DEPTH; i++) begin
            rd(1'b1, i, got);
            chk("bank1 readback", got, pat(1'b1, i));
        end

        // bank 0 must be untouched by all of that
        for (int i = 0; i < DEPTH; i++) begin
            rd(1'b0, i, got);
            chk("bank0 survived bank1 writes", got, pat(1'b0, i));
        end

        // ------------------------------------------------------------------
        $display("[3] read latency: exactly one clock");
        rd(1'b0, 0, got);
        chk("latency: word 0 visible", got, pat(1'b0, 0));

        raddr = {1'b0, 13'd5};
        chk("latency: address change is NOT visible this clock", rdata, pat(1'b0, 0));
        tick();
        chk("latency: visible one clock later", rdata, pat(1'b0, 5));

        raddr = {1'b1, 13'd7};
        chk("latency: still holding word 5", rdata, pat(1'b0, 5));
        tick();
        chk("latency: bank 1 word 7 after one clock", rdata, pat(1'b1, 7));

        // ------------------------------------------------------------------
        $display("[4] read-first: same-cycle read of the written address is OLD");
        w_en   = 1'b1;
        w_addr = {1'b0, 13'd100};
        w_data = 32'hDEAD_BEEF;
        raddr  = {1'b0, 13'd100};
        tick();
        chk("read-first returns old contents", rdata, pat(1'b0, 100));

        w_en = 1'b0;
        tick();
        chk("write actually landed", rdata, 32'hDEAD_BEEF);

        // ------------------------------------------------------------------
        $display("[5] boundaries of both banks");
        rd(1'b0, 0, got);       chk("bank0 word 0",      got, pat(1'b0, 0));
        rd(1'b0, DEPTH-1, got); chk("bank0 word DEPTH-1", got, pat(1'b0, DEPTH-1));
        rd(1'b1, 0, got);       chk("bank1 word 0",      got, pat(1'b1, 0));
        rd(1'b1, DEPTH-1, got); chk("bank1 word DEPTH-1", got, pat(1'b1, DEPTH-1));

        // ------------------------------------------------------------------
        // conv1's output map: 48 x 48, 8 channels -> 2 groups -> 4608 words.
        // Written and read back through row*96 + col*2 + group, and every one
        // of the 4 bytes in every word is checked against the source formula.
        $display("[6] full map 48x48x8 through packed (row, col, group) addressing");
        for (int row = 0; row < MAPW; row++)
            for (int col = 0; col < MAPW; col++)
                for (int g = 0; g < GRPS; g++) begin
                    wd = {aval(row, col, 4*g+3), aval(row, col, 4*g+2),
                          aval(row, col, 4*g+1), aval(row, col, 4*g+0)};
                    wr(1'b1, map_word(row, col, g), wd);
                end

        chk("map fits in one bank", 32'(MAPW*RSTR), 32'd4608);

        for (int row = 0; row < MAPW; row++)
            for (int col = 0; col < MAPW; col++)
                for (int g = 0; g < GRPS; g++) begin
                    rd(1'b1, map_word(row, col, g), got);
                    for (int k = 0; k < 4; k++) begin
                        gotb = got[8*k +: 8];
                        checks++;
                        if (gotb !== aval(row, col, 4*g+k)) begin
                            fails++;
                            if (fails <= 25)
                                $display("  FAIL map r%0d c%0d ch%0d got %0d want %0d",
                                         row, col, 4*g+k, gotb, aval(row, col, 4*g+k));
                        end
                    end
                end

        // ------------------------------------------------------------------
        $display("");
        $display("checks: %0d   failures: %0d", checks, fails);

        if (checks < 33000) $fatal(1, "only %0d checks ran — a loop exited early", checks);
        if (fails != 0)     $fatal(1, "%0d failures", fails);

        $display("RESULT: ALL PASS");
        $finish;
    end

endmodule
