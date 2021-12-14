module mips_cpu_memdec(
    input logic[31:0] data_in,
    input logic[31:0] rt,
    input logic[3:0] byteenable,
    input logic[5:0] op,
    output logic[31:0] data_out,
    input logic clk,
    input logic reset
);

    logic[3:0] be_signal;
    logic[7:0] byte0;
    logic[7:0] byte1;
    logic[7:0] byte2;
    logic[7:0] byte3;
    logic[7:0] rt_byte0;
    logic[7:0] rt_byte1;
    logic[7:0] rt_byte2;
    logic[7:0] rt_byte3;

    logic byte0_msb;
    logic byte1_msb;
    logic byte2_msb;
    logic byte3_msb;



    assign byte0=data_in[31:24];
    assign byte1=data_in[23:16];
    assign byte2=data_in[15:8];
    assign byte3=data_in[7:0];
    assign rt_byte0=rt[31:24];
    assign rt_byte1=rt[23:16];
    assign rt_byte2=rt[15:8];
    assign rt_byte3=rt[7:0];
    assign byte0_msb=data_in[31];
    assign byte1_msb=data_in[23];
    assign byte2_msb=data_in[15];
    assign byte3_msb=data_in[7];
    
    always_comb begin
        case(op)
        6'b100000 : begin//LB
            case(be_signal)
            1 : begin
                case(byte0_msb)
                0 : data_out={24'd0,byte0};
                1 : data_out={24'hffffff,byte0};
                endcase
            end
            2 : begin
                case(byte1_msb)
                0 : data_out={24'd0,byte1};
                1 : data_out={24'hffffff,byte1};
                endcase
            end
            4 : begin
                case(byte2_msb)
                0 : data_out={24'd0,byte2};
                1 : data_out={24'hffffff,byte2};
                endcase
            end
            8 : begin
                case(byte3_msb)
                0 : data_out={24'd0,byte3};
                1 : data_out={24'hffffff,byte3};
                endcase
            end            
            endcase
        end

        6'b100100 :  begin//LBU
            case(be_signal)
            1 : data_out={24'd0,byte0};
            2 : data_out={24'd0,byte1};
            4 : data_out={24'd0,byte2};
            8 : data_out={24'd0,byte3};
            endcase
        end

        6'b100001 :  begin//LH
            case(be_signal)
            4'b0011 : begin
                case(byte0_msb)
                0 : data_out={16'd0,byte0,byte1};
                1 : data_out={16'hffff,byte0,byte1};
                endcase
            end
            4'b1100 : begin
                case(byte2_msb)
                0 : data_out={16'd0,byte2,byte3};
                1 : data_out={16'hffff,byte2,byte3};
                endcase
            end
            endcase
        end

        6'b100101 :  begin//LHU
            case(be_signal)
            4'b0011 : data_out={16'd0,byte0,byte1};
            4'b1100 : data_out={16'd0,byte2,byte3};
            endcase
        end

        6'b001111 : data_out={byte0, byte1, byte2, byte3};//LUI

        6'b100011 : data_out={byte0, byte1, byte2, byte3};//LW

        6'b100010 : begin //LWL
            case(be_signal)
            4'b1000 : data_out={byte3, rt_byte1,rt_byte2, rt_byte3};
            4'b1100 : data_out={byte2, byte3, rt_byte2, rt_byte3};
            4'b1110 : data_out={byte1, byte2, byte3, rt_byte3};
            4'b1111 : data_out={byte0, byte1, byte2, byte3};
            endcase
        end

        6'b100010 : begin //LWR
            case(be_signal)
            4'b0001 : data_out={rt_byte0, rt_byte1, rt_byte2, byte0};
            4'b0011 : data_out={rt_byte0, rt_byte1, byte0, byte1};
            4'b0111 : data_out={rt_byte0, byte0, byte1, byte2};
            4'b1111 : data_out={byte0, byte1, byte2, byte3};
            endcase
        end

        endcase

    end

    always_ff @(posedge clk) begin
        if(reset==1) begin
            be_signal <= 0;
        end
        else begin
            be_signal <= byteenable;
        end
    end


endmodule