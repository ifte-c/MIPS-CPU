module mips_cpu_lohi(
    input logic[31:0] data_in,
    output logic[31:0] data_out,
    input logic clk,
    input logic reset,
    input logic enable
);

    logic[31:0] reg_val;

    always @(*) begin
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
        else if(enable==1) begin
            reg_val <= data_in;
        end
    end

endmodule