`default_nettype none

`timescale 1ns/1ps


/*

memory structure cus im dumb

                 col 0   col 1   col 2   ...   col 23
group 0 (ch 0-3)   1 word  1 word  1 word      1 word     <- 24 words
group 1 (ch 4-7)   1 word  1 word  1 word      1 word     <- 24 words
group 2 (ch 8-11)  1 word  1 word  1 word      1 word     <- 24 words
group 3 (ch12-15)  1 word  1 word  1 word      1 word     <- 24 words
                   └───── 4 words per column ─────┘
                                × 24 columns
                                 = 96 words


*/


module line_buffer #(
    parameter int W = 24,
    parameter int CH = 8
)
(

    input wire logic clk,
    input wire logic rst,

    input wire logic valid_in,
    input wire logic [1:0] g,    // which group of 4 channels this beat holds
    input wire logic [7:0] din0,
    input wire logic [7:0] din1,
    input wire logic [7:0] din2,
    input wire logic [7:0] din3,

    input wire logic advance,    // move one column
    input wire logic [3:0] ch_sel,  // which input channel to expose

    output logic valid_out,  // the 9 taps are meaningful
    output logic [3:0] ch_out, // ch_sel, delayed with the data
    output logic [71:0] tap


);

localparam int CW = $clog2(W); //ceiling log to figure out how many bits to store the address of each column
localparam int WORDS = 4 * W; //4 groups (g) * number of columns ina row
localparam int AW = CW + 2; // ts full ram adress = row address width + 2 (since 4 groups takes up 2 bits)



logic [CW-1:0] col;
logic [1:0] rows_seen; // saturates at 2, basiucally has it seen 2 rows yet?

logic [1:0] wr_slot; //current R
logic [1:0] mid_slot; // R - 1
logic [1:0] top_slot; // R -2

wire row_done = advance && (col == CW'(W-1)); // high when last column of this row
wire warm = (rows_seen == 2'd2);  // rows R-2 and R-1 exist


always_ff @(posedge clk, posedge rst) begin

        if (rst) begin

            col <= '0;
            rows_seen <= 2'd0;
            wr_slot <= 2'd0;
            mid_slot <= 2'd2;
            top_slot <= 2'd1;

        end

        else if (advance) begin

            if (row_done) begin

                col <= {CW{1'b0}};

                if (rows_seen != 2'd2) begin
                    rows_seen <= rows_seen + 2'd1;
                end
                
                wr_slot <= top_slot;
                mid_slot <= wr_slot;
                top_slot <= mid_slot;

            end

            else begin

                col <= col + CW'(1);

            end

        end

end



endmodule


`default_nettype wire
