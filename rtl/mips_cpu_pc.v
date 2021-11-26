module mips_cpu_pc(
    input logic clk,
    input logic[31:0] addr,
    input logic[31:0] instr,
    output logic[31:0] addr_out
);

    logic[31:0] addr_inc

    always_comb begin
        addr_inc = addr + 4;
        addr = (instr[25:0]<<2) + (addr_next[31:28]<<28)
        if (instr[31:26] == 000010) begin // this implements jump instruction maybe idek
            addr_out = addr
        end
    end
