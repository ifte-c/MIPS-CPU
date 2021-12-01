module IR(
    input logic[31:0] mem_input,
    input logic IRWrite,
    input logic clk,
    input logic reset,
    output logic[5:0] op,
    output logic[4:0] rs,
    output logic[4:0] rd,
    output logic[4:0] rt,
    output logic[4:0] shift,
    output logic[5:0] func,
    output logic[15:0] i,
    output logic[25:0] mem_address,
    output logic[31:0] mem_data
);
    //memory unit
    logic[31:0] instr;
    //temporary values due to always_comb conflict with bit array calls
    logic[5:0] t_op=instr[31:26];
    logic[4:0] t_rs=instr[25:21];
    logic[4:0] t_rd=instr[20:16];
    logic[4:0] t_rt=instr[15:11];
    logic[4:0] t_shift=instr[10:6];
    logic[5:0] t_func=instr[5:0];
    logic[15:0] t_i=instr[15:0];
    logic[25:0] t_mem_address=instr[25:0];
    logic[31:0] t_mem_data=instr[31:0];

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
            mem_data=0;
        end
        else begin//runtime output behaviour
            op=t_op;
            rs=t_rs;
            rd=t_rd;
            rt=t_rd;
            shift=t_shift;
            func=t_func;
            i=t_i;
            mem_address=t_mem_address;
            mem_data=t_mem_data;
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