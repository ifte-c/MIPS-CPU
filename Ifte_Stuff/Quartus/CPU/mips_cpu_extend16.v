module mips_cpu_extend16(
    input logic[15:0] in,
    input logic zero_sign,
    output logic[31:0] out
);

    logic tmp;
    assign tmp=in[15];
    //required to void SystemVerilog Error
    //constant selects not available in always_comb

    always @(*) begin
        if( (tmp==1)&&(zero_sign==0)) begin//0 sign extend
            out={16'hffff,in};
        end
        else begin
            out={16'h0000,in};//1 zero extend
        end
    end

endmodule