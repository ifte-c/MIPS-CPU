module split(
    input logic[31:0] instr,
    output logic[5:0] op,
    output logic[4:0] rs,
    output logic[4:0] rd,
    output logic[4:0] rt,
    output logic[4:0] shift,
    output logic[5:0] func,
    output logic[15:0] imm,
    output logic[25:0] target
);

    assign op=instr[31:26];
    assign rs=instr[25:21];
    assign rd=instr[20:16];
    assign rt=instr[15:11];
    assign shift=instr[10:6];
    assign func=instr[5:0];
    assign imm=instr[15:0];
    assign target=instr[25:0];

endmodule
