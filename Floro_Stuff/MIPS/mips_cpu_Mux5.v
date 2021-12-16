module mips_cpu_Mux5(
    input logic[31:0] input_0,
    input logic[31:0] input_1,
    input logic[31:0] input_2,
    input logic[31:0] input_3,
    input logic[31:0] input_4,
    output logic[31:0] out,
    input logic[2:0] select
);

    
    always_comb begin
        case(select)
        0 : out=input_0;
        1 : out=input_1;
        2 : out=input_2;
        3 : out=input_3;
        4 : out=input_4;

        endcase
    end

endmodule