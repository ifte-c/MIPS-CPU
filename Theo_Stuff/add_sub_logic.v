module (
    input logic[5:0] opcode,
    input logic[5:0] funct,
    input logic[31:0] op1,
    input logic[31:0] op2,
    output logic[31:0] add_sub_out
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
        
     /* if (funct == 100001) begin
            add_sub_out = add_res;
        end
        if (funct == 100010) begin
            add_sub_out = sub_res;
        end
        if (funct == 100100) begin
            add_sub_out = and_res;
        end
        if (funct == 100101) begin
            add_sub_res = or_res;
        end
        if (funct == 100110) begin
            add_sub_res = xor_res;*
        end */

        add_sub_out = funct == 100001 ? add_res : 
        funct == 100010 ? sub_res :
        funct == 100100 ? and_res :
        funct == 100101 ? or_res :
        funct == 100110 ? xor_res ;


    end else begin

        /*if (opcode == 001001 || 100000 || 100100 || 100001 || 100101 || 100011 || 101000 || 101001 || 101011) begin
            add_sub_res = add_res;
        end */

        add_sub_res = (opcode == 001001 || 100000 || 100100 || 100001 || 100101 || 100011 || 101000 || 101001 || 101011) ? add_res:
        opcode == 001100 ? and_res :
        opcode == 001101 ? or_res : 
        opcode == 001110 ? xor_res ;

    end

    
end