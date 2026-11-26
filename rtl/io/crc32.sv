`default_nettype none
`timescale 1ns/1ps


module crc32 (
    input  wire logic clk,
    input  wire logic rst,

    input  wire logic init, // start of frame
    input  wire logic valid,  // one byte to fold in
    input  wire logic [7:0] data,

    output logic [31:0]crc// final, complemented value
);

    function automatic logic [31:0] crc_byte(
        input logic [31:0] c,
        input logic [7:0] b);

        logic [31:0] t;
        t = c ^ 32'(b);                     // xor the byte into the low 8 bits

        for (int i = 0; i < 8; i++)

            t = (t >> 1) ^ (t[0] ? 32'hEDB8_8320 : 32'h0);

        crc_byte = t;

    endfunction

    logic [31:0] crc_r;

    always_ff @(posedge clk, posedge rst) begin

        if (rst) crc_r <= 32'hFFFF_FFFF;
        else if (init) crc_r <= 32'hFFFF_FFFF;
        else if (valid) crc_r <= crc_byte(crc_r, data);

    end

    assign crc = crc_r ^ 32'hFFFF_FFFF;

endmodule



`default_nettype wire
