`default_nettype none

// MAC n cheese
// MAC(book) ew!

module mac(

    input logic clk,
    input logic rst,
    input logic valid,
    input logic clear,
    input logic freeze, //freeze the entire mac, all 3 pipelines

    input logic signed [7:0] weight,
    input logic unsigned [7:0] activation,

    output logic signed [31:0] acc,
    output logic valid_out

);


logic signed [7:0] w_r;
logic signed [8:0] act_r;
logic valid_s1;

logic signed [16:0] prod_r;
logic valid_s2;

logic clear_s1;
logic clear_s2;




always_ff @(posedge clk, posedge rst) begin

    if (rst) begin

        w_r <= 8'b0;
        act_r <= 9'b0;
        valid_s1 <= 1'b0;

        valid_out <= 1'b0;
        acc <= 32'b0;

        prod_r <= 17'b0;
        valid_s2 <= 1'b0;

        clear_s1 <= 1'b0;
        clear_s2 <= 1'b0;
    end

    else begin

        //pipeline stage uno


        w_r <= (freeze) ? w_r : weight;
        act_r <= (freeze) ? act_r : {1'b0, activation};
        valid_s1 <= (freeze) ? valid_s1 : valid;
        clear_s1 <= (freeze) ? clear_s1 : clear;

        

        //pipeline stage deux


        valid_s2 <= (freeze) ? valid_s2 : valid_s1;
        prod_r <= (freeze) ? prod_r : (w_r * act_r);
        clear_s2 <= (freeze) ? clear_s2 : clear_s1;

        //pipeline stage 3

        acc <= (clear_s2) ? 32'b0 :
                (freeze) ? acc :
                (valid_s2) ? acc + prod_r :
                acc;

        
        
        valid_out <= (freeze) ? valid_out : valid_s2;

    end


end



endmodule


`default_nettype wire 
