module shifter_tb();

    logic[5:0] opcode;
    logic[5:0] funct;
    logic[4:0] shamt;
    logic[31:0] op1;
    logic[31:0] op2;

    logic[31:0] shift_out;

    assign op2 = 32'hf0f0f0f0;
    assign opcode = 32'h00000000;

    assign op1 = 0;

    initial begin
        funct = 0;
        shamt = 1;
        while (shamt < 5) begin
            #5;
            $display("%b", shift_out);
            shamt = shamt + 1;
        end
        shamt = 1;

        funct = 6'b000100;
        while (shamt < 5) begin
            #5;
            $display("%b", shift_out);
            shamt = shamt + 1;
        end
        shamt = 1;

        funct = 6'b000011;
        while (shamt < 5) begin
            #5;
            $display("%b", shift_out);
            shamt = shamt + 1;
        end
        shamt = 1;

        funct = 6'b000111;
        while (shamt < 5) begin
            #5;
            $display("%b", shift_out);
            shamt = shamt + 1;
        end
        shamt = 1;

        funct = 6'b000010;
        while (shamt < 5) begin
            #5;
            $display("%b", shift_out);
            shamt = shamt + 1;
        end
        shamt = 1;

        funct = 6'b000110;
        while (shamt < 5) begin
            #5;
            $display("%b", shift_out);
            shamt = shamt + 1;
        end

    end

    shifter dut(.opcode(opcode), .shamt(shamt), .funct(funct), .op1(op1), .op2(op2), .shift_out(shift_out));

endmodule
