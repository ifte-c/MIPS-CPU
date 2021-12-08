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

    //control outputs
    logic reg_data_sel;
    logic[1:0] reg_dest;
    logic reg_write;
    logic IR_write;
    logic IR_sel;
    logic ALU_srcA;
    logic[1:0] ALU_srcB;
    logic[4:0] ALUop;
    logic[1:0] PC_src;
    logic PC_write;
    logic PC_write_cond;
    logic lo_sel;
    logic hi_sel;
    logic lo_en;
    logic hi_en;
    logic IoD;
    logic extend;
    logic[1:0] instr_type;
    //IR outputs
    logic[5:0] op;
    logic[4:0] rs;
    logic[4:0] rt;
    logic[4:0] rd;
    logic[4:0] shift;
    logic[5:0] func;
    logic[15:0] i;
    logic[25:0] mem_address;
    //Registers output
    logic[31:0] data_1;
    logic[31:0] data_2;
    //register select mux output
    logic[4:0] reg_data_dest;
    //data selec for register
    logic[31:0] reg_data;
    //hold registers
    logic[31:0] reg_A;
    logic[31:0] reg_B;
    //immediate changes
    logic[31:0] i_ex;
    logic[31:0] i_ex_sl;
    //ALU outputs
    logic[31:0] ALUout;
    logic[31:0] ALUout_delay;
    logic[31:0] ALUhi;
    logic[31:0] ALUlo;
    //other
    logic[31:0] mem_data;
    logic[31:0] ALU_inA;
    logic[31:0] ALU_inB;
    logic[31:0] PC_in;
    logic[31:0] PC_out;
    logic[31:0] lo_in;
    logic[31:0] hi_in;
    logic[31:0] lo_out;
    logic[31:0] hi_out;
    logic[31:0] jumpaddress;
    logic[31:0] mem_paddr;
    logic PC_write_condcomb;




    //Instruction Regsiter
    IR mips_ir(
        .mem_input(readdata), .IRWrite(IR_write), .IR_sel(IR_sel), .clk(clk),
        .reset(reset), .op(op), .rs(rs), .rt(rt), .rd(rd), .shift(shift),
        .func(func), .i(i), .mem_address(mem_address)
    );

    Mux3_5 mips_reg_write_adr_mux(
        .input_0(rt), .input_1(rd), .input_2(5'd31), .out(reg_data_dest), .select(reg_dest)
    );

    Register mips_register(
        .read_register_1(rs), .read_register_2(rt), .read_data_1(data_1), .read_data_2(data_2),
        .register_v0(register_v0), .write_register(reg_data_dest), .write_data(reg_data),
        .clk(clk), .reset(reset), .Regwrite(reg_write)
    );

    Hold_Reg A(
        .data_in(data_1), .data_out(reg_A), .clk(clk), .reset(reset)
    );

    Hold_Reg B(
        .data_in(data_2), .data_out(reg_B), .clk(clk), .reset(reset)
    );

    extend_16 mips_extend(
        .in(i), .zero_sign(extend), .out(i_ex)
    );

    shift2 mips_shift2(
        .in(i_ex), .out(i_ex_sl)
    );

    Mux2_32 mips_reg_data_in(
        .input_0(ALUout), .input_1(mem_data), .out(reg_data), .select(reg_data_sel)
    );

    mem_dec mips_mem_dec(
        .data_in(readdata), .rt(reg_B), .byteenable(byteenable), .op(op),
        .data_out(mem_data), .clk(clk), .reset(reset)
    );

    Mux4 mips_aluB_mux(
        .input_0(reg_B), .input_1(32'd4), .input_2(i_ex), .input_3(i_ex_sl), .out(ALU_inB),
        .select(ALU_srcB)
    );

    Mux2_32 mips_aluA_mux(
        .input_0(PC_out), .input_1(reg_A), .out(ALU_inA), .select(ALU_srcA)
    );

    ALU mips_alu(
        .rs(reg_A), .rt(reg_B), .shift(shift), .ALU_ctrl(ALUop), .ALU_out(ALUout),
        .ALU_lo(ALUlo), .ALU_hi(ALUhi)
    );

    Mux2_32 mips_lo_reg_mux(
        .input_0(ALUlo), .input_1(ALUout), .out(lo_in), .select(lo_sel)
    );

    Mux2_32 mips_hi_reg_mux(
        .input_0(ALUhi), .input_1(ALUout), .out(hi_in), .select(hi_sel)
    );

    lo_hi mips_lo_reg(
        .data_in(lo_in), .data_out(lo_out), .clk(clk), .reset(reset), .enable(lo_en)
    );

    lo_hi mips_hi_reg(
        .data_in(hi_in), .data_out(hi_out), .clk(clk), .reset(reset), .enable(hi_en)
    );

    Hold_Reg ALUo(
        .data_in(ALUout), .data_out(ALUout_delay), .clk(clk), .reset(reset)
    );

    Mux4 mips_pc_mux(
        .input_0(ALUout_delay), .input_1(ALUout), .input_2(jumpaddress),
        .input_3(reg_A), .out(PC_in), .select(PC_src)
    );

    j_adrs j_adrs(
        .mem_address(mem_address), .pc_val(PC_out), .jump_address(jumpaddress)
    );

    PC mips_pc(
        .nxt_pc_val(PC_in), .pc_ctrl(PC_write), .pc_write_cond(PC_write_condcomb),
        .instr_type(instr_type), .clk(clk), .reset(reset), .waitrequest(waitrequest),
        .cur_pc_val(PC_out)
    );

    Mux2_32 mips_IoD(
        .input_0(PC_out), .input_1(ALUout), .out(mem_paddr), .select(IoD)
    );

    mem_int mips_out(
        .cpu_out(mem_paddr), .op(op), .instr_type(instr_type), .mem_addr(address),
        .byteenable(byteenable)
    );

    control mips_control(
        .op(op), .func(func), .rt(rt), .clk(clk), .reset(reset), .waitrequest(waitrequest),
        .address(address), .mem_write(write), .mem_read(read), .reg_data_sel(reg_data_sel),
        .reg_dest(reg_dest), .reg_write(reg_write), .IR_write(IR_write), .IR_sel(IR_sel),
        .ALU_srcA(ALU_srcA), .ALU_srcB(ALU_srcB), .ALUop(ALUop), .PC_src(PC_src), .PC_write(PC_write),
        .PC_write_cond(PC_write_cond), .lo_sel(lo_sel), .hi_sel(hi_sel), .lo_en(lo_en), .hi_en(hi_en),
        .IoD(IoD), .extend(extend), .instr_type(instr_type)
    );

    assign writedata=reg_B;
    assign PC_write_condcomb = PC_write_cond && ALUout; 


endmodule