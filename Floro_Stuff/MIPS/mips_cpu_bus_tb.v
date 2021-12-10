module mips_cpu_bus_tb();

    logic clk;
    logic reset;
    logic active;
    logic[31:0] register_v0;
    logic[31:0] address;
    logic write;
    logic read;
    logic waitrequest;
    logic[31:0] writedata;
    logic[3:0] byteenable;
    logic[31:0] readdata;

    
    initial begin
        $dumpfile("mips_cpu_bus_tb.vcd");
        $dumpvars(0,  mips_cpu_bus_tb);
        clk=0;
        repeat (50) begin
            #10;
            clk=~clk;
        end
    end

    initial begin
        reset=1;
        waitrequest=0;
        #20;//20
        reset=0;
        #10//30
        readdata=32'h3C03BFC0;
        #60;//90
        readdata=32'h8C690028;
        #20;//110
        readdata=32'hffff0000;
        #5;//125
        waitrequest=1;
        #20;//135
        waitrequest=0;
        #15;//150
        readdata=32'h000000C0;
        #20;//170
        readdata=32'h00000008;
        #60;
        readdata=32'h25220000;

               
    end


    mips_cpu_bus dut(
        clk,
        reset,
        active,
        register_v0,
        address,
        write,
        read,
        waitrequest,
        writedata,
        byteenable,
        readdata
    );




endmodule