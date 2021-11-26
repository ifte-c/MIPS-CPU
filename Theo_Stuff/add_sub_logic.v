module (
    input logic[5:0] opcode,
    input logic[5:0] funct,
    input logic[31:0] op1,
    input logic[31:0] op2,
    output logic[31:0] add_sub_out
);

