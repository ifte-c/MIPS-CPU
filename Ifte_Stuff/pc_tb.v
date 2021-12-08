module pc_tb();

    logic clk;
    logic reset;
    logic waitrequest;
    logic[5:0] opcode;
    logic[5:0] funct;
    logic[4:0] rt;
    logic[4:0] sa;
    logic[4:0] rd;
    logic[31:0] rs_data; //received from register
    logic[15:0] offset;
    logic[25:0] target;
    logic[3:0] control; // rs==rt | rs > 0 | rs == 0 | rs < 0
    logic[31:0] pc; //10111111110000000000000000000000
    logic[31:0] regstore;

    initial begin
        $dumpfile("pc_tb.vcd");
        $dumpvars(0, pc_tb);

        clk = 0;
        opcode = 6'b000010;
        target = 26'b01010101010111111111010101;
        reset = 0;
        repeat(1000) begin
            #10;
            clk = !clk;
            #10;
            clk = !clk;
        end
    end

    initial begin
        #5;
        $display("Initial PC value: %b", pc);

        #10;
        $display("PC value: %b", pc);
        opcode = 0;
        sa = 0;
        funct = 6'b100000;

        #10;
        #10;
        $display("PC value: %b", pc);

        #10;
        #10;
        $display("PC value: %b", pc);

        #10;
        #10;
        $display("PC value: %b", pc);

        #10;
        #10;
        $display("PC value: %b", pc);

        #10;
        #10;
        $display("PC value: %b", pc);

        #10;
        #10;
        $display("PC value: %b", pc);
    end

    mips_cpu_pc dut(
        .clk(clk),
        .reset(reset),
        .waitrequest(waitrequest),
        .opcode(opcode),
        .funct(funct),
        .rt(rt),
        .sa(sa),
        .rd(rd),
        .rs_data(rs_data),
        .offset(offset),
        .target(target),
        .control(control),
        .pc(pc),
        .regstore(regstore)
    );

endmodule