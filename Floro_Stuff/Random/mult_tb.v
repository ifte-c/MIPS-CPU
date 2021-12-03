module mult_tb();

    logic  [3:0]a;
    logic  [3:0]b;
    logic  [7:0]c;

    initial begin
        assign a=-5;
        assign b=-3;
        #5 assert(c==15) else $fatal(1,"error=%d",c);
    end

    mult dut(a, b, c);
endmodule