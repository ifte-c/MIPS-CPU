module ram_tb();

    logic[31:0] ram_address;
    /*logic[4:0] address;*/
    logic[31:0] cpu_out;
    
    /*assign address = ram_address - 8'hBFC000000; */

    reg [31:0] ram [31:0];
    logic [31:0] ram_out;
    logic[31:0] ram_read;
    logic[31:0] ram_write;

    /*assign ram_read = ram[i];
    assign ram_write = 0; */

    logic wait_req;
    assign wait_req = 0; /*The wait request is set according to preferance and is constant*/

    logic read;
    assign read = 1;
    logic write;
    assign write = 0;

    assign ram[0] = 10;
    assign ram[1] = 20;
    assign ram[2] = 30;
    assign ram[3] = 40;
    assign ram[4] = 50;
    assign ram[5] = 60;
    assign ram[6] = 70;
    assign ram[7] = 80;
    assign ram[8] = 90;
    assign ram[9] = 100;

    logic i;
    logic clk;

    initial begin
        clk = 0;
        repeat (30) begin
            clk = ~clk;
        end
    end

    initial begin
        always @(posedge clk) begin
            if (read == 1) begin
                ram_out <= ram[i];
            end
            else if (write == 1) begin
                ram[i] <= cpu_out;
            end
        end
    end

    initial begin

        i = 0;
        repeat(10) begin
            ram_address = i;
            #1;
            $display(ram_out);
            i = i + 1;
        end
        
    end

endmodule