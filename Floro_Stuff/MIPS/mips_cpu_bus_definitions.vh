`ifndef mips_cpu_bus_definitions_vh
`define mips_cpu_bus_definitions_vh

/* Instruction formats:
R-type: opcode (6) rs (5) rt (5) rd (5) shift (5) function (5)
I-tyoe: opcode (6) rs (5) rt (5) imm (16)
J-type: opcode (6) mem (26)
Delay slots:
Jump and branch instructions all have a "delay slot", meaning that the instruction
after the branch or jump is executed before the branch or jump is executed. The
processor should therefore execute the branch instruction and the delay slot instruction
as an indivisible unit. You can think of jump / branch instructions as taking 2 instructions
to complete; first the conditionals are calculated and stored, then the next instruction is
executed (pc <= pc + 4) and the pc value is updated based on the jump or branch instruction.
*/

typedef enum logic[5:0] {
    OPCODE_R = 6'b00000, // Register type instructions
    OPCODE_ADDIU = 6'b001001, //rt = rs + imm
    OPCODE_ANDI = 6'b001100, //rt = rs & imm (note: & represents bitwise and)
    OPCODE_BEQ = 6'b000100, //if(rs == rt) then pc <= pc + imm>>2
    OPCODE_REGIMM = 6'b00001,  //Behaviour depends on the rt field (see below)
    OPCODE_BGTZ = 6'b000111, //if(rs > 0) then pc <= pc + imm>>2 (rt == 00000)
    OPCODE_BLEZ = 6'b000110, //if(rs <= 0) then pc <= pc + imm>>2 (rt == 00000)
    OPCODE_BNE = 6'b000101, //if(rs != rt) then pc <= pc + imm>>2
    OPCODE_J = 6'b000010, //jumps to specified target instr_index.
    OPCODE_JAL = 6'b000011, //stores next instruction address in GPR (during procedure call,) executes subroutine.
    OPCODE_LB = 6'b100000, //load a byte from memory to rt as a signed value
    OPCODE_LBU = 6'b100100, //same thing but as an unsigned value
    OPCODE_LH = 6'b100001, //load a halfword as a signed value (to rt)
    OPCODE_LHU = 6'b100101, // $rt = mem[rs+imm] ; dest=rt, source=base
    OPCODE_LUI = 6'b001111, // $rt = imm||0000000000000000 (rs == 00000)
    OPCODE_LW = 6'b100011, // $rt = mem[rs+imm] (note this is signed fullword)
    OPCODE_LWL = 6'b100010, // $rt = rt MERGE mem[base+imm] loads MSB (replaces 16 MSB of rt with the 16MSB of mem[base+imm])
    OPCODE_LWR = 6'b100110, // $rt = rt MERGE mem[base+imm] loads LSB (same as above but LSB)
    OPCODE_ORI = 6'b001101, // does a bitwise logical or with constant rt<--rs | immediate
    OPCODE_SB = 6'b101000,//stores a byte to memory memory(base+offset) = rt?
    OPCODE_SH = 6'b101001, //store a halfword to memory memory(base+offset)=rt?
    OPCODE_SLTI = 6'b001010, // to record the result of a less than comparison with a const rt=(rs<immediate)
    OPCODE_SLTIU = 6'b001011, //to record the result of an unsigned less than comparison with a conse rt=(rs<immediate)
    OPCODE_SW = 6'b101011, // memory[base+offset] := $rt. Stores register rt in memory with an offset.
    OPCODE_XORI = 6'b001110 // $rt := $rs XORI c. Logical XOR between $rs and constant c.
} opcode_t;

typedef enum logic[5:0] {
    FUNCTION_ADDU = 6'b100001, //rd = rs + rt (shift == 0)
    FUNCTION_AND = 6'b100100, //rd = rs & rt (shift == 0)
    FUNCTION_DIV=6'b011010, //divides two 32bit signed integers, rs, rt. quotient to LO, Remainder to HI
    FUNCTION_DIVU=6'b011011, //same thing, for unsigned integers.
    FUNCTION_JALR = 6'b001001, //Jumps to RS, return adress stored in RD.
    FUNCTION_JR = 6'b001000, //branch to an Instruction address in rs, presumably after FUNCTION_JALR
    FUNCTION_MTHI = 6'b010001, // $HI = $rs (rt, rd, shift == 0)
    FUNCTION_MTLO = 6'b010011, // $LO = $rs (rt, rd, shift == 0)
    FUNCTION_MFHI = 6'b010000, // $rd = $HI
    FUNCTION_MFLO = 6'b010010, // $rd = $LO
    FUNCTION_MULT = 6'b011000, // $(LO,HI) = $rs * $rt (rd, shift == 0)
    FUNCTION_MULTU = 6'b011001, // $(LO,HI) = $rs * $rt (rd, shift == 0)
    FUNCTION_OR = 6'b100101, // does bitwise logical OR rd<--rs OR rt (shift == 0)
    FUNCTION_SLL = 6'b000000, // to left shift a word by a fixed number of bits rd=rt<<sa (shift amt) (rs == 0)
    FUNCTION_SLLV = 6'b000100, // to left shift by the 5 LSB of rs rd=rt<<rs[4:0] (shift == 0)
    FUNCTION_SLT = 6'b101010, // to record the result of a less than comparison rd=(rs<rt) (shift == 0)
    FUNCTION_SLTU = 6'b101011, // $rd := $rs < $rt. Unsigned less-than comparison.
    FUNCTION_SRA = 6'b000011, // $rd := rt >> shift. Arithmetic shift right by shift bits. (rs == 00000)
    FUNCTION_SRAV = 6'b000111, // $rd := $rt >> $rs[4:0]. Variable Arithmetic shift right, i.e. by a register variable. (shift == 00000)
    FUNCTION_SRL = 6'b000010, // $rd := $rt >> shift. Logical shift right by constant shift bits. (rs == 00000)
    FUNCTION_SRLV = 6'b000110, // $rd := $rt >> $rs[4:0]. Variable logical shift right, i.e. by a register variable (shift == 00000)
    FUNCTION_SUBU = 6'b100011, // $rd := $rs - $rt. Subtract 2 registers. (shift == 0)
    FUNCTION_XOR = 6'b100110 // $rd := $rs XOR $rt. Logical XOR between $rs and $rt.
} function_t;

//This logic is used for the rt field of instructions with the REGIMM opcode
typedef enum logic[4:0] {
    BGEZ = 5'b00001, //if(rs >= 0) then pc <= pc + imm>>2
    BGEZAL = 5'b10001, //$ra <= pc + 8, if(rs >= 0) then pc <= pc + imm>>2 (places return address in $ra)
    BLTZ = 5'b00000, //if(rs < 0) then pc <= pc + imm>>2
    BLTZAL = 5'b10000 //$ra <= pc + 8, if(rs < 0) then pc <= pc + imm>>2
} REGIMM_t;

//Internal states in CPU state machine
typedef enum logic[1:0] {
    FETCH = 2'b00,
    EXEC = 2'b01,
    WRITE_BACK = 2'b10,
    HALTED = 2'b11
} state_t;

`endif
