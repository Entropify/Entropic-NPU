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
    parameter int WMAX = 50;
)
(

    input wire logic clk,
    input wire logic rst,

    input wire logic [5:0] W_run,  //map width this layer from descriptor
    input wire logic map_start,

    input wire logic valid_in,
    input wire logic [1:0] g, // which group of 4 channels this beat holds
    input wire logic [7:0] din0,
    input wire logic [7:0] din1,
    input wire logic [7:0] din2,
    input wire logic [7:0] din3,

    input wire logic advance,   // move one column
    input wire logic [3:0] ch_sel,  // which input channel to expose

    output logic valid_out,  // the 9 taps are meaningful
    output logic [3:0] ch_out, // ch_sel, delayed with the data
    output logic [71:0] tap


);

localparam int CW = $clog2(WMAX); //ceiling log to figure out how many bits to store the address of each column
localparam int WORDS = 4 * WMAX; //4 groups (g) * number of columns ina row
localparam int AW = CW + 2; // ts full ram adress = row address width + 2 (since 4 groups takes up 2 bits)



logic [CW-1:0] col;
logic [1:0] rows_seen; // saturates at 2, basiucally has it seen 2 rows yet?

logic [1:0] wr_slot; //current R
logic [1:0] mid_slot; // R - 1
logic [1:0] top_slot; // R -2

wire row_done = advance && (col == CW'(W_run -1)); // high when last column of this row
wire warm = (rows_seen == 2'd2);  // rows R-2 and R-1 exist

logic [31:0] ram0 [0:WORDS-1];
logic [31:0] ram1 [0:WORDS-1];
logic [31:0] ram2 [0:WORDS-1];


always_ff @(posedge clk, posedge rst) begin

        if (rst || map_start) begin

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


// write
wire [AW-1:0] addr_w = {col, g};  // column + which group arrived
wire [31:0] wdata = {din3, din2, din1, din0};   // byte0 = channel 4g+0

wire we0 = valid_in && (wr_slot == 2'd0);
wire we1 = valid_in && (wr_slot == 2'd1); //write enables for each cghannel
wire we2 = valid_in && (wr_slot == 2'd2);

//read 

wire [AW-1:0] addr_r = {col, ch_sel[3:2]};  //column + which group to look at

logic [31:0] q0, q1, q2;


always_ff @(posedge clk) begin
        
    if (we0) ram0[addr_w] <= wdata;

end
    
assign q0 = ram0[addr_r];

always_ff @(posedge clk) begin

        if (we1) ram1[addr_w] <= wdata;

    
end

assign q1 = ram1[addr_r];


always_ff @(posedge clk) begin

    if (we2) ram2[addr_w] <= wdata;

end
    
assign q2 = ram2[addr_r];


// which ram is which row

wire [31:0] q_live = (wr_slot  == 2'd0) ? q0 : (wr_slot  == 2'd1) ? q1 : q2;

wire [31:0] q_mid = (mid_slot == 2'd0) ? q0 : (mid_slot == 2'd1) ? q1 : q2;

wire [31:0] q_top = (top_slot == 2'd0) ? q0 : (top_slot == 2'd1) ? q1 : q2;





endmodule


`default_nettype wire
