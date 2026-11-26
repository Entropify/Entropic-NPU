`default_nettype none
`timescale 1ns/1ps


//idle high uart

module uart_rx 
#(
    parameter int CLK_HZ = 100_000_000,
    parameter int BAUD = 115_200
)
(
    input wire logic clk,
    input wire logic rst, //async

    input wire logic rx,

    output logic [7:0] data,
    output logic valid
);


localparam int CLK_PER_BIT = CLK_HZ / BAUD; //868 clk per bit

localparam int HALF = CLK_PER_BIT / 2;   // 434

localparam int RELOAD = CLK_PER_BIT  - 1; //waits 868 clk, decrements

localparam int MIDBIT = HALF - 1; //waits 434

logic rx_unstable;
logic rx_stable;
logic rx_prev;


//2ff sync

always_ff @(posedge rst, posedge clk) begin


    if (rst == 1'b1) begin

        rx_unstable <= 1'b1;
        rx_stable <= 1'b1;
        rx_prev <= 1'b1;

    end

    else begin

        rx_unstable <= rx;
        rx_stable <= rx_unstable;
        rx_prev <= rx_stable;

    end


end

//edging detection

wire start;

assign start = rx_prev && !rx_stable;


// fsm

typedef enum logic [1:0]{
    IDLE,
    START,
    DATA,
    STOP
} state_t;

state_t state;


logic [9:0] count; // 10 bits because 868 fits in 2^10, decrementing counter
logic [2:0] bit_index;
logic [7:0] sr; //ddata byte shift register


wire tick = (count == 10'd0); //counts number of 868 clks


always_ff @(posedge clk, posedge rst) begin

    if (rst) begin

        state <= IDLE;
        count <= 10'd0;
        bit_index <= 3'd0;
        sr <= 8'd0;
        data <= 8'd0;
        valid <= 1'b0;

    end

    else begin

        valid <= 1'b0;

        if (count != 10'd0) begin

            count <= count - 10'd1;
        end

        case(state)

        IDLE: begin

            if (start) begin
                count <= 10'(MIDBIT);
                state <= START;

            end

        end

        START: begin

            if (tick) begin

                if (rx_stable) begin

                    state <= IDLE;      //false start

                end

                else begin

                    bit_index <= 3'd0;
                    count <= 10'(RELOAD);
                    state <= DATA;

                end


            end

        end

        DATA: begin

            if (tick) begin

                sr[bit_index] <= rx_stable;  // LSB first
                count <= 10'(RELOAD);
                    
                if (bit_index == 3'd7) state <= STOP;
                else bit_index <= bit_index + 3'd1;

            end

        end

        STOP: begin

            if (tick) begin

                state <= IDLE;

                if (rx_stable) begin

                    data <= sr;
                    valid <= 1'd1;

                end

            end

        end


        default: state <= IDLE;

        endcase



    end



end


endmodule



`default_nettype wire
