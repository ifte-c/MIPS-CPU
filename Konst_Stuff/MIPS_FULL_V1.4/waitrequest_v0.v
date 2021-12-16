module waitrequest(

    input logic[5:0] opcode,
    input logic waitrequest,
    input logic[1:0] state,
    input clk,

    output logic waitreq_relev,
    output logic waitreq_sync,
    output logic waitreq_offset
);

logic waitreqplus;

assign waitreq_relev =  waitrequest & (state == 0 || (state == 1 && opcode[5] == 1));
assign waitreq_sync = waitreq_relev|waitreqplus;

always_ff @(posedge clk) begin
        
        waitreqplus<=waitrequest;
        waitreq_offset <= waitreq_sync;
    end

endmodule