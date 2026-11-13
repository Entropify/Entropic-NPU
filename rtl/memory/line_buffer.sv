`default_nettype none

`timescale 1ns/1ps


module line_buffer #(
    parameter int w = 24,
    parameter int ch = 8
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





endmodule


`default_nettype wire
