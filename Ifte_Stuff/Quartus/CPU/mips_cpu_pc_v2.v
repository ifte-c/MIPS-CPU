module mips_cpu_pc(
    input logic clk,
    input logic reset,
    input logic[5:0] opcode,
    input logic[5:0] funct,
    input logic[4:0] rt,
    input logic[4:0] sa,
    input logic[4:0] rd,
    input logic[31:0] rs_data, //received from register
    input logic[15:0] offset,
    input logic[25:0] target,
    input logic[3:0] control, // rs==rt | rs > 0 | rs == 0 | rs < 0
    input logic[1:0] state,
    input logic waitrequest,
    input logic active,
    output logic[31:0] pc, //32'hBFC00000,
    output logic[31:0] regstore
);

    logic[31:0] dest;
    logic delayflag = 0;
    logic[31:0] pc_inc;

    assign pc_inc = pc + 4;
    assign regstore= pc + 8;
    
    always_ff @(posedge clk) begin
        if (reset == 1) begin
            pc <= 32'hBFC00000;
            dest <= 0;
            delayflag <= 0;
            
        end 
        else if(waitrequest == 0 && active == 1)begin
            if ((opcode == 6'b000010) && (state==1)) begin                                                     //j
                dest <= { 4'b0000, target, 2'b00 } + { pc_inc[31:28], 28'b0000000000000000000000000000 };
                pc <= pc + 4;
                delayflag <= 1;
                
            end 
            else if ((opcode == 6'b000011)&&(state==1)) begin                                            //jal
                //regstore <= pc + 8; //goes to r31
                dest <= { 4'b0000, target, 2'b00 } + { pc_inc[31:28], 28'b0000000000000000000000000000 };
                pc <= pc + 4;
                delayflag <= 1;
                
            end 
            else if (opcode == 0 && funct == 6'b001001 && rt == 0 && sa == 0 && state == 1) begin     //jalr
                //regstore <= pc + 8; //goes to rd
                dest <= rs_data;
                pc <= pc + 4;
                delayflag <= 1;
                
            end 
            else if (
            opcode == 0 && funct == 6'b001000 && rt == 0 && rd == 0 && sa == 0  && state == 1          //jr
            ) begin
                dest <= rs_data;
                pc <= pc + 4;
                delayflag <= 1;
                
            end 
            else if (
            (opcode == 6'b000100 && control[3] == 1 ||                                       //beq
            opcode == 6'b000101 && control[3] != 1 ||                                       //bne
            opcode == 6'b000111 && rt == 5'b00000 && control[2] == 1 ||                     //bgtz
            opcode == 6'b000001 && rt == 5'b00000 && control[0] == 1 ||                     //bltz
            opcode == 6'b000001 && rt == 5'b00001 && (control[1] == 1 || control[2] == 1) ||//bgez
            opcode == 6'b000110 && rt == 5'b00000 && (control[1] == 1 || control[0] == 1)) && state == 1  //blez                                 
            ) begin
                dest <= pc + 4 + { {14{ offset[15] }}, offset, 2'b00 };
                pc <= pc + 4;
                delayflag <= 1;
                
            end 
            else if (
            (opcode == 6'b000001 && rt == 5'b10001 && (control[1] == 1 || control[2] == 1) ||//bgezal
            opcode == 6'b000001 && rt == 5'b10000 && control[0] == 1 ) && state == 1//bltzal                                                
            ) begin
                //regstore <= pc + 8; //goes to r31
                dest <= pc + 4 + { {14{ offset[15] }}, offset, 2'b00 };
                pc <= pc + 4;
                delayflag <= 1;
            end 
            else begin
                if (delayflag == 1 && ((state == 1 && opcode[5:3] != 4) || state == 2) 
                ) begin
                    pc <= dest;
                    delayflag <= 0;
                end 
                else if (((state == 1 && opcode[5:3] != 4) || state == 2)) begin
                    pc <= pc + 4;
                end
            end
        end
    end

endmodule
