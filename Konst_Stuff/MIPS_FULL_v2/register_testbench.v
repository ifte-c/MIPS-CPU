module register_testbench(

);

    logic clk;
    logic RegWrite;
    logic RegDst;
    logic [5:0] opcode;
    logic [4:0] Write_register;
    logic [31:0] Write_data;
    logic [4:0] Read_register_1;
    logic [31:0] Read_data_1;
    logic [4:0] Read_register_2;
    logic [31:0] Read_data_2;

    logic[4:0] Read_register_3;

    control control(
        .opcode(opcode),
        .RegDst(RegDst),
        .RegWrite(RegWrite)
    );

    Reg_file Reg_file(
        .clk(clk),
        .RegWrite(RegWrite),
        .Write_register(Write_register),
        .Write_data(Write_data),
        .Read_register_1(Read_register_1),
        .Read_data_1(Read_data_1),
        .Read_register_2(Read_register_2),
        .Read_data_2(Read_data_2)
    );

    initial begin
        clk = 0;
        #1 clk = 1;
        #1 clk = 0;

        opcode = 6'b000000;
        
        Write_data = 32'h00000007;
        Read_register_1 = 5'b00111;
        Read_register_2 = 5'b00011;
        Read_register_3 = 5'b00001;

        if (RegDst) begin
            Write_register = Read_register_3;
        end
        
        else begin
            Write_register = Read_register_2;
        end 

        #1 clk = 1;

        $display("%d", RegDst, RegWrite, Write_register, Read_data_2, Write_data);
    end
    
endmodule