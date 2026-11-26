`default_nettype none

`timescale 1ns/1ps


module featmap_bram

#(parameter int DEPTH = 5120)

(
    input wire logic clk,

    //w

    input wire logic w_en,
    input wire logic [13:0] w_addr, //bank 1 bit + 13 bit to address 5120 bytes
    input wire logic [31:0] w_data,

    //r

    input wire logic [13:0] raddr, //14 bits wide for same reason as the w_addr
    output logic [31:0] rdata
    )


    localparam int TOTAL = 2 * DEPTH; //both banks

    logic [31:0] mem_a [0:DEPTH-1];
    logic [31:0] mem_b [0:DEPTH-1];


    always_ff @(posedge clk) begin

        if (w_en && !w_addr[13]) begin
            
            mem_a[w_addr[12:0]] <= w_data; // bank 0

        end
        

        if (w_en &&  w_addr[13]) begin
            
            mem_b[w_addr[12:0]] <= w_data;  // bank 1

        end

        rdata <= raddr[13] ? mem_b[raddr[12:0]] : mem_a[raddr[12:0]];

    end


endmodule



`default_nettype wire
