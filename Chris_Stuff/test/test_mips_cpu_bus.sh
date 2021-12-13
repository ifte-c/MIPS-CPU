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

#relative paths to where the testbench files are and where the executable files should be stored
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
    "jr;jr_1;Jump register test"
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
        iverilog -Wall -g 2012 -s "$TESTBENCH_DIRECTORY"/${LINE[1]} -o "$EXECUTABLE_DIRECTORY"/${LINE[1]} "$SOURCE_DIRECTORY/mips_cpu_*.v" 1>&2

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
        echo "${LINE[1]} ${LINE[0]} Pass ${LINE[2]}"        
   
    else

        #if we are testing a specific instruction, we only want to use the array entries corresponding to that instruction and ignore the rest
        if [[ ! "$INSTRUCTION" == "${LINE[0]}" ]]
        then
            continue
        fi       

        #everything below here is the same as above
        iverilog -Wall -g 2012 -s "$TESTBENCH_DIRECTORY"/${LINE[1]} -o "$EXECUTABLE_DIRECTORY"/${LINE[1]} "$SOURCE_DIRECTORY/mips_cpu_*.v" 1>&2
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
        echo "${LINE[1]} ${LINE[0]} Pass ${LINE[2]}"
    fi
done

#delete all executables at the end
rm -r "$EXECUTABLE_DIRECTORY/*" 1>&2