`default_nettype none
`timescale 1ns/1ps


module uart_tx 
#(
    parameter int CLK_HZ = 100_000_000,
    parameter int BAUD = 115_200
)
(

    input wire logic clk,
    input wire logic rst,

    input wire logic send, //outside wants to send in data into tx
    input wire logic [7:0] data,

    output logic tx,
    output logic busy

);

localparam int CLK_PER_BIT = CLK_HZ / BAUD; //868 clk per bit

localparam int RELOAD = CLK_PER_BIT - 1; //waits 868 clk, decrements


logic [9:0] sr;
logic [3:0] bit_count; //track index
logic [9:0] div; //bit timer, counts down

logic tick;
assign tick = (div == 10'd0);

assign tx = busy ? sr[0] : 1'b1; // if busy then should be sending, otherwise idle high

always_ff @(posedge clk, posedge rst) begin

    if (rst) begin

        sr <= 10'b11_1111_1111;
        bit_count <= 4'd9;
        div <= 10'd0;
        busy <= 1'd0;

    end

    else begin

        if (div != 10'd0) div <= div - 10'd1;

        if (!busy) begin

            if (send) begin
                    sr <= {1'b1, data, 1'b0};   // stop | data | start
                    bit_count <= 4'd9;
                    div <= 10'(RELOAD);   // start bit lasts a full bit
                    busy <= 1'b1;
                end

            end 
            
        else if (tick) begin

                if (bit_count == 4'd0) begin
                    busy <= 1'b0;    // stop bit finished
                end 
                
                else begin
                    sr <= {1'b1, sr[9:1]};  // shift, push in idle high
                    bit_count <= bit_count - 4'd1;
                    div <= 10'(RELOAD);
                end

            end

    end
    
end



endmodule


`default_nettype wire
