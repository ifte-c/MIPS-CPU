module mips_cpu_pc(
    input logic clk,
    input logic reset,
    input logic[5:0] opcode,
    input logic[5:0] funct,
    input logic[4:0] rt,
    input logic[4:0] sa,
    input logic[31:0] rs_data, //received from register
    input logic[15:0] offset,
    input logic[25:0] target,
    input logic[3:0] control, // rs==rt | rs > 0 | rs == 0 | rs < 0
    output logic[31:0] pc = 32'hBFC00000,
    output logic[31:0] regstore
);

    logic[31:0] pc = 32'hBFC00000;
    logic[31:0] balval;
    logic delflag = 0;

    always_ff @(posedge clk) begin
        if (opcode == 000010) begin                                                     //j
            balval <= { 4'b0000, target, 2'b00 } + { pc_inc[31:28], 28'b0000000000000000000000000000 };
            pc <= pc + 4;
            delflag <= 1;
        end else if (opcode == 000011) begin                                            //jal
            regstore <= pc + 8; //goes to r31
            balval <= { 4'b0000, target, 2'b00 } + { pc_inc[31:28], 28'b0000000000000000000000000000 };
            pc <= pc + 4;
            delflag <= 1;
        end else if (opcode == 0 && funct == 6'b001001 && rt == 0 && sa == 0) begin     //jalr
            regstore <= pc + 8; //goes to rd
            balval <= rs_data;
            pc <= pc + 4;
            delflag <= 1;
        end else if (
        opcode == 0 && funct == 6'b001000 && rt == 0 && rd == 0 && sa == 0              //jr
        ) begin
            balval <= rs_data;
            pc <= pc + 4;
            delflag <= 1;
        end else if (
        opcode == 6'b000100 && control[3] == 1 ||                                       //beq
        opcode == 6'b000101 && control[3] != 1 ||                                       //bne
        opcode == 6'b000111 && rt == 5'b00000 && control[2] == 1 ||                     //bgtz
        opcode == 6'b000001 && rt == 5'b00000 && control[0] == 1 ||                     //bltz
        opcode == 6'b000000 && rt == 5'b00001 && (control[1] == 1 || control[2] == 1) ||//bgez
        opcode == 6'b000000 && rt == 5'b00000 && (control[1] == 1 || control[0] == 1)   //blez
        ) begin
            balval <= pc + 4 + {14{offset[15]}, offset, 2'b00};
            pc <= pc + 4;
            delflag <= 1;
        end else if (
        opcode == 6'b000001 && rt == 5'b10001 && (control[1] == 1 || control[2] == 1) ||//bgezal
        opcode == 6'b000000 && rt == 5'b00001 && control[0] == 1                        //bltzal
        ) begin
            regstore <= pc + 8; //goes to r31
            balval <= pc + 4 + {14{offset[15]}, offset, 2'b00};
            pc <= pc + 4;
            delflag <= 1;
        end else begin
            if (delflag == 1) begin
                pc <= balval;
                delflag <= 0;
            end else begin
                pc <= pc + 4;
            end
        end
    end

endmodule
