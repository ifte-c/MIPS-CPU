module mips_cpu_bus(
    /* Standard signals */
    input logic clk,
    input logic reset,
    output logic active,
    output logic[31:0] register_v0,

    /* Avalon memory mapped bus controller (master) */
    output logic[31:0] address,
    output logic write,
    output logic read,
    input logic waitrequest,
    output logic[31:0] writedata,
    output logic[3:0] byteenable,
    input logic[31:0] readdata
);

/* An implementation of a MIPS CPU which meets the pre-specified template for signal names and interface timings. 
You may also include other verilog modules in files of the form rtl/mips_cpu/*.v and/or rtl/mips_cpu_*.v. 
If you include both a bus and a harvard verilog file it will be assumed that you want the bus version to be assessed. 
Any files not matching these patterns will be ignored. */

// just put the cpu here and we're done

endmodule