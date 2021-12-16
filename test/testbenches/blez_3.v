module blez_3();

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
        memory[2] = 32'h19200004;
        memory[3] = 32'h00000000;
        memory[4] = 32'h012A5821;
        memory[5] = 32'h00000008;
        memory[6] = 32'h00000000;
        memory[8] = 32'h00000008;
        memory[9] = 32'h3C02FFFF;
        memory[11] = 32'd1;
        memory[12] = 32'd15;
    end

    
    always @(posedge clk) begin
        if(write) begin
            case(byteenable)
            //sw
            4'b0000 : memory[mappedaddress]<=writedata;//no byteenable asserted, just regular write
            //sb
            4'b0001 : memory[mappedaddress]<={writedata[7:0], memory[mappedaddress][23:0]};
            4'b0010 : memory[mappedaddress]<={memory[mappedaddress][31:24], writedata[7:0] ,memory[mappedaddress][15:0]};
            4'b0100 : memory[mappedaddress]<={memory[mappedaddress][31:16], writedata[7:0] ,memory[mappedaddress][7:0]};
            4'b1000 : memory[mappedaddress]<={memory[mappedaddress][31:8], writedata[7:0]};
            //sh
            4'b0011 : memory[mappedaddress]<={writedata[15:0], memory[mappedaddress][15:0]};
            4'b1100 : memory[mappedaddress]<={memory[mappedaddress][31:16], writedata[15:0]};
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
            //$display("%h",memory[12]);
            assert(register_v0==32'h000000000) else $fatal(1,"Wrong Value in v0, %h", register_v0);
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