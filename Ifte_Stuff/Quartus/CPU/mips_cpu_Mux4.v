module mips_cpu_Mux4(
    input logic[31:0] input_0,
    input logic[31:0] input_1,
    input logic[31:0] input_2,
    input logic[31:0] input_3,
    output logic[31:0] out,
    input logic[1:0] select
);

    
    always @(*) begin
        case(select)
        0 : out=input_0;
        1 : out=input_1;
        2 : out=input_2;
        3 : out=input_3;
        endcase
    end

endmodule