module store_filter(
    input logic[31:0] data_in,
    input logic[5:0] op,
    output logic[31:0] data_out
);
    
    logic[7:0] byte3;
    assign byte3 = data_in[7:0];
    logic[15:0] halfword;
    assign halfword = data_in[15:0];

    always @(*) begin
        case(op)
        6'b101000 : data_out={24'b000000,byte3};//store byte SB
        6'b101001 : data_out={16'b0000,halfword};//store halfword SH
        6'b101011 : data_out=data_in;//store word SW
        endcase
    end
    
endmodule