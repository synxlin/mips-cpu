module IF_ID_Reg(clk, reset, IF_ID_flush, ID_EX_flush, IF_ID_write, PC_add_4_in, Instruct_in,
	PC_add_4_out, Instruct_out);
	
input clk;
input reset;
input IF_ID_flush;
input ID_EX_flush;
input IF_ID_write;
input [31:0] PC_add_4_in;
input [31:0] Instruct_in;
output reg [31:0] PC_add_4_out;
output reg [31:0] Instruct_out;

always @(posedge clk or negedge reset) begin
	if (~reset) begin
		PC_add_4_out <= 32'h8000_0000;
		Instruct_out <= 32'h0000_0000;
	end
	else begin
		if(IF_ID_flush) begin
			// Here we do not flush PC to zeor to cope with IRQ hazard
			if(ID_EX_flush) begin
				PC_add_4_out <= PC_add_4_in - 8;
			end
			else begin
				PC_add_4_out <= PC_add_4_in - 4;
			end
			Instruct_out <= 32'h0000_0000;
		end
		else begin
			if (IF_ID_write) begin
				PC_add_4_out <= PC_add_4_in;
				Instruct_out <= Instruct_in;
			end
		end
	end
end

endmodule