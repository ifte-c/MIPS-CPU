module control(
    input logic[5:0] op,
    input logic clk,
    input logic reset,


);

    typedef enum logic[2:0]{
        IF = 3'd0,
        ID = 3'd1,
        EX = 3'd2,
        MEM = 3'd3
     } state_t;

    state_t state;

    initial begin
        state=IF;
    end

    always_ff @(posedge clk) begin
        if(reset==1) begin
            state<=IF;
        end
        else begin

            if(state==IF) begin//Fetch cycle
                state<=ID;
            end

            else if(state==ID) begin//Instruction Decode cycke
                state<=EX;
            end

            else if(state==EX && instr_type==0) begin//Execute cycle, return to Fetch cycle
                state<=IF;
            end

            else if(state==ID && instr_type==1) begin//Execute cycle, continue to access memory cycle
                state<=MEM;
            end

            else if(state==MEM) begin//Write/Read memorcy cycle, return to Fetch cycle
                state<=IF;
            end

        end


    end

endmodule