`default_nettype none

`timescale 1ns/1ps


module gap(

    input wire logic clk,
    input wire logic rst,

    input wire logic valid_in,
    input wire logic [1:0] g,         //clk identifier
    input wire logic first,
    input wire logic last,

    input wire logic [7:0] in0,
    input wire logic [7:0] in1,
    input wire logic [7:0] in2,
    input wire logic [7:0] in3,        //chanels

    output logic valid_out,
    output logic [1:0] g_out,

    output logic [7:0] out0,
    output logic [7:0] out1,
    output logic [7:0] out2,
    output logic [7:0] out3
);


typedef enum logic {
    ACCUM = 1'b0,
    EMIT = 1'b1
} state_t;

state_t state;


//din array
    
logic [7:0] din [0:3];
assign din[0] = in0;
assign din[1] = in1;
assign din[2] = in2;
assign din[3] = in3;

logic [15:0] acc [0:15];

logic [1:0] gc;

function automatic logic [7:0] sat(input logic [15:0] v);       //division function

    logic [8:0] t;
    t = v[15:7];
    sat = (t > 9'd255) ? 8'd255 : t[7:0];

endfunction


always_ff @(posedge clk) begin

    if (valid_in) begin

        integer l;

        if (first) begin

            for (int c = 0; c < 16; c++) begin
                
                acc[c] <= 16'd0;    // wipe all 16

            end

        end

        for (l= 0; l < 4; l++) begin

            if (first) begin

                acc[{g, 2'(l)}] <= 16'(din[l]);

            end

            else begin

                acc[{g, 2'(l)}] <= acc[{g, 2'(l)}] + 16'(din[l]);

            end

        end

    end

end


always_ff @(posedge clk, posedge rst) begin


    if (rst) begin

        out0 <= 8'b0;
        out1 <= 8'b0;
        out2 <= 8'b0;
        out3 <= 8'b0;

        valid_out <= 1'b0;
        g_out <= 2'b0;

        state <= ACCUM;
        gc <= 2'b0;

    end



    else begin

        valid_out <= 1'b0;

        case (state)

        ACCUM: begin

            if (valid_in && last) begin
                gc <= 2'd0;          // reseting
                state <= EMIT;
            end

        end

        EMIT: begin

            out0 <= sat(acc[{gc, 2'd0}]);
            out1 <= sat(acc[{gc, 2'd1}]);
            out2 <= sat(acc[{gc, 2'd2}]);
            out3 <= sat(acc[{gc, 2'd3}]);

            g_out <= gc;
            valid_out <= 1'b1;


            if (gc == 2'd3) begin

                state <= ACCUM;
                gc <= 2'b0;

            end

            else begin

                gc <= gc + 2'b1;

            end



        end

        default: state <= ACCUM;


        endcase

    end



end


endmodule


`default_nettype wire
