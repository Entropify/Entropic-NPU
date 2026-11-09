`default_nettype none

`timescale 1ns/1ps

// ts module sums the 9 tap accumulators of ONE lane into one dot product type sht

//

// capture: the 9 inputs are final right now, add them and remember it. driven by the MACs' done output
//latency: capture in cycle T, sum valid in cycle T+1

//freeze: holds sum

module adder_tree(

    input wire logic clk,
    input wire logic rst,
    input wire logic freeze,
    input wire logic capture,

    input wire logic signed [31:0] d0,
    input wire logic signed [31:0] d1,
    input wire logic signed [31:0] d2,
    input wire logic signed [31:0] d3,
    input wire logic signed [31:0] d4,
    input wire logic signed [31:0] d5,
    input wire logic signed [31:0] d6,
    input wire logic signed [31:0] d7,
    input wire logic signed [31:0] d8,

    output logic signed [31:0] sum
    
);

logic signed [31:0] sum_comb;

assign sum_comb = d0 + d1 + d2 + d3 + d4 + d5 + d6 + d7 + d8;

always_ff @(posedge clk, posedge rst) begin

    if (rst) begin

        sum <= 32'h0;

    end

    else if (freeze) begin

        sum <= sum;

    end

    else if (capture) begin

        sum <= sum_comb;

    end


end


endmodule


`default_nettype wire 
