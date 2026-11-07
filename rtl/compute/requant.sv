`default_nettype none

`timescale 1ns/1ps




// basically requant needs to remap the huge number in the accumalator at the end of each lane in the addder tree into 8 bits for the pooling after each conv

// also conducts rectified linear unit

// accumalator range is max 16384 because (2^8 * 2^7) / 2 since signed

// needd to map to 255, so 16384 / 255 = 64, 64 is 2^6 so we right shift by 6


// 6 is just an example btw its dependent on the actual trained weights' magnitufdes for each conv layers


module requant(
    input logic clk,
    input logic rst,

    input logic valid_in,

    input logic signed [31:0] acc0,
    input logic signed [31:0] acc1,
    input logic signed [31:0] acc2,
    input logic signed [31:0] acc3,

    input logic signed [31:0] bias0,
    input logic signed [31:0] bias1,
    input logic signed [31:0] bias2,
    input logic signed [31:0] bias3,

    input logic [5:0] shift,

    output logic [7:0] q0,
    output logic [7:0] q1,
    output logic [7:0] q2,
    output logic [7:0] q3,

    output logic valid_out
);


function automatic logic [7:0] requant_one (
    logic signed [31:0] acc,
    logic signed [31:0] bias,
    logic [5:0] s //shift, but needs to be diff name than the module port ig??
);

logic signed [32:0] x;
logic signed [32:0] y;
logic signed [32:0] half;

x = acc + bias;


//divide

if (s == 6'b0) begin  //no shift needed type sht

    y = x;

end

else begin

    half = 33'sd1 << (s - 6'd1);
    y = (x + half) >>> s;

end

//clamp after

if (y < 0) requant_one = 8'b0;

else if (y > 33'sd255) requant_one = 8'd255;

else requant_one = y[7:0];


endfunction

always_ff @(posedge clk, posedge rst) begin

    if (rst) begin

        q0 <= 8'b0;
        q1 <= 8'b0;
        q2 <= 8'b0;
        q3 <= 8'b0;
        valid_out <= 1'b0;

    end

    else if (valid_in) begin

        q0 <= requant_one(
            .acc(acc0),
            .bias(bias0),
            .s(shift)
        );

         q1 <= requant_one(
            .acc(acc1),
            .bias(bias1),
            .s(shift)
        );

         q2 <= requant_one(
            .acc(acc2),
            .bias(bias2),
            .s(shift)
        );

         q3 <= requant_one(
            .acc(acc3),
            .bias(bias3),
            .s(shift)
        );

        valid_out <= 1'b1;


    end

    else begin

        valid_out <= 1'b0;

        //all qs reg hold current value (not inferred latch btw thats only in combination logic im lowk stupid)

    end



end




endmodule




`default_nettype wire
