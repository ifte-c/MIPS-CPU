module mips_mini_tb(

);


logic clk;
logic reset;
logic[31:0] address;
logic write;
logic read;
logic waitrequest;
logic[31:0] writedata;
logic[3:0] byteenable;
logic[31:0] readdata;
logic active;
logic[31:0] register_v0;


    initial begin
        
        $dumpfile("mips_mini_tb.vcd");
        $dumpvars(0, mips_mini_tb);
        clk = 0;

    reset=1;

    waitrequest=0;
        
    #2;
    clk=1; 
    #2
    reset=0;

    clk=0;

     readdata=32'b10001100001000100000000000000111;// rs=1, rt=3 offset=7
    #2;   
                                                   
    clk=1  ; //F                     
     waitrequest=1;
    #2;

     clk=0;
    
    #2;

    clk=1  ;     //E1                      
    
   #2;

   clk=0;
   waitrequest=0;
   readdata=69;
    #2;

    clk=1  ;     //E1                      
    
   #2;

   clk=0;

   #2;
    
    clk=1 ;          //E2                
    
    #2;
    
    
   clk=0;
   readdata=32'b00100100010000100000000000001111;   //addi ts=3 tr=4 imm=15

    #2;

    clk=1;         //F                   

    #2;
    waitrequest=1;
    clk=0;
    #2;
    clk=1;             //E1                 
     
     #2;
     clk=0;
     waitrequest=0;
     readdata=32'b00000100010100010000000000001111; //rs=2 offset=F branch
     #2;
     clk=1;           //F                  
     #2;
     clk=0;
     #2;                            
     clk=1;             //E1                
     #2;
     waitrequest = 1;
     clk=0;
     readdata=32'b00000000010000100000000000011000; 
     #2;
     clk=1 ;          //F                    
     #2;
     clk=0;
     #2;                            
     clk=1;             //F                  
     #2;
     clk=0;
     
     #2;
     clk=1 ;            //F                   
     #2;
     waitrequest = 0;
     clk=0;
     #2;                            
     clk=1;          //F                     
     #2;
     clk=0;
     #2;
     clk=1;           //E1 Branch
     #2;
     clk=0;
     readdata=32'b10101110101000100000000000001000;
     waitrequest=1;
     #2;         
     clk=1;         //F
     #2;
     clk=0;
     waitrequest=0;
     #2;
     clk=1  ;     //F
     #2;
     clk=0;
     waitrequest=1;
     #2;
     clk=1;   //E1
     #2;
     clk=0;
     #2;
     clk=1;     //E1
     #2;
     clk=0;
     waitrequest=0;
     #2;
     clk=1;     //E1
     #2;
     clk=0;
     readdata=32'b00000011111000101111100000100011;
     #2;
     clk=1  ;     //F
     #2;
     clk=0;
     waitrequest=0;
     #2;
     clk=1;   //E1
     #2;
     clk=0;
     readdata=32'b00000011111000000000000000001000; //jump to r31
     waitrequest=1;
     #2;
     clk=1;     //F
     #2;
     clk=0;
     waitrequest=0;
     #2;
     clk=1;      //F
     #2;
     clk=0;
     #2;
     clk=1;       //E1
     #2;
     clk=0;
     readdata=32'b00000000000000000001000000010010; //MFhi
     waitrequest=1;
     #2;
     clk=1;      //F
     #2;
     clk=0;
     waitrequest=0;
     #2;
     clk=1;     //F
     #2;
     clk=0;
     waitrequest=1;
     #2;
     clk=1;       //E1
      readdata=32'b00000000000000000001000000010000;
     #2;
     clk=0;
     waitrequest=0;
     #2;
     clk=1;     //F
     #2;
     clk=0;
     #2;
     clk=1;       //E1
     #2;
     clk=0;
     readdata=32'b00111110101000101010101010101010;
     #2;
     clk=1;    //F
     #2;
     clk=0;
     #2;
     clk=1;     //E1
     #2;
     clk=0;
     #2;




                            
    $finish;

    end

mips_cpu_bus dut(
    .clk(clk), .reset(reset), .active(active), .register_v0(register_v0),
    .address(address), .write(write), .read(read),
    .waitrequest(waitrequest), .writedata(writedata),
    .byteenable(byteenable), .readdata(readdata)
    );

endmodule

