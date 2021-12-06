module j_adrs_tb();

logic[25:0] mem_address;
logic[31:0] pc_val;
logic[31:0] jump_address;

initial begin
    assign mem_address=26'b00111111110000000011111111;
    assign pc_val=32'ha000ffff;
    #5 assert(jump_address==32'ha3fc03fc) else $fatal(1,"worng address=%h",jump_address);

end

j_adrs dut(mem_address, pc_val, jump_address);

endmodule