module Mux2_5_tb();

    logic[4:0] input_0;
    logic[4:0] input_1;
    logic[4:0] out;
    logic select;

    initial begin
        $dumpfile("Mux2_5_tb.vcd");
        $dumpvars(0, Mux2_5_tb);

        assign input_0=5'b11011;
        assign input_1=5'b00001;
        assign select=0;

        #5 assert(out==5'b11011) else $fatal(2,"Error first select");
        assign input_0=5'b10101;
        assign select=1;
        #5 assert(out==5'b00001) else $fatal(2,"Error second select");
        assign select=0;
        #5 assert(out==5'b10101) else $fatal(2,"Error select value");

    end

    Mux2_5 dut(input_0, input_1, out, select);
endmodule
