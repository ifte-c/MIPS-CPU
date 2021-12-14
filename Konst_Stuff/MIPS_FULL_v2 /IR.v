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
    output logic[25:0] target,
    input  logic waitreq_sync,
    input logic waitreq_relev,
    input logic waitreq_plus
);
    //memory unit
    logic[31:0] instr;
    //temporary values due to always_comb conflict with bit array calls
    logic[5:0] t_op;
    logic[4:0] t_rs;
    logic[4:0] t_rt;
    logic[4:0] t_rd;
    logic[4:0] t_shamt;
    logic[5:0] t_func;
    logic[15:0] t_immediate;
    logic[25:0] t_target;
    //immediate passing through for ID cycle
    logic[5:0] m_op;
    logic[4:0] m_rs;
    logic[4:0] m_rt;
    logic[4:0] m_rd;
    logic[4:0] m_shamt;
    logic[5:0] m_func;
    logic[15:0] m_immediate;
    logic[25:0] m_target;
    logic waitreq_offset;
    logic[2:0] op_msbs;
    
    //logic waitreq_start;
    //logic waitreq_end;

    assign t_op = instr[31:26];
    assign t_rs=instr[25:21];
    assign t_rt=instr[20:16];
    assign t_rd=instr[15:11];
    assign t_shamt=instr[10:6];
    assign t_func=instr[5:0];
    assign t_immediate=instr[15:0];
    assign t_target=instr[25:0];
    assign m_op = mem_input[31:26];
    assign m_rs=mem_input[25:21];
    assign m_rt=mem_input[20:16];
    assign m_rd=mem_input[15:11];
    assign m_shamt=mem_input[10:6];
    assign m_func=mem_input[5:0];
    assign m_immediate=mem_input[15:0];
    assign m_target=mem_input[25:0];
    assign op_msbs=op[5];
    
    //assign waitreq_start = (waitrequest^waitreq_offset)&waitrequest;
    //assign waitreq_end = (waitrequest^waitreq_offset)&waitreq_offset;

    always_comb begin
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
        else if (state==2 || (state==1 &&  waitreq_offset == 1 && op_msbs == 1)) begin//runtime output behaviour
            op=t_op;
            rs=t_rs;
            rd=t_rd;
            rt=t_rt;
            shamt=t_shamt;
            func=t_func;
            immediate=t_immediate;
            target=t_target;
        end
        else begin
            op=m_op;
            rs=m_rs;
            rd=m_rd;
            rt=m_rt;
            shamt=m_shamt;
            func=m_func;
            immediate=m_immediate;
            target=m_target;
        end
    end

    always_ff @(posedge clk) begin
        
        if (state != 0) begin
            waitreq_offset <= waitreq_sync;
        end
        if(reset==1) begin//stores value of zero into register during reset
            instr <= 0;
        end
        else if(state==1)/*||(state==1 && waitreq_start==1)*/ begin//stores values from memory into register
           if ( (state == 1 && waitreq_sync == 0 )||( waitreq_relev == 1 && waitreq_plus != 1)) begin 
 
               instr <= mem_input;

           end
        end
    end

endmodule