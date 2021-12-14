module mips_testbench();

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
        waitrequest = 0;
        readdata = 0;
        clk = 0;
        repeat(1000) begin
            #10;
            clk=!clk;
            #10;
            clk=!clk;
        end
    end

    initial begin
        reset = 1;
        #20;
        reset = 0;
        #20;

        #5;

        
    end

    ram #(RAM_INIT_FILE) mem(
        .clk(clk),
        .address(address),
        .write(write),
        .read(read),
        .waitrequest(waitrequest),
        .writedata(writedata),
        .byteenable(byteenable),
        .readdata(readdata)
    );

    mips_cpu_bus cpu(
        .clk(clk),
        .reset(reset),
        .active(active),
        .register_v0(register_v0),
        .address(address),
        .write(write),
        .read(read),
        .waitrequest(waitrequest),
        .writedata(writedata),
        .byteenable(byteenable),
        .readdata(readdata)
    );