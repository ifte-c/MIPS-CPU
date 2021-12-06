module shift2_tb();

    logic[31:0] in;
    logic[31:0] out;

    initial begin
        assign in=32'hffffffff;
        #5 assert(out==32'hfffffffc) else $fatal(1,"error 1, out=%h",out);
        $display("out=%b",out);
    end

    shift2 dut(in, out);

endmodule