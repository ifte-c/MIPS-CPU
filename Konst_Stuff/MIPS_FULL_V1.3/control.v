module control(
    input logic [5:0] opcode,
    output logic RegDst,
    output logic RegWrite
);

always_comb begin
    if (opcode == 0) begin
        RegDst = 1;
        RegWrite = 1;
    end
    //whenever the opcode = 0, it's R-type instruction
    //Thus RegDst and RegWrite enables are active high, 1
    else if(opcode > 3) begin
        RegDst = 0;
        RegWrite = 1;
    end
    //whenever the opcode is greater than 3, it's I-type
    //Thus only RegWrite enable is active high, 1
end
    
endmodule