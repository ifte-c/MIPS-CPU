module Mux3_tb();

    logic[31:0] input_0;
    logic[31:0] input_1;
    logic[31:0] input_2;
    logic[31:0] out;
    logic[1:0] select;

    initial begin
        $dumpfile("Mux3_tb.vcd");
        $dumpvars(0, Mux3_tb);

        assign input_0=32'hFF44FF44;
        assign input_1=32'h00000001;
        assign input_2=32'hffffffff;
        assign select=0;

        #5 assert(out==32'hFF44FF44) else $fatal(2,"Error first select");
        assign input_0=32'h33AA44ff;
        assign select=1;
        #5 assert(out==32'h00000001) else $fatal(2,"Error second select");
        assign select=2;
        #5 assert(out==32'hffffffff) else $fatal(2,"Error select value");
        assign select=0;
        #5 assert(out==32'h33AA44ff) else $fatal(2,"Error select value");

    end

    Mux3 dut(input_0, input_1, input_2, out, select);
endmodule
