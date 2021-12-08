    module Mux2_32(
    input logic[31:0] input_0,
    input logic[31:0] input_1,
    output logic[31:0] out,
    input logic select
);

    
    always_comb begin
        case(select)
        0 : out=input_0;
        1 : out=input_1;
        endcase
    end

endmodule