module mips_cpu_test();

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
    
    
    //maps CPU given byte address to single increment word address
    logic[4:0] mappedaddress;
    always_comb begin
        if(address==0) begin
            readdata=0;
        end
        else begin
            mappedaddress=(address-32'hBFC00000)/4;
        end
    end
    
    
    //memory
    reg [31:0] memory [20:0];
    initial begin
        integer i;
        for (i=0; i<21; i++) begin
            memory[i]=0;
        end

        memory[0] = 32'h3C08BFC0;
        memory[1] = 32'h00000008;
        memory[2] = 32'h8D02002C;
        memory[11] = 32'h56aa3cd0;
    end

    always @(posedge clk) begin
        if(write) begin
            memory[mappedaddress]<=writedata;
        end
        else if (read) begin
            readdata<=memory[mappedaddress];
        end
    end
    

    initial begin
        $dumpfile("mips_cpu_test.vcd");
        $dumpvars(0,  mips_cpu_test);
        clk=1;
        repeat (10000) begin
            #10;
            clk=~clk;
        end

        if (active==0) begin  
            assert(register_v0==32'h56AA3CD0) else $fatal(1,"Wrong Value in v0, %h", register_v0);
            $finish;
        end
        
        $fatal(1,"Failed to complete in time");
    end

    initial begin
        #20
        reset=1;
        waitrequest=0;

        #20
        reset=0;

        #10
        assert(active==1) else $fatal(1, "Active did not go high");
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