`default_nettype none

`timescale 1ps/1ps


module argmax

#(parameter int max_classes = 32)

(
    input wire logic clk,
    input wire logic rst,

    input wire logic valid_in,
    input wire logic [1:0] g,
    input wire logic last_in,
    input wire logic [5:0] n_classes,

    input wire logic signed [31:0] logit0,
    input wire logic signed [31:0] logit1,
    input wire logic signed [31:0] logit2,    //input neuron final values,  4 neurons / clk (g counter)
    input wire logic signed [31:0] logit3,

    input wire logic signed [31:0] bias0,
    input wire logic signed [31:0] bias1, //other biases are added in the requant process for 
    input wire logic signed [31:0] bias2, //each module but here for FC it doesn't run through
    input wire logic signed [31:0] bias3, //requant so biases must be added here in argmax :)

    output logic valid_out,
    output logic [4:0] class_index,
    output logic signed [31:0] max_val,
    output logic err

);


typedef enum logic [1:0] {

    COLLECT = 2'd0,
    COMPARE = 2'd1,
    EMIT = 2'd2

} state_t;

state_t state;

logic signed [31:0] regs [0:max_classes-1];

logic signed [31:0] logit [0:3];
assign logit[0] = logit0;
assign logit[1] = logit1;
assign logit[2] = logit2;
assign logit[3] = logit3;

logic signed [31:0] bias [0:3];
assign bias[0] = bias0;
assign bias[1] = bias1;
assign bias[2] = bias2;
assign bias[3] = bias3;


logic signed [31:0] best; // running maximum
logic [4:0] best_idx; // where the highest output neuron value came from
logic [4:0] i;
logic [4:0] n_c;  //copy of n_classes

always_ff (posedge clk, posedge rst) begin


    if (rst) begin

        state <= COLLECT;

        valid_out <= 1'b0;
        class_index <= 5'b0;
        max_val <= 32'sb0;
        err <= 1'b0;

        best <= 32'sb0;
        best_idx <= 5'd0;
        i <= 5'd0;
        n_c <= 5'd0;

    end



end

endmodule




`default_nettype wire
