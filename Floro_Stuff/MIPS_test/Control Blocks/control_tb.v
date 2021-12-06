module control_tb();
    logic[5:0] op;
    logic[5:0] func;
    logic[4:0] rt;
    logic clk;
    logic reset;
    logic mem_write;
    logic mem_read;
    logic[1:0] reg_data_sel;
    logic[1:0] reg_dest;
    logic reg_write;
    logic IR_write;
    logic ALU_srcA;
    logic[1:0] ALU_srcB;
    logic[5:0] ALUop;
    logic[1:0] PC_src;
    logic PC_write;
    logic PC_write_cond;
    logic lo_sel;
    logic hi_sel;
    logic lo_en;
    logic hi_en;
    logic IoD;
    logic extend;

    initial begin
        $dumpfile("control_tb.vcd");
        $dumpvars(0, control_tb);
        clk=0;
        repeat (20) begin
            #10;
            clk=~clk;
        end
    end

    initial begin
        reset = 1;
        #15 reset=0;
        op=6'b000001;
        //func= 6'b001000;
        rt=5'b10001;
        #70 op=6'b100000;
    end

    control dut (op, func, rt, clk, reset, mem_write, mem_read, reg_data_sel,
        reg_dest, reg_write, IR_write, ALU_srcA, ALU_srcB, ALUop, PC_src, PC_write,
        PC_write_cond, lo_sel, hi_sel, lo_en, hi_en, IoD, extend
    );
endmodule