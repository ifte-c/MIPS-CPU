module mips_cpu_pc(
    input logic clk,
    input logic[31:0] addr,
    input logic[31:0] instr,
    output logic[31:0] addr_out
);

    always_ff @(posedge clk) begin
        if (instr[31:26] == 000010) begin // this implements jump instruction maybe idek
            addr <= { 4'b0000, instr[25:0], 2'b00 } + { (addr+4)[31:28], 28'b0000000000000000000000000000 };
        end
    end

endmodule
