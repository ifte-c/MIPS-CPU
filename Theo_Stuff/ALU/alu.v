module alu(
    input clk,
    input reset,
    input logic[31:0] ir,
    input logic[31:0] op1,
    input logic[31:0] op2,
    output logic[31:0] alu_out,
    output logic[63:32] hi,
    output logic[31:0] lo,
    output logic[63:0] hilo,
    output logic[3:0] branch_conditions
);

    logic[5:0] opcode;
    logic[5:0] funct;

    logic[31:0] als_out;
    logic[31:0] shift_out;

    assign opcode = ir[31:26];
    assign funct = ir[5:0];

    always_comb begin
        if(opcode == 0) begin
            if(funct[5] == 1'b1) begin
                alu_out = als_out;
            end else begin
                alu_out = shift_out;
            end
        end else begin
            alu_out = als_out;
        end
    end

    add_sub_logic asl(.opcode(opcode), 
    .funct(funct), 
    .op1(op1), 
    .op2(op2), 
    .add_sub_out(als_out), 
    .branch_conditions(branch_conditions)
    );

    MUL_DIV_Block mdb(
    .clk(clk), 
    .reset(reset),
    .op1(op1),
    .op2(op2),
    .func(funct),
    .opcode(opcode),
    .hi(hi),
    .lo(lo),
    .hilo(hilo)
    );

endmodule