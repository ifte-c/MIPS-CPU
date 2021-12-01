module PC(
    input logic[31:0] nxt_pc_val,
    input logic pc_ctrl,
    input logic clk,
    input logic reset,
    output logic[31:0] cur_pc_val
);

    //memory unit
    logic[31:0] pc_val;

    //incrementing by 4, branch, and jump instructions
    //are implemented outside the PC register
    always_comb begin
        if(reset==1) begin//reset ouput behaviour
            cur_pc_val=0;
        end
        else begin//runtime output behaviour
            cur_pc_val=pc_val;
        end
    end

    always_ff @(posedge clk) begin
        if(reset==1) begin//stores value 0 during reset
            pc_val <= 0;
        end
        else if(pc_ctrl==1) begin//stores next value
            pc_val <= nxt_pc_val;
        end
    end
    
endmodule