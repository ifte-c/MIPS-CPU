module Mux2_32_tb();

    logic[31:0] input_0;
    logic[31:0] input_1;
    logic[31:0] out;
    logic select;

    initial begin
        $dumpfile("Mux2_32_tb.vcd");
        $dumpvars(0, Mux2_32_tb);

        assign input_0=32'hFF44FF44;
        assign input_1=32'h00000001;
        assign select=0;

        #5 assert(out==32'hFF44FF44) else $fatal(2,"Error first select");
        assign input_0=32'h33AA44ff;
        assign select=1;
        #5 assert(out==32'h00000001) else $fatal(2,"Error second select");
        assign select=0;
        #5 assert(out==32'h33AA44ff) else $fatal(2,"Error select value");

    end

    Mux2_32 dut(input_0, input_1, out, select);
endmodule
