module split_tb();
    logic[31:0] instr;
    logic[5:0] op;
    logic[4:0] rs;
    logic[4:0] rd;
    logic[4:0] rt;
    logic[4:0] shift;
    logic[5:0] func;
    logic[15:0] imm;
    logic[25:0] target;
    
    initial begin
        instr=32'b10101000000111111100101010110000;
        #5;
        assert(op==6'b101010) else $fatal(2,"op wrong");
        assert(rs==5'b00000) else $fatal(2,"rs wrong");
        assert(rd==5'b11111) else $fatal(2,"rd wrong");
        assert(rt==5'b11001) else $fatal(2,"rt wrong");
        assert(shift==5'b01010) else $fatal(2,"shift wrong");
        assert(func==6'b110000) else $fatal(2,"func wrong");
        assert(imm==16'b1100101010110000) else $fatal(2,"imm wrong");
        assert(target==26'b00000111111100101010110000) else $fatal(2,"target wrong");
    end


    split s(instr, op, rs, rd, rt, shift, func, imm, target);
endmodule