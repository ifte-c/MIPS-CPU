module regfile_contr(
    input clk,
    input reset,
    input logic[4:0] rs,
    input logic[4:0] rt,
    input logic[4:0] rd,
    input logic[31:0] immed,
    input logic[5:0] opcode,
    input logic[5:0] func,
    input logic[31:0] ALUout,
    input logic[31:0] RAMDout,
    input logic[31:0] PC,
    input logic[1:0] state,
    input logic waitrequest,
    input logic active,
    input logic[31:0] hi,
    input logic[31:0] lo,

    output logic[31:0] reg_tout,
    output logic[31:0] op1,
    output logic[31:0] op2,
    output logic[31:0] register_v0
);

    logic[31:0] Write_data; 
    logic[31:0] reg_t;
    logic[4:0] Write_register;
    logic RegWrite;
    logic RegWriteEN;
    logic Enable;
    logic [31:0] hi_or_lo;

    assign hi_or_lo = func[1] == 1 ? lo:hi;
    assign reg_tout=reg_t;
    assign op2 = (opcode==0||opcode==4||opcode==5)?reg_t:immed;
    assign Write_register=(opcode==3)||(opcode==1&&(rt!==0||rt!==1))?31:
    (opcode==0)?rd:rt;
    assign Write_data= (opcode==3)||(opcode==1&&(rt!==0||rt!==1))?PC:(opcode == 0 && (func == 18 || func == 16))? hi_or_lo:
    opcode[5]==1?RAMDout:ALUout;
    assign RegWrite =((opcode[5:3]==5)||(opcode==0&&(func[4]==1)&&func!=18&&func!=16)||(opcode==0&&func==8)||opcode==4||(opcode==1&&(rt==1||rt==0))||opcode[5:1]==3||opcode==5||opcode==2)?0:1;
    assign Enable = ((state == 1 && opcode[5:3] != 4) || state == 2) && waitrequest == 0 && active == 1 ? 1 : 0;
    assign RegWriteEN= RegWrite & Enable;
   
    Reg_file2 m(
        .clk(clk), 
        .reset(reset),
        .RegWrite(RegWriteEN), 
        .Write_data(Write_data), 
        .Write_register(Write_register), 
        .Read_register_1(rs), 
        .Read_register_2(rt),
        .Read_data_1(op1),
        .Read_data_2(reg_t),
        .register_v0(register_v0)
    );
    
endmodule
