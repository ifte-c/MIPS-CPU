#!/bin/bash
#All I want for Christmas is you

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


for (( i = 0; i < ${#VALID_INSTRUCTIONS[@]}; i++ ))
do
    for j in testbenches/*.v
    do
    m=0
    k=$(echo $(basename $j) | cut -d'_' -f 1)
        if [[ " $k " =~ " ${VALID_INSTRUCTIONS[i]} " ]]
        then
            #echo "${VALID_INSTRUCTIONS[i]} exists"
            m=1
            break
        fi
    done
    if [[ $m -eq 0 ]]
    then
        echo "${VALID_INSTRUCTIONS[i]} missing"
    fi
done