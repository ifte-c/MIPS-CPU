module mips_cpu_bus(
    /* Standard signals */
    input logic clk,
    input logic reset,
    output logic active,
    output logic[31:0] register_v0,

    /* Avalon memory mapped bus controller (master) */
    output logic[31:0] address,
    output logic write,
    output logic read,
    input logic waitrequest,
    output logic[31:0] writedata,
    output logic[3:0] byteenable,
    input logic[31:0] readdata
);

    logic[4:0] rs;
    logic[4:0] rt;
    logic[4:0] rd;
    logic[1:0] state;
    logic[4:0] shamt;
    logic[5:0] func;
    logic[31:0] immediate_ext;
    logic[25:0] target;
    logic[5:0] opcode;
    logic[31:0] ALUout;
    logic[31:0] RAMDout_2;
    logic[31:0] regstore;
    logic[31:0] op1;
    logic[31:0] op2;
    logic[31:0] register_t;
    logic[31:0] hi;
    logic[31:0] lo;
    logic[63:0] hilo;
    logic[3:0] branch_cond;
    logic[31:0] pc;
    logic[3:0] byteenable_log;
    logic[31:0] mem_addr_init;
    logic[31:0] CPU_Dout;
    logic waitreq_relev;
    logic[15:0] immediate;
    
    assign immediate_ext={16'b0000000000000000,immediate[15:0]};
    assign waitreq_relev = (waitrequest && (state == 0 || (state == 1 && opcode[5] == 1)))? 1 : 0 ;
    assign write = (state==1 && opcode[5:3]==5)?1:0;
    assign read = (state==1 && opcode[5:3]==4)?1:0;
    assign byteenable = byteenable_log;
    assign mem_addr_init = (state ==0 || (state == 1 && waitrequest == 1))? pc : ALUout;

 IR mb(
    .clk(clk), .reset(reset), .rs(rs), .rt(rt), .rd(rd),
    .state(state), .shamt(shamt), .func(func), .target(target),
    .op(opcode), .mem_input(readdata), .immediate(immediate)
  );

 regfile_contr mt(
    .clk(clk), .reset(reset), .rs(rs), .rt(rt), 
    .rd(rd), .immed(immediate_ext), .opcode(opcode), .func(func),
    .ALUout(ALUout), .RAMDout(RAMDout_2), .PC(regstore), .state(state),
    .op1(op1), .op2(op2), .reg_tout(register_t), .register_v0(register_v0),
    .waitrequest(waitreq_relev), .active(active)
);


 alu mg(
     .clk(clk), .reset(reset), .opcode(opcode), .funct(func), 
     .op1(op1), .op2(op2), .hi(hi), .lo(lo), .branch_conditions(branch_cond), 
     .hilo(hilo), .alu_out(ALUout), .shamt(shamt), .active(active), .waitrequest(waitreq_relev),
     .state(state)
 );

 
mips_cpu_pc mk(
     .clk(clk), .reset(reset), .rt(rt), .rd(rd), .opcode(opcode),  
     .offset(immediate), .sa(shamt), .funct(func), .rs_data(op1), .target(target),
     .control(branch_cond), .pc(pc),  .state(state),
     .active(active), .waitrequest(waitreq_relev), .regstore(regstore)
     );

 mem_int ma(
    .cpu_out(mem_addr_init), .op(opcode),
    .mem_addr(address), .byteenable(byteenable_log),
    .func(func), .rt(rt)
);

 mem_dec mo(
     .data_in(readdata), .rt(register_t), .byteenable(byteenable_log),
     .op(opcode), .data_out(RAMDout_2), .clk(clk), .reset(reset),
     .active(active), .waitrequest(waitreq_relev)
 );

 state_machine mi(
     .clk(clk), .wait_req(waitreq_relev), .reset(reset),
     .mem_address(pc), .active(active), .state(state),
     .opcode(opcode)
 );

 store_filter m(
     .data_in(register_t), .op(opcode),
     .data_out(writedata)
 );



endmodule