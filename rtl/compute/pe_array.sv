`default_nettype none

`timescale 1ns/1ps

// pe_array: taps x lanes array of MACs (9x 4 = 36)


//latency: 4 clocks from last beat to dot (3 MAC + 1 tree)
//done: 1 clock, 3 clocks after last beat also the tree's capture

//freeze: send immediatement into every MAC and every tree

module pe_array #(parameter taps = 9, parameter lanes = 4)

(
    input wire logic clk,
    input wire logic rst,

    input wire logic valid,
    input wire logic first,
    input wire logic last,
    input wire logic freeze,

    input wire logic [8*taps-1:0] act,
    input wire logic [8*taps*lanes-1:0] weight,

    output logic [32*lanes-1:0] dot,
    output logic done,
    output logic [32*taps*lanes-1:0] acc_debug

);

logic signed [31:0] acc_q [0:taps-1] [0:lanes-1]; //2d array of each of the mac's accumalator output thingmagigy, each is 32 bits x 9 x 4

logic mac_done [0:taps-1] [0:lanes-1];

logic signed [32 * lanes - 1 : 0] dot_q; // dot product of each filter (output of each tree), 4 lanes 32 bits each (ali naqvi is hot btw hope he doesn't see this)

genvar t;
genvar l;

/* 
mac test (

    .clk(clk),
    .rst(rst),
    .valid(valid),
    .first(first),
    .last(last),
    .freeze(freeze),
    .weight($signed(weight[7:0])),
    .activation(act[7:0]),
    .acc(acc_q[0][0]),
    .valid_out(),
    .done(mac_done[0][0])
);
*/

generate
    
    for (t = 0; t < taps; ++t) begin : generate_taps_9
        

        for (l = 0; l < lanes; ++l) begin : generate_lanes_4
        

            mac mac_unit (
                        .clk(clk),
                        .rst(rst),
                        .valid(valid),
                        .first(first),
                        .last(last),
                        .freeze(freeze),
                        .weight($signed(weight[8 * (l + lanes * t) +: 8])),
                        .activation(act[8 * t +: 8]),
                        .acc(acc_q[t][l]),
                        .valid_out(),
                        .done(mac_done[t][l])
            );


            assign acc_debug[32 * (lanes * t + l) +: 32] = acc_q[t][l];

        end

    end

endgenerate

/*

adder_tree u_tree_probe (
    .clk(clk),
    .rst(rst),
    .freeze(freeze),        
    .capture(mac_done[0][0]),
    .d0(acc_q[0][0]), 
    .d1(acc_q[1][0]), 
    .d2(acc_q[2][0]),
    .d3(acc_q[3][0]), 
    .d4(acc_q[4][0]),
    .d5(acc_q[5][0]),
    .d6(acc_q[6][0]),
    .d7(acc_q[7][0]),
    .d8(acc_q[8][0]),
    .sum(dot_q[31:0])
);

*/

genvar i;

generate 

    for (i = 0; i < lanes; ++i) begin : generate_lane_adder_trees

        adder_tree u_tree_probe (
            .clk(clk),
            .rst(rst),
            .freeze(freeze),        
            .capture(mac_done[0][i]),
            .d0(acc_q[0][i]), 
            .d1(acc_q[1][i]), 
            .d2(acc_q[2][i]),
            .d3(acc_q[3][i]), 
            .d4(acc_q[4][i]),
            .d5(acc_q[5][i]),
            .d6(acc_q[6][i]),
            .d7(acc_q[7][i]),
            .d8(acc_q[8][i]),
            .sum(dot_q[32 * i +: 32])
        );

    end


endgenerate


assign dot = dot_q;
assign done = mac_done[0][0];

endmodule


`default_nettype wire
