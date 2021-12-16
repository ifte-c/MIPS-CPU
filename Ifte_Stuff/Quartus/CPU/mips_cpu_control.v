module mips_cpu_control(
    input logic[5:0] op,
    input logic[5:0] func,
    input logic[4:0] rt,
    input logic clk,
    input logic reset,
    input logic waitrequest,
    input logic[31:0] address,
    output logic mem_write,
    output logic mem_read,
    output logic[1:0] reg_data_sel,
    output logic[1:0] reg_dest,
    output logic reg_write,
    output logic IR_write,
    output logic IR_sel,
    output logic ALU_srcA,
    output logic[1:0] ALU_srcB,
    output logic[4:0] ALUop,
    output logic[1:0] PC_src,
    output logic PC_write,
    output logic PC_write_cond,
    output logic lo_sel,
    output logic hi_sel,
    output logic lo_en,
    output logic hi_en,
    output logic IoD,
    output logic extend,
    output logic[1:0] instr_type,
    output logic active
);

    typedef enum logic[2:0]{
        IF = 3'd0,
        ID = 3'd1,
        EX = 3'd2,
        MEM = 3'd3,
        STP = 3'd4
     } state_t;

    state_t state;


    
  
    always @(*) begin
        if((op==6'b100000)||(op==6'b100100)||(op==6'b100001)||(op==6'b100101)||(op==6'b100011)||(op==6'b100010)||(op==6'b100110)) begin
            instr_type=2;//load
        end
        else if(((op==6'b000001) && ((rt==5'b10001)||(rt==5'b10000))) || ((op==0) && (func==6'b001001)) || (op==000011)) begin
            instr_type=3;//link
        end
        else if((op==6'b101000)||(op==6'b101001)||(op==6'b101011)) begin
            instr_type=1;//store
        end
        else begin
            instr_type=0;//other
        end
    end


    initial begin
        state=IF;
        active=0;
    end

    always_ff @(posedge clk) begin//state machine
        if(reset==1) begin
            state<=IF;
            active<=1;
        end
        else if(address==0) begin
            state<=STP;
            active<=0;
        end
        else begin
            if(state==IF) begin//Fetch cycle
                case(waitrequest)
                0 : state<=ID;
                1 : state<=IF;
                endcase
            end

            else if(state==ID) begin//Instruction Decode cycke
                state<=EX;
            end

            else if(state==EX && instr_type<2) begin//Execute cycle, return to Fetch cycle
                if(waitrequest==1 && (instr_type==1)) begin
                    state<=EX;
                end
                else begin
                    state<=IF;
                end
            end

            else if(state==EX && instr_type>=2) begin//Execute cycle, continue to access memory cycle
                if(waitrequest==1 && (instr_type==2)) begin
                    state<=EX;
                end
                else begin
                    state<=MEM;
                end
            end

            else if(state==MEM) begin//Write/Read memorcy cycle, return to Fetch cycle
                    state<=IF;
            end
        end
    end

    always @(*) begin
        if(state==STP) begin//halt behaviour
            mem_write=0;
            mem_read=0;
            reg_data_sel=0;
            reg_dest=0;
            reg_write=0;
            IR_write=0;
            IR_sel=0;
            ALU_srcA=0;
            ALU_srcB=0;
            ALUop=0;
            PC_src=0;
            PC_write=0;
            PC_write_cond=0;
            lo_sel=0;
            hi_sel=0;
            lo_en=0;
            hi_en=0;
            IoD=0;
            extend=0;
        end
        else if(state==IF) begin//Fetch cycle
            mem_write=0;
            mem_read=1;
            reg_data_sel=0;
            reg_dest=0;
            reg_write=0;
            IR_write=0;
            IR_sel=0;
            ALU_srcA=0;
            ALU_srcB=2'b01;
            ALUop=0;
            PC_src=2'b01;
            PC_write_cond=0;
            lo_sel=0;
            hi_sel=0;
            lo_en=0;
            hi_en=0;
            IoD=0;
            extend=0;
            case(waitrequest)
                0 : PC_write=1;
                1 : PC_write=0;
            endcase
        end

        else if(state==ID) begin//Instruction Decode cycke
            mem_write=0;
            mem_read=0;
            reg_data_sel=0;
            reg_dest=0;
            reg_write=0;
            IR_write=1;
            IR_sel=1;
            ALU_srcA=0;
            ALU_srcB=2'b11;
            ALUop=0;
            PC_src=2'b01;
            PC_write=0;
            PC_write_cond=0;
            lo_sel=0;
            hi_sel=0;
            lo_en=0;
            hi_en=0;
            IoD=0;
            extend=0;
        end

        else if(state==EX) begin//Execute cycle non memory type
            mem_write=0;//most instructions do not involve memory operations
            mem_read=0;
            reg_data_sel=0;
            reg_dest=0;//most non R-Type will have rt as a destination
            reg_write=1;//most instructions write back to registers
            IR_write=0;//IR registter not changed during Exec cycle
            IR_sel=0;
            IoD=0;// only change for memory loads
            PC_src=0;//program counter used only by jump/branch in Exec
            PC_write=0;
            PC_write_cond=0;
            lo_sel=0;//only six operations use the LO/HI registers
            hi_sel=0;
            lo_en=0;
            hi_en=0;
            ALU_srcA=1;//only jump uses PC+4 value during Exec 
            extend=0;//most instructions require sign extension
            case(op)
            0 : begin//R-Type instructions

                ALU_srcB=0;//R-Type will generally use rt as a source
                reg_dest=1;//R-Type will generally use rd as a destination

                case(func)
                6'b100001 : ALUop=0; //ADDU
                6'b100100 : ALUop=6; //AND
                6'b011010 : begin   //DIV
                    ALUop=4;
                    lo_en=1;
                    hi_en=1;
                    lo_sel=0;
                    hi_sel=0;
                    reg_write=0;
                end
                6'b011011 : begin   //DIVU
                    ALUop=5;
                    lo_en=1;
                    hi_en=1;
                    lo_sel=0;
                    hi_sel=0;
                    reg_write=0;
                end
                6'b001001 : begin //JALR
                    ALUop=24;
                    ALU_srcA=0;
                    ALU_srcB=1;
                    PC_write=1;
                    PC_write_cond=1; 
                    PC_src=2'b11;
                    reg_write=0;
                end
                6'b001000 : begin//JR
                    ALUop=24;
                    ALU_srcA=0;
                    ALU_srcB=1;
                    PC_write=1;
                    PC_write_cond=1; 
                    PC_src=2'b11;
                    reg_write=0;
                end
                6'b010001 : begin //MTHI
                    ALUop=23;
                    hi_en=1;
                    hi_sel=1;
                    reg_write=0;
                end
                6'b010011 : begin //MTLO
                    ALUop=23;
                    lo_en=1;
                    lo_sel=1;
                    reg_write=0;
                end
                6'b010000 : begin //MFHI
                    ALUop=23;
                    reg_write=1;
                    reg_data_sel=3;
                end
                6'b010010 : begin //MFLO
                    ALUop=23;
                    reg_write=1;
                    reg_data_sel=2;
                end
                6'b011000 : begin   //MULT
                    ALUop=2;
                    lo_en=1;
                    hi_en=1;
                    lo_sel=0;
                    hi_sel=0;
                    reg_write=0;
                end
                6'b011001 : begin   //MULTU
                    ALUop=3;
                    lo_en=1;
                    hi_en=1;
                    lo_sel=0;
                    hi_sel=0;
                    reg_write=0;
                end
                6'b100101 : ALUop=7;//OR
                6'b000000 : ALUop=9;//SLL
                6'b000100 : ALUop=10;//SLLV
                6'b101010 : ALUop=20;//SLT
                6'b101011 : ALUop=21;//SLTU
                6'b000011 : ALUop=13;//SRA
                6'b000111 : ALUop=14;//SRAV
                6'b000010 : ALUop=11;//SRL
                6'b000110 : ALUop=12;//SRLV
                6'b100011 : ALUop=1;//SUBU
                6'b100110 : ALUop=8;//XOR
                endcase
                end
            6'b001001 : begin//ADDIU
                ALUop=0;
                ALU_srcB=2;
            end
            6'b001100 : begin//ANDI
                ALUop=6;
                ALU_srcB=2;
                extend=1;
            end
            6'b000100 : begin//BEQ
                ALUop=15;
                ALU_srcB=0;
                PC_write=1;
                PC_write_cond=1;
                reg_write=0;
            end
            6'b000001 : begin
                case(rt)
                5'b00001 : begin//BGEZ
                    ALUop=16;
                    ALU_srcB=0;
                    PC_write=1;
                    PC_write_cond=1;
                    reg_write=0;
                end
                5'b10001 : begin//BGEZAL
                    ALUop=16;
                    ALU_srcB=0;
                    PC_write=1;
                    PC_write_cond=1;
                    reg_write=0;
                end
                5'b10001 : begin//BGEZAL
                    ALUop=16;
                    ALU_srcB=0;
                    PC_write=1;
                    PC_write_cond=1;
                    reg_write=0;
                end
                5'b00000 : begin//BLTZ
                    ALUop=19;
                    ALU_srcB=0;
                    PC_write=1;
                    PC_write_cond=1;
                    reg_write=0;
                end
                5'b10000 : begin//BLTZAL
                    ALUop=19;
                    ALU_srcB=0;
                    PC_write=1;
                    PC_write_cond=1;
                    reg_write=0;
                end
                endcase
            end
            6'b000111 : begin//BGTZ
                ALUop=17;
                ALU_srcB=0;
                PC_write=1;
                PC_write_cond=1;
                reg_write=0;
            end
            6'b000110 : begin//BLEZ
                ALUop=18;
                ALU_srcB=0;
                PC_write=1;
                PC_write_cond=1;
                reg_write=0;
            end
            6'b000110 : begin//BNE
                ALUop=22;
                ALU_srcB=0;
                PC_write=1;
                PC_write_cond=1;
                reg_write=0;
            end
            6'b000010 : begin//J
                ALUop=24;
                ALU_srcB=0;
                PC_src=2;
                PC_write=1;
                PC_write_cond=1;
                reg_write=0;
            end
            6'b000011 : begin//JAL
                ALUop=24;
                ALU_srcB=0;
                PC_src=2;
                PC_write=1;
                PC_write_cond=1;
                reg_write=0;
            end
            6'b100000 : begin//LB
                ALUop=0;
                ALU_srcB=2;
                mem_read=1;
                IoD=1;
                reg_write=0;
            end
            6'b100000 : begin//LB
                ALUop=0;
                ALU_srcB=2;
                mem_read=1;
                IoD=1;
                reg_write=0;
            end
            6'b100100 : begin//LBU
                ALUop=0;
                ALU_srcB=2;
                mem_read=1;
                IoD=1;
                reg_write=0;
            end
            6'b100001 : begin//LH
                ALUop=0;
                ALU_srcB=2;
                mem_read=1;
                IoD=1;
                reg_write=0;
            end
            6'b100101 : begin//LHU
                ALUop=0;
                ALU_srcB=2;
                mem_read=1;
                IoD=1;
                reg_write=0;
            end
            6'b001111 : begin//LUI
                ALUop=25;
                ALU_srcB=2;
            end
            6'b100011 : begin//LW
                ALUop=0;
                ALU_srcB=2;
                mem_read=1;
                IoD=1;
                reg_write=0;
            end
            6'b100010 : begin//LWL
                ALUop=0;
                ALU_srcB=2;
                mem_read=1;
                IoD=1;
                reg_write=0;
            end
            6'b100110 : begin//LWR
                ALUop=0;
                ALU_srcB=2;
                mem_read=1;
                IoD=1;
                reg_write=0;
            end
            6'b001101 : begin//ORI
                ALUop=7;
                ALU_srcB=2;
                extend=1;
            end
            6'b101000 : begin//SB
                ALUop=0;
                ALU_srcB=2;
                mem_read=1;
                mem_write=1;
                IoD=1;
                reg_write=0;
            end
            6'b101001 : begin//SH
                ALUop=0;
                ALU_srcB=2;
                mem_read=1;
                mem_write=1;
                IoD=1;
                reg_write=0;
            end
            6'b001010 : begin//SLTI
                ALUop=20;
                ALU_srcB=2;
            end
            6'b001011 : begin//SLTIU
                ALUop=21;
                ALU_srcB=2;
            end
            6'b101011 : begin//SW
                ALUop=0;
                ALU_srcB=2;
                mem_read=1;
                mem_write=1;
                IoD=1;
                reg_write=0;
            end            
            endcase
        end

        else if(state==MEM) begin//Read/Link memorcy cycle
            if(instr_type==3)begin
                mem_write=0;
                mem_read=0;
                reg_data_sel=0;
                reg_dest=2;
                reg_write=1;
                IR_write=0;
                IR_sel=0;
                ALU_srcA=0;
                ALU_srcB=1;
                ALUop=0;
                PC_src=0;
                PC_write=0;
                PC_write_cond=0;
                lo_sel=0;
                hi_sel=0;
                lo_en=0;
                hi_en=0;
                IoD=0;
                extend=0;
            end
            else begin
                mem_write=0;
                mem_read=0;
                reg_data_sel=1;
                reg_dest=0;
                reg_write=1;
                IR_write=0;
                IR_sel=0;
                ALU_srcA=0;
                ALU_srcB=0;
                ALUop=0;
                PC_src=0;
                PC_write=0;
                PC_write_cond=0;
                lo_sel=0;
                hi_sel=0;
                lo_en=0;
                hi_en=0;
                IoD=0;
                extend=0;
            end
        end
    end

endmodule