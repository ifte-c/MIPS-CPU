module add_sub_logic_tb();

    logic[5:0] opcode;
    logic[5:0] funct;
    logic[31:0] op1;
    logic[31:0] op2;

    logic[31:0] add_sub_out;
    logic[3:0] branch_conditions;

    assign op1 = 0;
    assign op2 = 9;

    initial begin
        opcode = 6'b001001;
        funct = 6'b000000;
        #2;  
        $display ("branch_conditions = %b", branch_conditions);
        assert(op1 + op2 == add_sub_out) else $fatal(1, "addiu is wrong."); 
        /*---------------------------------------------------------------------*/
        opcode = 6'b000000;
        funct = 6'b100001;
        #2;  
        assert(op1 + op2 == add_sub_out) else $fatal(1, "addu is wrong.");
        /*---------------------------------------------------------------------*/
        opcode = 6'b100000;
        funct = 6'b000000;
        #2;  
        assert(op1 + op2 == add_sub_out) else $fatal(1, "lb is wrong.");
        /*---------------------------------------------------------------------*/
        opcode = 6'b100100;
        funct = 6'b000000;
        #2;  
        assert(op1 + op2 == add_sub_out) else $fatal(1, "lbu is wrong.");
        /*---------------------------------------------------------------------*/
        opcode = 6'b100001;
        funct = 6'b000000;
        #2;  
        assert(op1 + op2 == add_sub_out) else $fatal(1, "lh is wrong.");
        /*---------------------------------------------------------------------*/
        opcode = 6'b100101;
        funct = 6'b000000;
        #2;  
        assert(op1 + op2 == add_sub_out) else $fatal(1, "lhu is wrong.");
        /*---------------------------------------------------------------------*/
        opcode = 6'b100011;
        funct = 6'b000000;
        #2;  
        assert(op1 + op2 == add_sub_out) else $fatal(1, "lw is wrong.");
        /*---------------------------------------------------------------------*/
        opcode = 6'b101000;
        funct = 6'b000000;
        #2;  
        assert(op1 + op2 == add_sub_out) else $fatal(1, "sb is wrong.");
        /*---------------------------------------------------------------------*/
        opcode = 6'b101001;
        funct = 6'b000000;
        #2;  
        assert(op1 + op2 == add_sub_out) else $fatal(1, "sh is wrong.");
        /*---------------------------------------------------------------------*/
        opcode = 6'b101011;
        funct = 6'b000000;
        #2;  
        assert(op1 + op2 == add_sub_out) else $fatal(1, "sw is wrong.");
        /*---------------------------------------------------------------------*/
        opcode = 6'b000000;
        funct = 6'b100011;
        #2;  
        assert(op1 - op2 == add_sub_out) else $fatal(1, "subu is wrong.");
        /*---------------------------------------------------------------------*/
        opcode = 6'b000000;
        funct = 6'b100100;
        #2;
        $display ("op1 & op2 = %b, add_sub_logic = %b", op1 & op2, add_sub_out);
        assert((op1 & op2) == add_sub_out) else $fatal(1, "and is wrong.");
        /*---------------------------------------------------------------------*/
        opcode = 6'b001100;
        funct = 6'b000000;
        #2;  
        assert((op1 & op2) == add_sub_out) else $fatal(1, "andi is wrong.");
        /*---------------------------------------------------------------------*/
        opcode = 6'b000000;
        funct = 6'b100101;
        #2;  
        assert((op1 | op2) == add_sub_out) else $fatal(1, "or is wrong.");
        /*---------------------------------------------------------------------*/
        opcode = 6'b001101;
        funct = 6'b000000;
        #2;  
        assert((op1 | op2) == add_sub_out) else $fatal(1, "ori is wrong.");
        /*---------------------------------------------------------------------*/
        opcode = 6'b000000;
        funct = 6'b100110;
        #2;  
        assert((op1 ^ op2) == add_sub_out) else $fatal(1, "xor is wrong.");
        /*---------------------------------------------------------------------*/
        opcode = 6'b001110;
        funct = 6'b000000;
        #2;  
        assert((op1 ^ op2) == add_sub_out) else $fatal(1, "xori is wrong.");
    end

    add_sub_logic dut(.opcode(opcode), .funct(funct), .op1(op1), .op2(op2), .add_sub_out(add_sub_out), .branch_conditions(branch_conditions));

endmodule