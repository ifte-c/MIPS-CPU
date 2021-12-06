module j_adrs(
    input logic[25:0] mem_address,
    input logic[31:0] pc_val,
    output logic[31:0] jump_address
);
  
    assign jump_address={pc_val[31:28], mem_address, 2'b00};

endmodule
