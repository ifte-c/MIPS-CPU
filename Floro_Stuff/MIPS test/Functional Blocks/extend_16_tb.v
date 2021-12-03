module extend_16_tb();

    logic[15:0] in;
    logic[31:0] out;
    logic zero_sign;

    initial begin
        assign in=16'h0fff;
        assign zero_sign=0;
        #5 assert(out==32'h00000fff) else $fatal(1,"error 1, out=%h",out);
        $display("out=%h",out);
        assign in=16'hf000;
        #5 assert(out==32'hfffff000) else $fatal(1,"error 2, out=%h",out);
        $display("out=%h",out);
        assign zero_sign=1;
        #5 assert(out==32'h0000f000) else $fatal(1,"error 3, out=%h",out);
        $display("out=%h",out);
    end

    extend_16 dut(in, zero_sign, out);

endmodule