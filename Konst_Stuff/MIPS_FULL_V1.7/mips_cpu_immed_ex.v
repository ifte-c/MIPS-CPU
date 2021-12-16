module immed_ex(
    input logic[5:0] opcode,
    input logic[15:0] immed,
    output logic[31:0] immed_ex
);

    logic msb;
    assign msb = immed[15];

    always_comb begin
        if (opcode == 6'b001100 || opcode == 6'b001101 || opcode == 6'b001110) begin
            immed_ex = {16'h0000, immed};
        end
        else begin
            case(msb)
            0 : immed_ex = {16'h0000, immed};
            1 : immed_ex = {16'hFFFF, immed};
            endcase
        end
    end

endmodule
    