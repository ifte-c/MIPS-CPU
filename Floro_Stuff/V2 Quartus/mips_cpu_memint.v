module mips_cpu_memint(
    input logic[31:0] cpu_out,
    input logic[5:0] op,
    input logic[1:0] instr_type,
    output logic[31:0] mem_addr,
    output logic[3:0] byteenable
);

    logic[1:0] byte_idx;
    logic byte0;
    logic byte1;
    logic byte2;
    logic byte3;
   
    assign byte_idx=cpu_out%4;
    assign mem_addr=cpu_out-byte_idx;

    always_comb begin
        if((instr_type==1) || (instr_type==2)) begin
            byte0=0;
            byte1=0;
            byte2=0;
            byte3=0;
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
            6'b001111 : begin//LUI
                byte0=1;
                byte1=1;
                byte2=1;
                byte3=1;
            end
            6'b100011 : begin//LW
                byte0=1;
                byte1=1;
                byte2=1;
                byte3=1;
            end
            6'b100010 : begin//LWL
                case(byte_idx)
                0 : begin
                    byte0=1;
                    byte1=1;
                    byte2=1;
                    byte3=1;
                end
                1 : begin
                    byte1=1;
                    byte2=1;
                    byte3=1;
                end
                2 : begin
                    byte2=1;
                    byte3=1;
                end
                3 : byte3=1;
                endcase
            end
            6'b100110 : begin//LWR
                case(byte_idx)
                0 : byte0=1;
                1 : begin
                    byte0=1;
                    byte1=1;
                end
                2 : begin
                    byte0=1;
                    byte1=1;
                    byte2=1;
                end
                3 : begin
                    byte0=1;
                    byte1=1;
                    byte2=1;
                    byte3=1;
                end
                endcase
            end
            6'b101000 : begin//SB
                case(byte_idx)
                0 : byte0=1;
                1 : byte1=1;
                2 : byte2=1;
                3 : byte3=1;
                endcase
            end
            6'b101001 :  begin//SH
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
            6'b101011 :  begin//SW
                byte0=1;
                byte1=1;
                byte2=1;
                byte3=1;
            end
            endcase
        end
        else begin
            byte0=1;
            byte1=1;
            byte2=1;
            byte3=1;
        end
    end

    assign byteenable={byte3, byte2, byte1, byte0};
    
endmodule