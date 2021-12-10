module mips_cpu_Mux3S5(
    input logic[4:0] input_0,
    input logic[4:0] input_1,
    input logic[4:0] input_2,
    output logic[4:0] out,
    input logic[1:0] select
);

    
    always_comb begin
        case(select)
        0 : out=input_0;
        1 : out=input_1;
        2 : out=input_2;
        endcase
    end

endmodule