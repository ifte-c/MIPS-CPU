module add_sub_logic(
    input logic[5:0] opcode,
    input logic[5:0] funct,
    input logic[31:0] op1,
    input logic[31:0] op2,
    output logic[31:0] add_sub_out,
    output logic[3:0] branch_conditions
);


    logic[31:0] add_res;
    logic[31:0] sub_res;
    logic[31:0] and_res;
    logic[31:0] or_res;
    logic[31:0] xor_res;


    assign add_res = op1 + op2;
    assign sub_res = op1 - op2;
    assign and_res = op1 & op2; 
    assign or_res = op1 | op2;
    assign xor_res = op1 ^ op2;


    always_comb begin
        if (opcode == 000000) begin

            /*add_sub_out = funct == 100001 ? add_res : 
            funct == 100010 ? sub_res :
            funct == 100100 ? and_res :
            funct == 100101 ? or_res :
            funct == 100110 ? xor_res; */

            case (funct)
            6'b100001 : add_sub_out = add_res;
            6'b100011 : add_sub_out = sub_res;
            6'b100100 : add_sub_out = and_res;
            6'b100101 : add_sub_out = or_res;
            6'b100110 : add_sub_out = xor_res;
            endcase 
            

        end else begin

            /*add_sub_res = (opcode == 001001 || 100000 || 100100 || 100001 || 100101 || 100011 || 101000 || 101001 || 101011) ? add_res:
            opcode == 001100 ? and_res :
            opcode == 001101 ? or_res : 
            opcode == 001110 ? xor_res; */

            case(opcode)
            6'b001001 : add_sub_out = add_res;
            6'b100000 : add_sub_out = add_res;
            6'b100100 : add_sub_out = add_res;
            6'b100001 : add_sub_out = add_res;
            6'b100101 : add_sub_out = add_res;
            6'b100011 : add_sub_out = add_res;
            6'b101000 : add_sub_out = add_res;
            6'b101001 : add_sub_out = add_res; 
            6'b101011 : add_sub_out = add_res;
            6'b001100 : add_sub_out = and_res;
            6'b001101 : add_sub_out = or_res;
            6'b001110 : add_sub_out = xor_res;
            endcase

        end

        /*branch_conditions[2:0] = op1 < 0 ? 3'b001 :
        op1 == 0 ? 3'b010 :
        op1 > 0 ? 3'b100 ; */

        if (op1 < 1)
            branch_conditions[2:0] = 3'b001;
        else if (op1 == 0) begin
            branch_conditions[2:0] = 3'b010;
        end else begin
            branch_conditions[2:0] = 3'b100;
        end 

        branch_conditions[3] = (op1 == op2 ? 1 : 0);
        
    end

endmodule