module sign_ex_tb();

    logic[15:0] in;
    logic[31:0] out;

    initial begin
        assign in=16'h0fff;
        #5 assert(out==32'h00000fff) else $fatal(1,"error 1, out=%h",out);
        $display("out=%h",out);
        assign in=16'hf000;
        #5 assert(out==32'hfffff000) else $fatal(1,"error 2, out=%h",out);
        $display("out=%h",out);
    end

    sign_ex dut(in, out);

endmodule