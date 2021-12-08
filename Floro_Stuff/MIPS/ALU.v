module ALU(
    input logic[31:0] rs,
    input logic[31:0] rt,
    input logic[4:0] shift,
    input logic[4:0] ALU_ctrl,
    output logic[31:0] ALU_out,
    output logic[31:0] ALU_lo,
    output logic[31:0] ALU_hi
);

    logic[63:0] tmp;
    assign ALU_hi=tmp[63:32];
    assign ALU_lo=tmp[31:0];

    logic[4:0] tmp_shift;//for variable shifts
    assign tmp_shift= rt[4:0];

    always_comb begin

        if(ALU_ctrl==0) begin//addition
            ALU_out = rs + rt;
        end

        else if(ALU_ctrl==1) begin//subtraction
            ALU_out = rs - rt;
        end

        else if(ALU_ctrl==2) begin//multiplication signed
            tmp = $signed(rs) * $signed(rt);
        end

        else if(ALU_ctrl==3) begin//mutiplication unsigned
            tmp = rs * rt;
        end

        else if(ALU_ctrl==4) begin//division signed
            tmp = $signed(rs) / $signed(rt);
        end

        else if(ALU_ctrl==5) begin//division unsigned
            tmp = rs / rt;
        end

        else if(ALU_ctrl==6) begin//bitwise AND
            ALU_out = rs & rt;
        end

        else if(ALU_ctrl==7) begin//bitwise OR
            ALU_out = rs | rt; 
        end

        else if(ALU_ctrl==8) begin//bitwise XOR
            ALU_out = rs ^ rt; 
        end

        else if(ALU_ctrl==9) begin//shift left
            ALU_out = rs << shift;
        end

        else if(ALU_ctrl==10) begin//shift left variable
            ALU_out = rs << tmp_shift;
        end

        else if(ALU_ctrl==11) begin//shift right logical
            ALU_out = rs >> shift;
        end

        else if(ALU_ctrl==12) begin//shift right logical variable
            ALU_out = rs >> tmp_shift;
        end

        else if(ALU_ctrl==13) begin//shift right arithmetic
            ALU_out = $signed(rs) >>> shift;
        end

        else if(ALU_ctrl==14) begin//shift right arithmetic variable
            ALU_out = $signed(rs) >>> tmp_shift;
        end

        else if(ALU_ctrl==15) begin//equals
            if(rs==rt) begin
                ALU_out=1;
            end
            else begin
                ALU_out=0;
            end
        end

        else if(ALU_ctrl==16) begin//greater than equals 0
            if($signed(rs)>=0) begin
                ALU_out=1;
            end
            else begin
                ALU_out=0;
            end
        end

        else if(ALU_ctrl==17) begin//greater than 0
            if($signed(rs)>0) begin
                ALU_out=1;
            end
            else begin
                ALU_out=0;
            end
        end

        else if(ALU_ctrl==18) begin//less than equals 0
            if($signed(rs)<=0) begin
                ALU_out=1;
            end
            else begin
                ALU_out=0;
            end
        end

        else if(ALU_ctrl==19) begin//less than 0
            if($signed(rs)<0) begin
                ALU_out=1;
            end
            else begin
                ALU_out=0;
            end
        end

        else if(ALU_ctrl==20) begin//less than signed
            if($signed(rs)<$signed(rt)) begin
                ALU_out=1;
            end
            else begin
                ALU_out=0;
            end
        end

        else if(ALU_ctrl==21) begin//less than unsigned
            if(rs < rt) begin
                ALU_out=1;
            end
            else begin
                ALU_out=0;
            end
        end

        else if(ALU_ctrl==22) begin//not equal
            if(rs != rt) begin
                ALU_out=1;
            end
            else begin
                ALU_out=0;
            end
        end

        else if(ALU_ctrl==23) begin//pass rs
            ALU_out = rs; 
        end

        else if(ALU_ctrl==24) begin//for Jump instructions
            ALU_out = 1; 
        end

        else if(ALU_ctrl==25) begin//for Jump instructions
            ALU_out = rt << 16; 
        end

    end

endmodule