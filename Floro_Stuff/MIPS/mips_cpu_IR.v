module mips_cpu_IR(
    input logic[31:0] mem_input,
    input logic IRWrite,
    input logic IR_sel,
    input logic clk,
    input logic reset,
    output logic[5:0] op,
    output logic[4:0] rs,
    output logic[4:0] rt,
    output logic[4:0] rd,
    output logic[4:0] shift,
    output logic[5:0] func,
    output logic[15:0] i,
    output logic[25:0] mem_address
);
    //memory unit
    logic[31:0] instr;
    //temporary values due to always_comb conflict with bit array calls
    logic[5:0] t_op;
    logic[4:0] t_rs;
    logic[4:0] t_rt;
    logic[4:0] t_rd;
    logic[4:0] t_shift;
    logic[5:0] t_func;
    logic[15:0] t_i;
    logic[25:0] t_mem_address;

    assign t_op=instr[31:26];
    assign t_rs=instr[25:21];
    assign t_rt=instr[20:16];
    assign t_rd=instr[15:11];
    assign t_shift=instr[10:6];
    assign t_func=instr[5:0];
    assign t_i=instr[15:0];
    assign t_mem_address=instr[25:0];
    //immediate passing through for ID cycle
    logic[5:0] m_op;
    logic[4:0] m_rs;
    logic[4:0] m_rt;
    logic[4:0] m_rd;
    logic[4:0] m_shift;
    logic[5:0] m_func;
    logic[15:0] m_i;
    logic[25:0] m_mem_address;

    assign m_op=mem_input[31:26];
    assign m_rs=mem_input[25:21];
    assign m_rt=mem_input[20:16];
    assign m_rd=mem_input[15:11];
    assign m_shift=mem_input[10:6];
    assign m_func=mem_input[5:0];
    assign m_i=mem_input[15:0];
    assign m_mem_address=mem_input[25:0];

    always_comb begin
        if(reset==1) begin//reset output behaviour
            op=0;
            rs=0;
            rd=0;
            rt=0;
            shift=0;
            func=0;
            i=0;
            mem_address=0;
        end
        else if(IR_sel==0) begin//runtime output behaviour
            op=t_op;
            rs=t_rs;
            rd=t_rd;
            rt=t_rt;
            shift=t_shift;
            func=t_func;
            i=t_i;
            mem_address=t_mem_address;
        end
        else if(IR_sel==1) begin
            op=m_op;
            rs=m_rs;
            rd=m_rd;
            rt=m_rt;
            shift=m_shift;
            func=m_func;
            i=m_i;
            mem_address=m_mem_address;
        end
    end

    always_ff @(posedge clk) begin
        if(reset==1) begin//stores value of zero into register during reset
            instr <= 0;
        end
        else if(IRWrite==1) begin//stores values from memory into register
            instr <= mem_input;
        end
    end

endmodule