module mips_cpu_holdregALU(
    input logic[31:0] data_in,
    output logic[31:0] data_out,
    input logic ALUreg_en,
    input logic clk,
    input logic reset
);

    logic[31:0] reg_val;

    always_comb begin
        if(reset==1) begin
            data_out=0;
        end
        else begin
            data_out=reg_val;
        end
    end

    always_ff @(posedge clk) begin
        if(reset==1) begin
            reg_val <= 0;
        end
        else if (ALUreg_en==1) begin
            reg_val <= data_in;
        end
    end

endmodule