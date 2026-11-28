`default_nettype none

`timescale 1ns/1ps



module weight_bram
#(parameter int BEATBITS = 7)
(

    input wire logic clk,

    //w

    input wire logic w_en,
    input wire logic [BEATBITS : 0] w_addr, //would be BEATBITS - 1 : 0 but its not extra one bit to choose bank

    //bank bit 0 is bank a write, bank bit 1 is bank b write
    input wire logic [287:0] w_data, //ts is like 4 * 9 * 8 = 288


    //r
    input wire logic [BEATBITS : 0] r_addr, //same

    //bank bit 0 is bank a read, bank bit 1 is bank b read
    output logic [287:0] r_data

);


localparam int DEPTH = 1 << BEATBITS; //128 max beats, 128 max depth per bank type shtttt

(* ram_style = "block" *)
logic [287:0] bank_a [0:DEPTH-1];

(* ram_style = "block" *)
logic [287:0] bank_b [0:DEPTH-1];

wire [BEATBITS-1:0] wbeat = w_addr[BEATBITS-1:0];
wire [BEATBITS-1:0] rbeat = r_addr[BEATBITS-1:0];

always_ff @(posedge clk) begin

    if (w_en && !w_addr[BEATBITS]) begin

        bank_a[wbeat] <= w_data;

    end

    if (w_en && w_addr[BEATBITS]) begin

        bank_b[wbeat] <= w_data;

    end

    r_data <= (r_addr[BEATBITS]) ? bank_b[rbeat]

                                : bank_a[rbeat];


end





endmodule

`default_nettype wire
