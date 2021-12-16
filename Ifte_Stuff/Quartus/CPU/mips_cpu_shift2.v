module mips_cpu_shift2(
    input logic[31:0] in,
    output logic[31:0] out
);

    assign out=in<<2;

endmodule