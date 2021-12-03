// `timescale 1ns/1ps

module Reg_file(
    input logic clk,
    input logic RegWrite,
    input logic [4:0] Write_register,
    input logic [31:0] Write_data,
    

    //read port 1
    input logic [4:0] Read_register_1, //address1
    output logic [31:0] Read_data_1, //data1

    //read port 2
    input logic [4:0] Read_register_2, //address2
    output logic [31:0] Read_data_2 //data2
);

reg [31:0] reg_array [31:0];
integer i;
//write port

initial begin
    for(i=0; i<32; i=i+1)
    reg_array[i] <= 32'd0;
end

always @ (posedge clk) begin
    if(RegWrite) begin
        reg_array[Write_register] <= Write_data;
    end
end

assign Read_data_1 = reg_array[Read_register_1];
assign Read_data_2 = reg_array[Read_register_2];
endmodule