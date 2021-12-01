module mips_cpu_pc(
    input logic clk,
    input logic[5:0] opcode,
    input logic[5:0] funct,
    input logic[4:0] rs,
    input logic[15:0] offset,
    input logic[25:0] target,
    input logic[3:0] control,
    output logic[31:0] pc_out,
    output logic[4:0] rd,
    output logic[31:0] r31
);

    logic[31:0] pc;
    logic[31:0] pc_inc;

    initial pc = 32'b10111111110000000000000000000000;
    assign pc_inc = pc+4;

    always_ff @(posedge clk) begin
        if (opcode == 000010) begin // jump
            pc_out <= { 4'b0000, target, 2'b00 } + { pc_inc[31:28], 28'b0000000000000000000000000000 };
        end else if (opcode == 000011) begin //jal
            r31 <= pc_inc;
            pc_out <= { 4'b0000, target, 2'b00 };
        end else if (opcode == 0 && funct == 6'b001001) begin //jalr
            rd <= pc_inc; //wrong
            pc_out <= rs; //wrong
        end
        else begin
            pc <= pc_inc;
        end
    end

endmodule
