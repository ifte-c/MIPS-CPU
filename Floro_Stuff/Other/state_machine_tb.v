module state_machine_tb ();

    logic clk;
    logic reset;
    logic wait_req;

    logic[31:0] mem_address;
    logic[5:0] opcode;
    logic[1:0] state;

    initial begin
        clk = 0;
        repeat (30) begin
            clk = ~clk;
        end
    end

    initial begin
        reset = 1;
        #1;
        assert (state == 0) else $fatal(1, "Failed to reset");
        reset = 0;
        #2;
        assert (state == 1) else $fatal(1, "Failed to enter exec1");
        #2;
        assert (state == 0) else $fatal(1, "Failed to enter fetch");
        #2;
        assert (state == 1) else $fatal(1, "Failed to enter exec1");
    end

    state_machine dut(.clk(clk), .wait_req(wait_req), .reset(reset), .mem_address(mem_address), .opcode(opcode), .state(state));

endmodule          