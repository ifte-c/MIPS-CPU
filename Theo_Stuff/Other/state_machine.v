module state_machine(
    input logic clk,
    input logic wait_req,
    input logic reset,
    input logic[31:0] mem_address,
    input logic[5:0] opcode,
    output logic[1:0] state
);

    always_ff @(posedge clk) begin

        if (state != 3) begin

            if ((reset == 1) || ((state == 2) && (wait_req != 1))) begin
                state <= 0;
            end 

            if ((state == 0) && (opcode == 6'b100000 || 6'b100100 || 6'b100001 || 6'b100101 || 6'b100011 || 6'b100010 || 6'b100110)) begin
                state <= 1;
            end

            else if ((state == 0) || (state == 1 && (opcode == 6'b100000 || 6'b100100 || 6'b100001 || 6'b100101 || 6'b100011 || 6'b100010 || 6'b100110))) begin
                state <= 2;
            end

            if (mem_address == 0) begin
                state <= 3;
            end

        end else if(reset == 1) begin
            
            state <= 0;

        end

    end

endmodule