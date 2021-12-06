module PC_tb();

    logic[31:0] nxt_pc_val;
    logic pc_ctrl;
    logic pc_write_cond;
    logic instr_type;
    logic clk;
    logic reset;
    logic[31:0] cur_pc_val;
    
    initial begin
        $dumpfile("PC_tb.vcd");
        $dumpvars(0, PC_tb);
        clk=0;
        repeat (15) begin
            #10;
            clk=~clk;
        end
    end

    initial begin
        reset=1;
        pc_ctrl=1;
        pc_write_cond=0;
        nxt_pc_val=4;
        #15; 
        reset=0;
        #15;//20
        pc_ctrl=0;
        pc_write_cond=0;
        #20;//40
        pc_ctrl=1;
        pc_write_cond=1;
        nxt_pc_val=20;
        #20;//60
        pc_ctrl=1;
        pc_write_cond=0;
        nxt_pc_val=cur_pc_val+4;

        #20;//80
        pc_ctrl=0;
        pc_write_cond=0;
        instr_type=0;

        #20;//100

        #20;//120
        pc_ctrl=1;
        pc_write_cond=0;
        nxt_pc_val=cur_pc_val+4;

        #20;//140

    end

    PC dut(nxt_pc_val, pc_ctrl, pc_write_cond, instr_type, clk, reset, cur_pc_val);

endmodule