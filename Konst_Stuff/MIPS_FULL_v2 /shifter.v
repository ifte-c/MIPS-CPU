module shifter(
    input logic[5:0] opcode,
    input logic[5:0] funct,
    input logic[4:0] shamt,
    input logic[31:0] op1,
    input logic[31:0] op2,
    output logic[31:0] shift_out
);

    logic[31:0] sa;
    logic[31:0] shamt32;

    logic[31:0] left_logical;
    logic[31:0] right_logical;
    logic[31:0] right_arithmetic;

    logic reg_imm;
    logic[2:0] type_shift;

    assign left_logical = op2 << sa;
    assign right_logical = op2 >> sa;
    assign right_arithmetic = $signed(op2) >>> sa;

    assign shamt32[31:5] = 0;
    assign shamt32[4:0] = shamt;

    assign reg_imm = funct[2];
    assign type_shift = funct[2:0];

    always_comb begin
        if(reg_imm == 1) begin
            sa = op1;
        end else begin
            sa = shamt32;
        end

        case(type_shift)
        3'b000 : shift_out = left_logical;
        3'b100 : shift_out = left_logical;
        3'b011 : shift_out = right_arithmetic;
        3'b111 : shift_out = right_arithmetic;
        3'b010 : shift_out = right_logical;
        3'b110 : shift_out = right_logical;
        endcase
    end

endmodule