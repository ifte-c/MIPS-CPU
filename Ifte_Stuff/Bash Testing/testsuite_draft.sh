#!/bin/bash

set -eou pipefail

SOURCE="$1"
INSTR="$2"

iverilog -Wall -g 2012 -s mips_testbench -P mips_testbench.RAM_INIT_FILE=\"${INSTR}.hex.txt\" \
-o mips_cpu_bus_tb_exe ${SOURCE}/mips_cpu_*.v ram.v #rename ram later

set +e
mips_cpu_bus_tb_exe > output.stdout
RESULT=$?
set -e

if [[ "${RESULT}" -ne 0 ]]
then
    echo "uniquename, ${INSTR}, Fail" #add unique name
fi