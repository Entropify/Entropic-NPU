`default_nettype none

// MAC n cheese
// MAC(book) ew!

module mac(

    input logic clk,
    input logic rst,
    input logic valid,
    input logic first, //fresh new data, loads the product calculated this cycle right into acc to replace current acc

    input logic last, //giving upper level fsm a flag to tell it basically that ts data is all ready

    input logic freeze, //freeze the entire mac, all 3 pipelines

    input logic signed [7:0] weight,
    input logic unsigned [7:0] activation,

    output logic signed [31:0] acc,
    output logic valid_out,
    output logic done
);


logic signed [7:0] w_r;
logic signed [8:0] act_r;
logic valid_s1;

logic signed [16:0] prod_r;
logic valid_s2;

logic first_s1;
logic first_s2;

logic last_s1, last_s2;




always_ff @(posedge clk, posedge rst) begin

    if (rst) begin

        w_r <= 8'b0;
        act_r <= 9'b0;
        valid_s1 <= 1'b0;

        valid_out <= 1'b0;
        acc <= 32'b0;

        prod_r <= 17'b0;
        valid_s2 <= 1'b0;

        first_s1 <= 1'b0;
        first_s2 <= 1'b0;

        last_s1 <= 1'b0;
        last_s2 <= 1'b0;
        done <= 1'b0;
    end

    else begin

        //pipeline stage uno


        w_r <= (freeze) ? w_r : weight;
        act_r <= (freeze) ? act_r : {1'b0, activation};

        valid_s1 <= (freeze) ? valid_s1 : valid;

        first_s1 <= (freeze) ? first_s1 : first;
        last_s1 <= (freeze) ? last_s1 : last;

        

        //pipeline stage deux


        valid_s2 <= (freeze) ? valid_s2 : valid_s1;
        prod_r <= (freeze) ? prod_r : (w_r * act_r);

        first_s2 <= (freeze) ? first_s2 : first_s1;
        last_s2 <= (freeze) ? last_s2 : last_s1;

        //pipeline stage 3

        if (freeze) acc <= acc;
        else if (valid_s2 && first_s2) acc <= prod_r;
        else if (valid_s2) acc <= acc + prod_r;

        
        
        valid_out <= (freeze) ? valid_out :  valid_s2;
        done <= (freeze) ? 1'b0 : (valid_s2 && last_s2);

    end


end



endmodule


`default_nettype wire 
