module alu(
    input clk,
    input reset,
    input logic[31:0] op1,
    input logic[31:0] op2,
    input logic[5:0] opcode,
    input logic[5:0] funct,
    input logic[4:0] shamt,
    input logic active,
    input logic waitrequest,
    input logic[1:0] state,
    output logic[31:0] alu_out,
    output logic[63:32] hi,
    output logic[31:0] lo,
    output logic[63:0] hilo,
    output logic[3:0] branch_conditions
);


    logic[31:0] als_out;
    logic[31:0] shift_out;


    logic als_shift;
    assign als_shift = funct[5];

    always_comb begin
        if(opcode == 0) begin
            if(als_shift == 1'b1) begin
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

    shifter shift(.opcode(opcode), 
    .funct(funct), 
    .shamt(shamt), 
    .op1(op1), 
    .op2(op2), 
    .shift_out(shift_out));

    MUL_DIV_Block mdb(
    .clk(clk), 
    .reset(reset),
    .op1(op1),
    .op2(op2),
    .func(funct),
    .opcode(opcode),
    .hi(hi),
    .lo(lo),
    .hilo(hilo),
    .active(active),
    .waitrequest(waitrequest),
    .state(state)
    );

endmodule