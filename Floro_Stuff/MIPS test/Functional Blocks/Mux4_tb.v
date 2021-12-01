module Mux4_tb();

    logic[31:0] input_0;
    logic[31:0] input_1;
    logic[31:0] input_2;
    logic[31:0] input_3;
    logic[31:0] out;
    logic[1:0] select;

    initial begin
        $dumpfile("Mux4_tb.vcd");
        $dumpvars(0, Mux4_tb);

        assign input_0=32'hFF44FF44;
        assign input_1=32'h00000001;
        assign input_2=32'hffffffff;
        assign input_3=32'h11122233;
        assign select=0;

        #5 assert(out==32'hFF44FF44) else $fatal(2,"Error first select");
        assign input_0=32'h33AA44ff;
        assign select=1;
        #5 assert(out==32'h00000001) else $fatal(2,"Error second select");
        assign select=2;
        #5 assert(out==32'hffffffff) else $fatal(2,"Error third value");
        assign select=3;
        #5 assert(out==32'h11122233) else $fatal(2,"Error fourth value");
        assign select=0;
        #5 assert(out==32'h33AA44ff) else $fatal(2,"Error select value");

    end

    Mux4 dut(input_0, input_1, input_2, input_3, out, select);
endmodule
