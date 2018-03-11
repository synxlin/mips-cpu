module Hazard_Unit(IF_ID_Rs, IF_ID_Rt, ID_PCSrc, EX_PCSrc, ID_EX_MemRead, ID_EX_Rt, EX_ALUOut_0, PCWrite, IF_ID_write, IF_ID_flush, ID_EX_flush);

input [4:0] IF_ID_Rs;
input [4:0] IF_ID_Rt;
input [2:0] ID_PCSrc;
input [2:0] EX_PCSrc;
input ID_EX_MemRead;
input [4:0] ID_EX_Rt;
input EX_ALUOut_0;

output PCWrite; 
output IF_ID_write;
output IF_ID_flush;
output ID_EX_flush;

reg [2:0] PCWrite_mark;
reg [2:0] IF_ID_write_mark;
reg [2:0] IF_ID_flush_mark;
reg [2:0] ID_EX_flush_mark;

always @(*) begin
	// Branch
	if (EX_PCSrc == 3'd1 && EX_ALUOut_0) begin		
		PCWrite_mark[0] = 1'b1;
		IF_ID_write_mark[0] = 1'b1;
		IF_ID_flush_mark[0] = 1'b1;	
		ID_EX_flush_mark[0] = 1'b1;
	end
	else begin
		PCWrite_mark[0] = 1'b1;
		IF_ID_write_mark[0] = 1'b1;
		IF_ID_flush_mark[0] = 1'b0;	
		ID_EX_flush_mark[0] = 1'b0;
	end
	// Jump
	if(ID_PCSrc[2:1]==2'b00) begin
		PCWrite_mark[1] = 1'b1;
		IF_ID_write_mark[1] = 1'b1;
		IF_ID_flush_mark[1] = 1'b0;	
		ID_EX_flush_mark[1] = 1'b0;
	end
	else begin
		PCWrite_mark[1] = 1'b1;
		IF_ID_write_mark[1] = 1'b1;
		IF_ID_flush_mark[1] = 1'b1;	
		ID_EX_flush_mark[1] = 1'b0;
	end
	// Load use
	if(ID_EX_MemRead && (ID_EX_Rt == IF_ID_Rs || ID_EX_Rt == IF_ID_Rt)) begin
		PCWrite_mark[2] = 1'b0;
		IF_ID_write_mark[2] = 1'b0;
		IF_ID_flush_mark[2] = 1'b0;	
		ID_EX_flush_mark[2] = 1'b1;
	end
	else begin
		PCWrite_mark[2] = 1'b1;
		IF_ID_write_mark[2] = 1'b1;
		IF_ID_flush_mark[2] = 1'b0;	
		ID_EX_flush_mark[2] = 1'b0;
	end
end

assign PCWrite = PCWrite_mark[0] & PCWrite_mark[1] & PCWrite_mark[2];
assign IF_ID_write = IF_ID_write_mark[0] & IF_ID_write_mark[1] & IF_ID_write_mark[2];
assign IF_ID_flush = IF_ID_flush_mark[0] | IF_ID_flush_mark[1] | IF_ID_flush_mark[2];
assign ID_EX_flush = ID_EX_flush_mark[0] | ID_EX_flush_mark[1] | ID_EX_flush_mark[2];

endmodule