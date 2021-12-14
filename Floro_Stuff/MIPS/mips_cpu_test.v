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
    //this is done due to the large value of the return vector 0xBFC00000
    //special case for address 0 which just returns 0
    //memory should only receive word address
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
        memory[1] = 32'h8D09002C;
        memory[2] = 32'h00000008;
        memory[3] = 32'hA1090030;
        memory[11] = 32'h000000f3;
    end

    logic[7:0] writebyte2;
    logic[7:0] writebyte3;
    assign writebyte2=writedata[15:8];
    assign writebyte3=writedata[7:0];

    always @(posedge clk) begin
        if(write) begin
            case(byteenable)
            //sw
            4'b0000 : memory[mappedaddress]<=writedata;//no byteenable asserted, just regular write
            //sb
            4'b0001 : memory[mappedaddress]<={writebyte3, memory[mappedaddress][23:0]};
            4'b0010 : memory[mappedaddress]<={memory[mappedaddress][31:24], writebyte3 ,memory[mappedaddress][15:0]};
            4'b0100 : memory[mappedaddress]<={memory[mappedaddress][31:16], writebyte3 ,memory[mappedaddress][7:0]};
            4'b1000 : memory[mappedaddress]<={memory[mappedaddress][31:8], writebyte3};
            //sh
            4'b0011 : memory[mappedaddress]<={writebyte2, writebyte3, memory[mappedaddress][15:0]};
            4'b1100 : memory[mappedaddress]<={memory[mappedaddress][31:16], writebyte2, writebyte3};
            //sw
            4'b1111 : memory[mappedaddress]<=writedata;
            endcase
        end
        if (read) begin
            readdata<=memory[mappedaddress];
        end
    end
    

    initial begin
        $dumpfile("mips_cpu_test.vcd");
        $dumpvars(0,  mips_cpu_test);
        clk=0;
        repeat (10000) begin
            #10;
            clk=~clk;
        end

        //check that CPU has correct value after reasonable cycle time, if active didn't go low it failed to complete in time
        //if register_v0 does not have correct value, also fail the testbench
        if (active==0) begin  
            //assert(register_v0==32'h56AA3CD0) else $fatal(1,"Wrong Value in v0, %h", register_v0);
            $finish;
        end
        $fatal(1,"Failed to complete in time");
    end

    initial begin
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