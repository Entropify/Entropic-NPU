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

localparam logic [5:0] max_c = max_classes[5:0];


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

always_ff @(posedge clk, posedge rst) begin


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

    else begin

        valid_out <= 1'b0;

        case(state)


            COLLECT: begin

                if (valid_in) begin

                    integer l;

                    for (l = 0; l < 4; l++) begin

                        if ({g, 2'b00} + 5'(l) < 5'(n_classes)) begin       //ensures only write into reg array when appropriate g and lane are called (any g*4 + l reater than total ouput types is invalid)

                            regs[{g, 2'b00} + 5'(l)] <= logit[l] + bias[l];     

                        end

                    end

                        if (last_in) begin
                                
                            if (n_classes == 6'd0 || n_classes > max_c || (5'(g) != ((n_classes[4:0] - 5'd1) >> 2))) begin //checks number of number of groups ent over by control is actually equivalent to number of classes

                                err <= 1'b1;              //effectively a latched reg until the next time rst is raised high
                                state <= COLLECT;

                            end

                            else begin

                                n_c <= n_classes[4:0];
                                i <= 5'd0;
                                best <= 32'sh8000_0000; //most negative number, default (so any number is greater than it and will be considered a new best)
                                best_idx <= 5'd0;
                                state <= COMPARE;

                            end

                        end


                    end

                end
                


            


            COMPARE: begin

                if (regs[i] > best) begin

                    best <= regs[i];
                    best_idx <= i;

                end

                if (i == n_c - 5'b1) begin

                    state <= EMIT;

                end


                else begin

                    i <= i + 5'b1;

                end

            end

            EMIT: begin

                valid_out <= 1'b1;

                class_index <= best_idx;
                max_val <= best;
                state <= COLLECT;


            end

            default: state <= COLLECT;


        endcase



    end



end

endmodule




`default_nettype wire
