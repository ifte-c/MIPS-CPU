module PC(
    input logic[31:0] nxt_pc_val,
    input logic pc_ctrl,
    input logic pc_write_cond,
    input logic instr_type,
    input logic clk,
    input logic reset,
    output logic[31:0] cur_pc_val
);

    //memory unit
    logic[31:0] pc_val;
    logic[31:0] BoJ;
    logic[2:0] counter;
    logic BoJ_flag;

    //incrementing by 4 is implemented outside the PC register
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
            BoJ <= 0;
            counter <= 0;
        end
    end

    always_ff @(negedge clk) begin 
        if((pc_ctrl==1) && (pc_write_cond==0)) begin//stores next value
            pc_val <= nxt_pc_val;
        end
        else if((pc_ctrl==1) && (pc_write_cond==1)) begin //branch/jump
            BoJ <= nxt_pc_val;                            //stores branch delay
            BoJ_flag <= 1;
        end
        if((counter==2) && (instr_type==0)) begin     //checks for instr.type and
            pc_val <= BoJ;                            // corresponding counter
            counter <=0;
            BoJ_flag <=0;
        end
        else if((counter==3) && (instr_type==1)) begin
            pc_val <= BoJ;
            counter <=0;
            BoJ_flag <=0;
        end
        else if((counter==4) && (instr_type==2)) begin
            pc_val <= BoJ;
            counter <=0;
            BoJ_flag <=0;
        end  
    end


    always_ff @(negedge clk) begin//counter to ensure branch delay works
        if(BoJ_flag==1) begin
            counter <= counter+1;
        end
    end
    
endmodule