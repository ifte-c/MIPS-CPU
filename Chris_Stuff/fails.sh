#!/bin/bash

#######################################
#correct script call from the main directory:
#./test/test_mips_cpu_bus.sh <CPU location> <OPTIONAL: specific instruction to test; otherwise all>
#eg
#./test/test_mips_cpu_bus.sh rtl addiu
#######################################

#many terminal outputs (e.g. from the compiler and executable) have been silenced as to not flood stdout
#turn the line below into a comment if you want to see all the stderr outputs while debugging
exec 2> /dev/null

#two command line arguments should be provided: the source directory for the CPU and instruction to be tested (in that order)
#if no instruction is specified, the default is to test all instructions
SOURCE_DIRECTORY="$1"
INSTRUCTION="${2-all}"

#relative paths from the main folder to where the testbench files are and where the executable files should be stored
#mkdir test/testbenches
mkdir test/executables

TESTBENCH_DIRECTORY="test/testbenches"
EXECUTABLE_DIRECTORY="test/executables"

VALID_INSTRUCTIONS=(
    #Priority instructions - should be tested first
    jr	    #Jump register
    addiu	#Add immediate unsigned (no overflow)
    lw	    #Load word
    sw	    #Store word

    #Other instructions
    addu	#Add unsigned (no overflow)
    and	    #Bitwise and
    andi	#Bitwise and immediate
    beq	    #Branch on equal
    bgez	#Branch on greater than or equal to zero
    bgezal	#Branch on non-negative (>=0) and link
    bgtz	#Branch on greater than zero
    blez	#Branch on less than or equal to zero
    bltz	#Branch on less than zero
    bltzal	#Branch on less than zero and link
    bne	    #Branch on not equal
    div	    #Divide
    divu	#Divide unsigned
    j	    #Jump
    jalr	#Jump and link register
    jal	    #Jump and link
    lb	    #Load byte
    lbu	    #Load byte unsigned
    lh	    #Load half-word
    lhu	    #Load half-word unsigned
    lui	    #Load upper immediate
    lwl	    #Load word left
    lwr	    #Load word right
    mthi	#Move to HI
    mtlo	#Move to LO
    mult	#Multiply
    multu	#Multiply unsigned
    or	    #Bitwise or
    ori	    #Bitwise or immediate
    sb	    #Store byte
    sh	    #Store half-word
    sll	    #Shift left logical
    sllv	#Shift left logical variable
    slt	    #Set on less than (signed)
    slti	#Set on less than immediate (signed)
    sltiu	#Set on less than immediate unsigned
    sltu	#Set on less than unsigned
    sra	    #Shift right arithmetic
    srav	#Shift right arithmetic
    srl	    #Shift right logical
    srlv	#Shift right logical variable
    subu	#Subtract unsigned
    xor	    #Bitwise exclusive or
    xori	#Bitwise exclusive or immediate
)

#check if the requested instruction is valid. Exit otherwise
if [[ ! ( " ${VALID_INSTRUCTIONS[*]} " =~ " $INSTRUCTION " || "$INSTRUCTION" == "all" ) ]]
then
    echo "EXIT CODE 1: The instruction parameter is not valid">&2
    exit 1
fi

#######################################
#all our testbenches must both be stored in /test/testbenches and listed in the array below
#format:
#"[instruction you are testing];[file name without extension];[comments/notes/explanation]"
#use semicolons to delim. the comment section is optional. instruction must be lowercase. sort by instruction
#######################################
TESTBENCHES=(
    "jr;jr_1"
    "jr;jr_2"
    "addiu;addiu_1"
    "addiu;addiu_2"
    "addiu;addiu_3"
    "lw;lw_1"
    "lw;lw_2"
    "lw;lw_3"
    "sw;sw_1"
    "sw;sw_2"
    "addu;addu_1"
    "addu;addu_2"
    "addu;addu_3"
    "and;and_1"
    "and;and_2"
    "and;and_3"
    "andi;andi_1"
    "andi;andi_2"
    "andi;andi_3"
    "beq;beq_1"
    "beq;beq_2"
    "bgez;bgez_1"
    "bgez;bgez_2"
    "bgez;bgez_3"
    "bgezal;bgezal_1"
    "bgezal;bgezal_2"
    "bgezal;bgezal_3"
    "bgtz;bgtz_1"
    "bgtz;bgtz_2"
    "bgtz;bgtz_3"
    "blez;blez_1"
    "blez;blez_2"
    "blez;blez_3"
    "bltz;bltz_1"
    "bltz;bltz_2"
    "bltz;bltz_3"
    "bltzal;bltzal_1"
    "bltzal;bltzal_2"
    "bltzal;bltzal_3"
    "bne;bne_1"
    "bne;bne_2"
    "div;div_1"
    "div;div_2"
    "div;div_3"
    "divu;divu_1"
    "divu;divu_2"
    "divu;divu_3"
    "j;j_1"
    "j;j_2"
    "jalr;jalr_1"
    "jalr;jalr_2"
    "jal;jal_1"
    "jal;jal_2"
    "lb;lb_1"
    "lb;lb_2"
    "lb;lb_3"
    "lb;lb_4"
    "lbu;lbu_1"
    "lbu;lbu_2"
    "lbu;lbu_3"
    "lbu;lbu_4"
    "lh;lh_1"
    "lh;lh_2"
    "lhu;lhu_1"
    "lhu;lhu_2"
    "lui;lui_1"
    "lui;lui_2"
    "lui;lui_3"
    "lwl;lwl_1"
    "lwl;lwl_2"
    "lwl;lwl_3"
    "lwl;lwl_4"
    "lwr;lwr_1"
    "lwr;lwr_2"
    "lwr;lwr_3"
    "lwr;lwr_4"
    "mthi;mthi_1"
    "mthi;mthi_2"
    "mthi;mthi_3"
    "mtlo;mtlo_1"
    "mtlo;mtlo_2"
    "mtlo;mtlo_3"
    "mult;mult_1"
    "mult;mult_2"
    "mult;mult_3"
    "multu;multu_1"
    "multu;multu_2"
    "multu;multu_3"
    "or;or_1"
    "or;or_2"
    "or;or_3"
    "ori;ori_1"
    "ori;ori_2"
    "ori;ori_3"
    "sb;sb_1"
    "sb;sb_2"
    "sb;sb_3"
    "sb;sb_4"
    "sh;sh_1"
    "sh;sh_2"
    "sll;sll_1"
    "sll;sll_2"
    "sll;sll_3"
    "sllv;sllv_1"
    "sllv;sllv_2"
    "sllv;sllv_3"
    "slt;slt_1"
    "slt;slt_2"
    "slt;slt_3"
    "slti;slti_1"
    "slti;slti_2"
    "slti;slti_3"
    "sltiu;sltiu_1"
    "sltiu;sltiu_2"
    "sltiu;sltiu_3"
    "sltu;sltu_1"
    "sltu;sltu_2"
    "sltu;sltu_3"
    "sra;sra_1"
    "sra;sra_2"
    "sra;sra_3"
    "srav;srav_1"
    "srav;srav_2"
    "srav;srav_3"
    "srl;srl_1"
    "srl;srl_2"
    "srl;srl_3"
    "srlv;srlv_1"
    "srlv;srlv_2"
    "srlv;srlv_3"
    "subu;subu_1"
    "subu;subu_2"
    "subu;subu_3"
    "xor;xor_1"
    "xor;xor_2"
    "xor;xor_3"
    "xori;xori_1"
    "xori;xori_2"
    "xori;xori_3"
)

#bash does not (easily) support multidimensional arrays, so I used a workaround
#loop over every testbench in the array, ie each string
for (( i = 0; i < ${#TESTBENCHES[@]}; i++ ))
do
    #delimit the string by ; to create a new (temporary) array for this iteration called LINE, consisting of the three entries entered before
    IFS=';' read -ra LINE <<< ${TESTBENCHES[i]}

    #if we are testing all instructions, no checking is needed: run everything!
    if [[ "$INSTRUCTION" == "all" ]]
    then
        iverilog -Wall -g 2012 -s ${LINE[1]} -o "$EXECUTABLE_DIRECTORY"/${LINE[1]} "$TESTBENCH_DIRECTORY"/${LINE[1]}".v" $SOURCE_DIRECTORY/mips_cpu_*.v 1>&2

        #check if the testbench successfully compiled and returned 0. if not, fail and skip to the next iteration
        if [[ $? -ne 0 ]]
        then
            echo "${LINE[1]} ${LINE[0]} Fail ${LINE[2]}"
            echo "Compilation Error" 1>&2
            continue
        fi

        #check if the executable runs successfully and returns 0. fatal errors return non-0 values. In that case, fail and skip to the next iteration
        ./"$EXECUTABLE_DIRECTORY"/${LINE[1]} 1>&2
        if [[ $? -ne 0 ]]
        then
            echo "${LINE[1]} ${LINE[0]} Fail ${LINE[2]}"
            echo "Runtime Error" 1>&2
            continue
        fi

        #if both previous checks are fine, then pass
        #echo "${LINE[1]} ${LINE[0]} Pass ${LINE[2]}"        
   
    else

        #if we are testing a specific instruction, we only want to use the array entries corresponding to that instruction and ignore the rest
        if [[ ! "$INSTRUCTION" == "${LINE[0]}" ]]
        then
            continue
        fi       

        #everything below here is the same as above
        iverilog -Wall -g 2012 -s ${LINE[1]} -o "$EXECUTABLE_DIRECTORY"/${LINE[1]} "$TESTBENCH_DIRECTORY"/${LINE[1]}".v" $SOURCE_DIRECTORY/mips_cpu_*.v 1>&2
        if [[ $? -ne 0 ]]
        then
            echo "${LINE[1]} ${LINE[0]} Fail ${LINE[2]}"
            echo "Compilation Error" 1>&2
            continue
        fi
        ./"$EXECUTABLE_DIRECTORY"/${LINE[1]} 1>&2
        if [[ $? -ne 0 ]]
        then
            echo "${LINE[1]} ${LINE[0]} Fail ${LINE[2]}"
            echo "Runtime Error" 1>&2
            continue
        fi
        #echo "${LINE[1]} ${LINE[0]} Pass ${LINE[2]}"
    fi
done

#delete all executables at the end
rm -r ""$EXECUTABLE_DIRECTORY/*"" 1>&2
rm -r ""$EXECUTABLE_DIRECTORY"" 1>&2

#delete all vcd files
rm ""*.vcd"" 1>&2