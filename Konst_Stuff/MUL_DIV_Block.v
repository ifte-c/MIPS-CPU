module MUL_DIV_Block(
    input clk,
    input reset,
    input logic [31:0] op1,
    input logic [31:0] op2,
    input  logic[5:0] func,
    input  logic[5:0] opcode,
    output logic[63:32] hi,
    output logic[31:0] lo,
    output logic[63:0] hilo
);
    logic signed[31:0] sa;
    logic signed[31:0] sb;
    logic [31:0] ua;
    logic [31:0] ub;
    //logic signed[63:0] sm;
    logic[63:0] m; 
    logic[32:0] r;
    logic[32:0] q;
    logic signed[63:0] sm; 
    logic signed[32:0] sr;
    logic signed[32:0] sq;

    assign sa=$signed(op1);
    assign sb=$signed(op2);
    assign ua=op1;
    assign ub=op2;
    assign hilo={hi,lo};
     
    //assign m=(func[0]==1)?(ua*ub):(sa*sb);
    //assign q=(func[0]==1)?(ua/ub):(sa/sb);
    //assign r=(func[0]==1)?(ua%ub):(sa%sb);
            
    assign sm=sa*sb;
    assign m=ua*ub;
    assign sr=sa%sb;
    assign r=ua%ub;
    assign sq=sa/sb;
    assign q=ua/ub;
            
    //assign sm=m;



    always_ff @(posedge clk) begin
       
    if(reset==1) begin
        hi<=0;
        lo<=0;
    end

    if((opcode==0)&&(func[4]==1)) begin

       if(func[4:3]==3)begin
            if((func[1:0]==0)||(func[1:0]==1)) begin
                   if (func[0]==1)begin
                    hi<= m[63:32];
                    lo<= m[31:0];  
                   end
                   else begin
                    hi<= sm[63:32];
                    lo<= sm[31:0]; 
                     end 
            end
            else if((func[1:0]==2)||(func[1:0]==3)) begin
                 if (func[0]==1)begin
                      hi<= r;
                      lo<= q;
                   end
                   else begin
                     hi<= sr;
                     lo<= sq; 
                     end 
                end
            
       end
       else  begin
           if(func[1:0]==1) begin
               hi<=op1;
                end
           else if(func[1:0]==3) begin
               lo<=op1;
                end
            end
        end
    end

endmodule
