`default_nettype none

`timescale 1ns/1ps


module pool #(parameter int W = 48)

(
    input wire logic clk,
    input wire logic rst,

    input wire logic valid_in,
    input wire logic [1:0] g,
    input wire logic [5:0] x,
    input wire logic [5:0] y,

    input wire logic [7:0] in0,
    input wire logic [7:0] in1,
    input wire logic [7:0] in2,
    input wire logic [7:0] in3,

    output logic valid_out,
    output logic [1:0] g_out, //this shows which group current output data belogns to

    output logic [7:0] out0,
    output logic [7:0] out1,
    output logic [7:0] out2,
    output logic [7:0] out3
);

function automatic logic [7:0] max8 (
    input logic [7:0] a,
    input logic [7:0] b
);


    max8 = (a > b) ? a : b;

endfunction


logic [7:0] prev [0:3] [0:3];
logic [7:0] rowbuff [0:3] [0:3] [0:(W/2) - 1];
logic [7:0] out_q [0:3];


logic [7:0] din [0:3];

assign din[0] = in0;
assign din[1] = in1;
assign din[2] = in2;
assign din[3] = in3;

assign out0 = out_q[0];
assign out1 = out_q[1];
assign out2 = out_q[2];    
assign out3 = out_q[3];


always_ff @(posedge clk) begin

    if (valid_in) begin

        int l;
        for (l = 0; l < 4; l++) begin //l is which lane (which layer being processed in current clk g)

            if (!x[0]) begin //even index (odd element, its pair hasnt arrived yet), so store current into prev (x=0 (1st element))
                prev[g][l] <= din[l];

            end

            else if (!y[0]) begin

                rowbuff[g][l][x[5:1]] <= max8(prev[g][l], din[l]);

                //x index divided by 2 since pooling halves row length

            end


        end


    end

end

always_ff @(posedge clk, posedge rst) begin

    if (rst) begin

        out_q[0] <= 8'd0;
        out_q[1] <= 8'd0;
        out_q[2] <= 8'd0;
        out_q[3] <= 8'd0;
        valid_out<= 1'b0;
        g_out <= 2'd0;

    end

    else begin

        valid_out <= valid_in & x[0] & y[0]; //if x and y indices are odd (eventh elements)
        g_out <= g;

        if (valid_in && x[0] && y[0]) begin

            int l;
            for (l = 0; l < 4; l++) begin

                out_q[l] <= max8(rowbuff[g][l][x[5:1]], max8(prev[g][l], din[l]));

            end

        end


    end


end




endmodule


`default_nettype wire
