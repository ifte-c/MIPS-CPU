module IR(
    input logic[31:0] mem_input,
    input logic[1:0] state,
    input logic clk,
    input logic reset,
    output logic[5:0] op,
    output logic[4:0] rs,
    output logic[4:0] rt,
    output logic[4:0] rd,
    output logic[4:0] shamt,
    output logic[5:0] func,
    output logic[15:0] immediate,
    output logic[25:0] target
);
    //memory unit
    logic[31:0] instr;
    //temporary values due to always_comb conflict with bit array calls
    logic[5:0] t_op;
	assign t_op=instr[31:26];
    logic[4:0] t_rs;
	assign t_rs=instr[25:21];
    logic[4:0] t_rt;
	assign t_rt=instr[20:16];
    logic[4:0] t_rd;
	assign t_rd=instr[15:11];
    logic[4:0] t_shamt;
	assign t_shamt=instr[10:6];
    logic[5:0] t_func;
	assign t_func=instr[5:0];
    logic[15:0] t_immediate;
	assign t_immediate=instr[15:0];
    logic[25:0] t_target;
	assign t_target=instr[25:0];
    //immediate passing through for ID cycle
    logic[5:0] m_op;
	assign m_op=mem_input[31:26];
    logic[4:0] m_rs;
	assign m_rs=mem_input[25:21];
    logic[4:0] m_rt;
	assign m_rt=mem_input[20:16];
    logic[4:0] m_rd;
	assign m_rd=mem_input[15:11];
    logic[4:0] m_shamt;
	assign m_shamt=mem_input[10:6];
    logic[5:0] m_func;
	assign m_func=mem_input[5:0];
    logic[15:0] m_immediate;
	assign m_func=mem_input[15:0];
    logic[25:0] m_target;
	assign m_target=mem_input[25:0];

    always @(*) begin
        if(reset==1) begin//reset output behaviour
            op=0;
            rs=0;
            rd=0;
            rt=0;
            shamt=0;
            func=0;
            immediate=0;
            target=0;
        end
        else if(state==2) begin//runtime output behaviour
            op=t_op;
            rs=t_rs;
            rd=t_rd;
            rt=t_rd;
            shamt=t_shamt;
            func=t_func;
            immediate=t_immediate;
            target=t_target;
        end
        else begin
            op=m_op;
            rs=m_rs;
            rd=m_rd;
            rt=m_rd;
            shamt=m_shamt;
            func=m_func;
            immediate=m_immediate;
            target=m_target;
        end
    end

    always_ff @(posedge clk) begin
        if(reset==1) begin//stores value of zero into register during reset
            instr <= 0;
        end
        else if(state==1) begin//stores values from memory into register
            instr <= mem_input;
        end
    end

endmodule