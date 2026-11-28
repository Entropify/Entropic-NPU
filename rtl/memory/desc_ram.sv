`default_nettype none
`timescale 1ns/1ps


module desc_ram (
    
    input wire logic clk,

    input wire logic w_en,
    input wire logic [3:0] w_addr,
    input wire logic [127:0] w_data,

    input wire logic [3:0] r_addr,
    output logic [127:0] r_data
);


    (* ram_style = "distributed" *)
    logic [127:0] mem [0:15];

    always_ff @(posedge clk) begin

        if (w_en) mem[w_addr] <= w_data;

        r_data <= mem[r_addr];

    end
    

endmodule

`default_nettype wire
