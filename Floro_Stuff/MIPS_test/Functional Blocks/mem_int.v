module mem_int(
    input logic[31:0] cpu_out,
    input logic[5:0] op,
    output logic[31:0] mem_addr,
    output logic[3:0] byteenable
);

    logic[2:0] byte_idx;
    logic byte0=0;
    logic byte1=0;
    logic byte2=0;
    logic byte3=0;
   
    assign byte_idx=cpu_out%4;
    assign mem_addr=cpu_out-byte_idx;

    always_comb begin
        case(op)
        6'b100000 : begin//LB
            case(byte_idx)
            0 : byte0=1;
            1 : byte1=1;
            2 : byte2=1;
            3 : byte3=1;
            endcase
        end
        6'b100100 :  begin//LBU
            case(byte_idx)
            0 : byte0=1;
            1 : byte1=1;
            2 : byte2=1;
            3 : byte3=1;
            endcase
        end
        6'b100001 :  begin//LH
            case(byte_idx)
            0 : begin
                byte0=1;
                byte1=1;
            end
            2 : begin
                byte2=1;
                byte3=1;
            end
            endcase
        end
        6'b100101 :  begin//LHU
            case(byte_idx)
            0 : begin
                byte0=1;
                byte1=1;
            end
            2 : begin
                byte2=1;
                byte3=1;
            end
            endcase
        end
        6'b001111 begin//LUI
            byte0=1;
            byte1=1;
            byte2=1;
            byte3=1;
        endcase
        6'b100011 begin//
    end



endmodule