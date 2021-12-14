
module regfile_contr_tb(

);

logic clk;
logic reset;
logic[4:0] rs;
logic[4:0] rt;
logic[4:0] rd;
logic[31:0] immed;
logic[5:0] opcode;
logic[5:0] func;
logic[31:0] ALUout;
logic[31:0] RAMDout;
logic[31:0] PC;
logic EXEC3;
logic[31:0] reg_t;
logic[31:0] op1;
logic[31:0] op2;

initial begin
        $dumpfile("regfile_contr.vcd");
        $dumpvars(0, regfile_contr_tb);
        clk = 0;

        #5;

        repeat (3700) begin
            #10 clk = !clk;
        end

        $finish;
end

initial begin


        rs=5;
        rt=10;
        rd=15;
        ALUout=69;
        RAMDout=420;
        PC=12;
        immed=36;
        reset=0;

        opcode=4;
        func=0;
        EXEC3=0;
        //BEQ
        
            @(negedge clk)
            $display("op1=%d, op2=%d, reg_t=%d", op1, op2, reg_t);
            assert( op1 == 50) else $fatal(1, "Wrong");
            assert( op2 == 100) else $fatal(1, "Wrong");
            assert( reg_t== 100) else $fatal(1, "Wrong");
        
        #2;
        

        opcode=0;
        func=6'b100010;
        EXEC3=0;
        //SUB
        
            @(negedge clk)
            $display("op1=%d, op2=%d, reg_t=%d", op1, op2, reg_t);
            assert( op1== 50) else $fatal(1, "Wrong");
            assert( op2== 100) else $fatal(1, "Wrong");
            assert( reg_t== 100) else $fatal(1, "Wrong");
        
        #2;

        opcode=9;
        func=16;
        EXEC3=0;
        //ADDIU
        
            @(negedge clk)
            $display("op1=%d, op2=%d, reg_t=%d", op1, op2, reg_t);
            assert( op1== 50) else $fatal(1, "Wrong");
            assert( op2== 36) else $fatal(1, "Wrong");
            assert( reg_t== 100) else $fatal(1, "Wrong");
        
        #2;


        opcode=32;
        func=43;
        EXEC3=1;
        //LB
        
            @(negedge clk)
            $display("op1=%d, op2=%d, reg_t=%d", op1, op2, reg_t);
            assert( op1== 50) else $fatal(1, "Wrong");
            assert( op2== 36) else $fatal(1, "Wrong");
            assert( reg_t== 420) else $fatal(1, "Wrong");
        
        #2;

        opcode=32;
        func=43;
        EXEC3=1;
        //LB
        
            @(negedge clk)
            $display("op1=%d, op2=%d, reg_t=%d", op1, op2, reg_t);
            assert( op1== 50) else $fatal(1, "Wrong");
            assert( op2== 36) else $fatal(1, "Wrong");
            assert( reg_t== 420) else $fatal(1, "Wrong");
        
        #2;

            @(negedge clk)
            $display("op1=%d, op2=%d, reg_t=%d", op1, op2, reg_t);
            assert( op1== 50) else $fatal(1, "Wrong");
            assert( op2== 36) else $fatal(1, "Wrong");
            assert( reg_t== 420) else $fatal(1, "Wrong");
        
        #2;


        $finish;
    end



regfile_contr m(
.clk(clk), .reset(reset), .rs(rs), .rt(rt), 
.rd, .immed(immed), .opcode(opcode), .func(func), 
.ALUout(ALUout), .RAMDout(RAMDout), .PC(PC),
.EXEC3(EXEC3), .reg_tout(reg_t), .op1(op1), .op2(op2)
);

endmodule

