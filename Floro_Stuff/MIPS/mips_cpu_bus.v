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
    logic mem_write;
    logic mem_read;
    logic[1:0] reg_data_sel;
    logic[1:0] reg_dest;
    logic reg_write;
    logic IR_write;
    logic IR_sel;
    logic ALU_srcA;
    logic[1:0] ALU_srcB;
    logic[5:0] ALUop;
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

    //Instruction Regsiter
    IR mips_ir(
        .mem_input(readdata), .IRWrite(IR_write), .IR_sel(IR_sel), .clk(clk),
        .reset(reset), .op(op), .rs(rs), .rt(rt), .rd(rd), .shift(shift),
        .func(func), .i(i), .mem_address(mem_address)
    );

    Mux3_5 mips_reg_data_sel_mux(
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




endmodule