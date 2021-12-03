module MUL_DIV_tb(
);
    logic clk;
    logic signed[31:0] op1, op2;
    logic [31:0] hi;
    logic [31:0] lo;
    logic signed[63:0] r;
    logic [5:0] opcode;
    logic [5:0] func;
    logic reset;

    initial begin
        $dumpfile("multiplier_parallel.vcd");
        $dumpvars(0, MUL_DIV_tb);
        clk = 0;

        #5;

        repeat (3700) begin
            #10 clk = !clk;
        end

        $finish;
    end

    initial begin
         op1 = 8;
         op2 = -5;
         opcode=0;
         func=24;
         reset=0;
            @(negedge clk)
            $display("op1=%d, op2=%d, hi=%d, lo=%d, r=%d", op1, op2,hi ,lo,r);
            assert(op1*op2 == r ) else $fatal(1, "Product is wrong.");
        

        #5

        op1 = 8;
        op2 = -5;
         opcode=0;
         func=25;
         reset=0;
            @(negedge clk)
            $display("op1=%d, op2=%d, hi=%d, lo=%d, r=%d", op1, op2,hi ,lo,r);
            //assert(op1*op2 == r ) else $fatal(1, "Product is wrong.");
        
        #5
        

        op1 = 40;
        op2 = -4;
         opcode=0;
         func=26;
         reset=0;
            @(negedge clk)
            $display("op1=%d, op2=%d, hi=%d, lo=%d, r=%d", op1, op2,hi ,lo,r);
            //assert(op1/op2 == (lo) ) else $fatal(1, "Product is wrong.");
            //assert(op1%op2 == (hi) ) else $fatal(1, "Product is wrong.");
        

        #5;

        op1 = 40;
        op2 = -4;
         opcode=0;
         func=27;
         reset=0;
            @(negedge clk)
            $display("op1=%d, op2=%d, hi=%d, lo=%d, r=%d", op1, op2,hi ,lo,r);
            assert(op1/op2 == lo ) else $fatal(1, "Product is wrong.");
            assert(op1%op2 == hi ) else $fatal(1, "Product is wrong.");
        
        #5;

        op1 = 32'hFFFFFFFF;
        op2 = 0;
         opcode=0;
         func=17;
         reset=0;
            @(negedge clk)
            $display("op1=%d, op2=%d, hi=%d, lo=%d, r=%d", op1, op2,hi ,lo,r);
            assert(op1 == hi ) else $fatal(1, "Product is wrong.");
            
        #5;

        op1 = 32'hFFFFFFFF;
        op2 = 0;
         opcode=0;
         func=19;
         reset=0;
            @(negedge clk)
            $display("op1=%d, op2=%d, hi=%d, lo=%d, r=%d", op1, op2,hi ,lo,r);
            assert(op1 == lo ) else $fatal(1, "Product is wrong.");
            

        #5;

        op1 = 32'hFFFFFFFF;
        op2 = 0;
         opcode=1;
         func=19;
         reset=0;
            @(negedge clk)
            $display("op1=%d, op2=%d, hi=%d, lo=%d, r=%d", op1, op2,hi ,lo,r);
            assert(op1 == lo ) else $fatal(1, "Product is wrong.");
            
        #5;

        op1 = 32'hFFFFFFFF;
        op2 = 0;
         opcode=1;
         func=18;
         reset=0;
            @(negedge clk)
            $display("op1=%d, op2=%d, hi=%d, lo=%d, r=%d", op1, op2,hi ,lo,r);
            assert(op1 == lo ) else $fatal(1, "Product is wrong.");
            
                


        $finish;
    end

MUL_DIV_Block dut(
        .clk(clk),
        .op1(op1), .op2(op2), .hi(hi), .lo(lo), .hilo(r), .reset(reset), .opcode(opcode), .func(func)
    );
endmodule