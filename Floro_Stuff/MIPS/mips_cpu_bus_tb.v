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
        $dumpfile(" mips_cpu_bus_tb.vcd");
        $dumpvars(0,  mips_cpu_bus_tb);
        clk=0;
        repeat (15) begin
            #10;
            clk=~clk;
        end
    end

    initial begin
        reset=1;
        #20
        reset=0;
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