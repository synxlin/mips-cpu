module ID_EX_Reg(clk, reset, ID_EX_flush, PC_add_4_in, DataBusA_in, DataBusB_in, LUOut_in, Rs_in, Rt_in, Rd_in, Shamt_in,
	RegDst_in, PCSrc_in, MemRead_in, MemWrite_in, MemToReg_in, ALUFun_in, 
	ALUSrc1_in, ALUSrc2_in, RegWrite_in, Sign_in, PC_add_4_out, DataBusA_out, DataBusB_out, LUOut_out, Rs_out,
	Rt_out, Rd_out, Shamt_out, RegDst_out, PCSrc_out, MemRead_out, MemWrite_out,
	MemToReg_out, ALUFun_out, ALUSrc1_out, ALUSrc2_out, RegWrite_out, Sign_out);
	
input clk;
input reset;
input ID_EX_flush;
input [31:0] PC_add_4_in;
input [31:0] DataBusA_in;
input [31:0] DataBusB_in;
input [31:0] LUOut_in;

input [4:0] Rs_in;
input [4:0] Rt_in;
input [4:0] Rd_in;
input [4:0] Shamt_in;
input [1:0] RegDst_in;
input [2:0] PCSrc_in;
input MemRead_in;
input MemWrite_in;
input [1:0] MemToReg_in;
input [5:0] ALUFun_in;
input ALUSrc1_in;
input ALUSrc2_in;
input RegWrite_in;
input Sign_in;

output reg [31:0] PC_add_4_out;
output reg [31:0] DataBusA_out;
output reg [31:0] DataBusB_out;
output reg [31:0] LUOut_out;

output reg [4:0] Rs_out;
output reg [4:0] Rt_out;
output reg [4:0] Rd_out;
output reg [4:0] Shamt_out;
output reg [1:0] RegDst_out;
output reg [2:0] PCSrc_out;
output reg MemRead_out;
output reg MemWrite_out;
output reg [1:0] MemToReg_out;
output reg [5:0] ALUFun_out;
output reg ALUSrc1_out;
output reg ALUSrc2_out;
output reg RegWrite_out;
output reg Sign_out;


always @(posedge clk or negedge reset) begin
	if (~reset) begin
			PC_add_4_out <= 32'h8000_0000;
			DataBusA_out <= 32'h0000_0000;
			DataBusB_out <= 32'h0000_0000;
			LUOut_out <= 32'h0000_0000;
			Rs_out <= 5'h00;
			Rt_out <= 5'h00;
			Rd_out <= 5'h00;
			Shamt_out <= 5'h00;
			RegDst_out <= 2'h0;
			PCSrc_out <= 3'h0;
			MemRead_out <= 1'h0;
			MemWrite_out <= 1'h0;
			MemToReg_out <= 2'h0;
			ALUFun_out <= 6'h00;
			ALUSrc1_out <= 1'h0;
			ALUSrc2_out <= 1'h0;
			RegWrite_out <= 1'h0;
			Sign_out <= 1'h0;
	end
	else begin
		// Again, we do not flush PC to cope with IRQ hazard
		if(ID_EX_flush) begin
			PC_add_4_out <= PC_add_4_in - 4;
			DataBusA_out <= 32'h0000_0000;
			DataBusB_out <= 32'h0000_0000;
			LUOut_out <= 32'h0000_0000;
			Rs_out <= 5'h00;
			Rt_out <= 5'h00;
			Rd_out <= 5'h00;
			Shamt_out <= 5'h00;
			RegDst_out <= 2'h0;
			PCSrc_out <= 3'h0;
			MemRead_out <= 1'h0;
			MemWrite_out <= 1'h0;
			MemToReg_out <= 2'h0;
			ALUFun_out <= 6'h00;
			ALUSrc1_out <= 1'h0;
			ALUSrc2_out <= 1'h0;
			RegWrite_out <= 1'h0;
			Sign_out <= 1'h0;
		end
		else begin
			PC_add_4_out <= PC_add_4_in;
			DataBusA_out <= DataBusA_in;
			DataBusB_out <= DataBusB_in;
			LUOut_out <= LUOut_in;
			Rs_out <= Rs_in;
			Rt_out <= Rt_in;
			Rd_out <= Rd_in;
			Shamt_out <= Shamt_in;
			RegDst_out <= RegDst_in;
			PCSrc_out <= PCSrc_in;
			MemRead_out <= MemRead_in;
			MemWrite_out <= MemWrite_in;
			MemToReg_out <= MemToReg_in;
			ALUFun_out <= ALUFun_in;
			ALUSrc1_out <= ALUSrc1_in;
			ALUSrc2_out <= ALUSrc2_in;
			RegWrite_out <= RegWrite_in;
			Sign_out <= Sign_in;
		end
	end
end

endmodule