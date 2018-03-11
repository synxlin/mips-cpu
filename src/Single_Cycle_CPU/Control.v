module Control(Instruct, IRQ, PC31, PCSrc, RegWr, RegDst, MemRd, MemWr, MemToReg, ALUSrc1, ALUSrc2, EXTOp, LUOp, ALUFun, Sign);
input [31:0] Instruct;
input IRQ, PC31;
output reg [2:0] PCSrc;
output reg RegWr;
output reg [1:0] RegDst;
output reg MemRd;
output reg MemWr;
output reg [1:0] MemToReg;
output reg ALUSrc1;
output reg ALUSrc2;
output reg EXTOp;
output reg LUOp;
output reg [5:0] ALUFun;
output reg Sign;

always @(*) begin

/*	Default Set
	PCSrc = 3'd0;
	RegWr = 0;
	RegDst = 2'd0;
	MemRd = 0;
	MemWr = 0;
	MemToReg = 2'd0;
	ALUSrc1 = 0;
	ALUSrc2 = 0;
	ALUFun = 6'b000000;
	Sign = 1;
	EXTOp = 1;
	LUOp = 0;
*/
	
	if(~IRQ) begin
		case(Instruct[31:26])
			6'b10_0011: begin	//lw 0x23
				PCSrc = 3'd0;
				RegWr = 1;
				RegDst = 2'd1;
				MemRd = 1;
				MemWr = 0;
				MemToReg = 2'd1;
				ALUSrc1 = 0;
				ALUSrc2 = 1;
				ALUFun = 6'b000000;
				Sign = 1;
				EXTOp = 1;
				LUOp = 0;
			end
			6'b10_1011: begin	//sw 0x2b
				PCSrc = 3'd0;
				RegWr = 0;
				RegDst = 2'd0;
				MemRd = 0;
				MemWr = 1;
				MemToReg = 2'd0;
				ALUSrc1 = 0;
				ALUSrc2 = 1;
				ALUFun = 6'b000000;
				Sign = 1;
				EXTOp = 1;
				LUOp = 0;
			end			
			6'b00_1111: begin	//lui 0x0f
				PCSrc = 3'd0;
				RegWr = 1;
				RegDst = 2'd1;
				MemRd = 0;
				MemWr = 1;
				MemToReg = 2'd0;
				ALUSrc1 = 0;
				ALUSrc2 = 1;
				ALUFun = 6'b011110;
				Sign = 1;
				EXTOp = 1;
				LUOp = 1;
			end
			6'b00_1000: begin	//addi 0x08
				PCSrc = 3'd0;
				RegWr = 1;
				RegDst = 2'd1;
				MemRd = 0;
				MemWr = 0;
				MemToReg = 2'd0;
				ALUSrc1 = 0;
				ALUSrc2 = 1;
				ALUFun = 6'b000000;
				Sign = 1;
				EXTOp = 1;
				LUOp = 0;
			end
			6'b00_1001: begin	//addiu 0x09
				PCSrc = 3'd0;
				RegWr = 1;
				RegDst = 2'd1;
				MemRd = 0;
				MemWr = 0;
				MemToReg = 2'd0;
				ALUSrc1 = 0;
				ALUSrc2 = 1;
				ALUFun = 6'b000000;
				Sign = 1;
				EXTOp = 1;
				LUOp = 0;
			end
			6'b00_1100: begin	//andi 0x0c
				PCSrc = 3'd0;
				RegWr = 1;
				RegDst = 2'd1;
				MemRd = 0;
				MemWr = 0;
				MemToReg = 2'd0;
				ALUSrc1 = 0;
				ALUSrc2 = 1;
				ALUFun = 6'b011000;
				Sign = 1;
				EXTOp = 0;
				LUOp = 0;
			end
			/*
			6'b00_1101: begin	//ori 0x0d
				PCSrc = 3'd0;
				RegWr = 1;
				RegDst = 2'd1;
				MemRd = 0;
				MemWr = 0;
				MemToReg = 2'd0;
				ALUSrc1 = 0;
				ALUSrc2 = 1;
				ALUFun = 6'b011110;
				Sign = 1;
				EXTOp = 0;
				LUOp = 0;
			end
			*/
			6'b00_1010: begin	//slti 0x0a
				PCSrc = 3'd0;
				RegWr = 1;
				RegDst = 2'd1;
				MemRd = 0;
				MemWr = 0;
				MemToReg = 2'd0;
				ALUSrc1 = 0;
				ALUSrc2 = 1;
				ALUFun = 6'b110101;
				Sign = 1;
				EXTOp = 1;
				LUOp = 0;
			end
			6'b00_1011: begin	//sltiu 0x0b
				PCSrc = 3'd0;
				RegWr = 1;
				RegDst = 2'd1;
				MemRd = 0;
				MemWr = 0;
				MemToReg = 2'd0;
				ALUSrc1 = 0;
				ALUSrc2 = 1;
				ALUFun = 6'b110101;
				Sign = 0;
				EXTOp = 1;
				LUOp = 0;
			end
			6'b00_0100: begin	//beq 0x04
				PCSrc = 3'd1;
				RegWr = 0;
				RegDst = 2'd0;
				MemRd = 0;
				MemWr = 0;
				MemToReg = 2'd0;
				ALUSrc1 = 0;
				ALUSrc2 = 0;
				ALUFun = 6'b110011;
				Sign = 1;
				EXTOp = 1;
				LUOp = 0;
			end
			6'b00_0101: begin	//bne 0x05
				PCSrc = 3'd1;
				RegWr = 0;
				RegDst = 2'd0;
				MemRd = 0;
				MemWr = 0;
				MemToReg = 2'd0;
				ALUSrc1 = 0;
				ALUSrc2 = 0;
				ALUFun = 6'b110001;
				Sign = 1;
				EXTOp = 1;
				LUOp = 0;
			end
			6'b00_0110: begin	//blez 0x06
				PCSrc = 3'd1;
				RegWr = 0;
				RegDst = 2'd0;
				MemRd = 0;
				MemWr = 0;
				MemToReg = 2'd0;
				ALUSrc1 = 0;
				ALUSrc2 = 0;
				ALUFun = 6'b111101;
				Sign = 1;
				EXTOp = 1;
				LUOp = 0;
			end
			6'b00_0111: begin	//bgtz 0x07
				PCSrc = 3'd1;
				RegWr = 0;
				RegDst = 2'd0;
				MemRd = 0;
				MemWr = 0;
				MemToReg = 2'd0;
				ALUSrc1 = 0;
				ALUSrc2 = 0;
				ALUFun = 6'b111111;
				Sign = 1;
				EXTOp = 1;
				LUOp = 0;
			end
			6'b00_0001: begin	//bltz 0x01
				PCSrc = 3'd1;
				RegWr = 0;
				RegDst = 2'd0;
				MemRd = 0;
				MemWr = 0;
				MemToReg = 2'd0;
				ALUSrc1 = 0;
				ALUSrc2 = 0;
				ALUFun = 6'b111011;
				Sign = 1;
				EXTOp = 1;
				LUOp = 0;
			end
			6'b00_0010: begin	//j 0x02
				PCSrc = 3'd2;
				RegWr = 0;
				RegDst = 2'd0;
				MemRd = 0;
				MemWr = 0;
				MemToReg = 2'd0;
				ALUSrc1 = 0;
				ALUSrc2 = 0;
				ALUFun = 6'b000000;
				Sign = 1;
				EXTOp = 1;
				LUOp = 0;
			end
			6'b00_0011: begin	//jal 0x03
				PCSrc = 3'd2;
				RegWr = 1;
				RegDst = 2'd2;
				MemRd = 0;
				MemWr = 0;
				MemToReg = 2'd2;
				ALUSrc1 = 0;
				ALUSrc2 = 0;
				ALUFun = 6'b000000;
				Sign = 1;
				EXTOp = 1;
				LUOp = 0;
			end
			6'b00_0000: begin	//R型 0x00
				case(Instruct[5:0])
					6'b10_0000: begin	//add 0x20
						PCSrc = 3'd0;
						RegWr = 1;
						RegDst = 2'd0;
						MemRd = 0;
						MemWr = 0;
						MemToReg = 2'd0;
						ALUSrc1 = 0;
						ALUSrc2 = 0;
						ALUFun = 6'b000000;
						Sign = 1;
						EXTOp = 1;
						LUOp = 0;
					end
					6'b10_0001: begin	//addu 0x21
						PCSrc = 3'd0;
						RegWr = 1;
						RegDst = 2'd0;
						MemRd = 0;
						MemWr = 0;
						MemToReg = 2'd0;
						ALUSrc1 = 0;
						ALUSrc2 = 0;
						ALUFun = 6'b000000;
						Sign = 1;
						EXTOp = 1;
						LUOp = 0;
					end
					6'b10_0010: begin	//sub 0x22
						PCSrc = 3'd0;
						RegWr = 1;
						RegDst = 2'd0;
						MemRd = 0;
						MemWr = 0;
						MemToReg = 2'd0;
						ALUSrc1 = 0;
						ALUSrc2 = 0;
						ALUFun = 6'b000001;
						Sign = 1;
						EXTOp = 1;
						LUOp = 0;
					end
					6'b10_0011: begin	//subu 0x23
						PCSrc = 3'd0;
						RegWr = 1;
						RegDst = 2'd0;
						MemRd = 0;
						MemWr = 0;
						MemToReg = 2'd0;
						ALUSrc1 = 0;
						ALUSrc2 = 0;
						ALUFun = 6'b000001;
						Sign = 1;
						EXTOp = 1;
						LUOp = 0;
					end
					6'b10_0100: begin	//and 0x24
						PCSrc = 3'd0;
						RegWr = 1;
						RegDst = 2'd0;
						MemRd = 0;
						MemWr = 0;
						MemToReg = 2'd0;
						ALUSrc1 = 0;
						ALUSrc2 = 0;
						ALUFun = 6'b011000;
						Sign = 1;
						EXTOp = 1;
						LUOp = 0;
					end
					6'b10_0101: begin	//or 0x25
						PCSrc = 3'd0;
						RegWr = 1;
						RegDst = 2'd0;
						MemRd = 0;
						MemWr = 0;
						MemToReg = 2'd0;
						ALUSrc1 = 0;
						ALUSrc2 = 0;
						ALUFun = 6'b011110;
						Sign = 1;
						EXTOp = 1;
						LUOp = 0;
					end
					6'b10_0110: begin	//xor 0x26
						PCSrc = 3'd0;
						RegWr = 1;
						RegDst = 2'd0;
						MemRd = 0;
						MemWr = 0;
						MemToReg = 2'd0;
						ALUSrc1 = 0;
						ALUSrc2 = 0;
						ALUFun = 6'b010110;
						Sign = 1;
						EXTOp = 1;
						LUOp = 0;
					end
					6'b10_0111: begin	//nor 0x27
						PCSrc = 3'd0;
						RegWr = 1;
						RegDst = 2'd0;
						MemRd = 0;
						MemWr = 0;
						MemToReg = 2'd0;
						ALUSrc1 = 0;
						ALUSrc2 = 0;
						ALUFun = 6'b010001;
						Sign = 1;
						EXTOp = 1;
						LUOp = 0;
					end
					6'b00_0000: begin	//sll 0x00
						PCSrc = 3'd0;
						RegWr = 1;
						RegDst = 2'd0;
						MemRd = 0;
						MemWr = 0;
						MemToReg = 2'd0;
						ALUSrc1 = 1;
						ALUSrc2 = 0;
						ALUFun = 6'b100000;
						Sign = 1;
						EXTOp = 1;
						LUOp = 0;
					end
					6'b00_0010: begin	//srl 0x02
						PCSrc = 3'd0;
						RegWr = 1;
						RegDst = 2'd0;
						MemRd = 0;
						MemWr = 0;
						MemToReg = 2'd0;
						ALUSrc1 = 1;
						ALUSrc2 = 0;
						ALUFun = 6'b100001;
						Sign = 1;
						EXTOp = 1;
						LUOp = 0;
					end
					6'b00_0011: begin	//sra 0x03
						PCSrc = 3'd0;
						RegWr = 1;
						RegDst = 2'd0;
						MemRd = 0;
						MemWr = 0;
						MemToReg = 2'd0;
						ALUSrc1 = 1;
						ALUSrc2 = 0;
						ALUFun = 6'b100011;
						Sign = 1;
						EXTOp = 1;
						LUOp = 0;
					end
					6'b10_1010: begin	//slt 0x2a
						PCSrc = 3'd0;
						RegWr = 1;
						RegDst = 2'd0;
						MemRd = 0;
						MemWr = 0;
						MemToReg = 2'd0;
						ALUSrc1 = 0;
						ALUSrc2 = 0;
						ALUFun = 6'b110101;
						Sign = 1;
						EXTOp = 1;
						LUOp = 0;
					end
					/*
					6'b10_1011: begin	//sltu 0x2b
						PCSrc = 3'd0;
						RegWr = 1;
						RegDst = 2'd0;
						MemRd = 0;
						MemWr = 0;
						MemToReg = 2'd0;
						ALUSrc1 = 0;
						ALUSrc2 = 0;
						ALUFun = 6'b110101;
						Sign = 0;
						EXTOp = 1;
						LUOp = 0;
					end
					*/
					6'b00_1000: begin	//jr 0x08
						PCSrc = 3'd3;
						RegWr = 0;
						RegDst = 2'd0;
						MemRd = 0;
						MemWr = 0;
						MemToReg = 2'd0;
						ALUSrc1 = 0;
						ALUSrc2 = 0;
						ALUFun = 6'b000000;
						Sign = 1;
						EXTOp = 1;
						LUOp = 0;
					end
					6'b00_1001: begin	//jalr 0x09
						PCSrc = 3'd3;
						RegWr = 1;
						RegDst = 2'd0;
						MemRd = 0;
						MemWr = 0;
						MemToReg = 2'd2;
						ALUSrc1 = 0;
						ALUSrc2 = 0;
						ALUFun = 6'b000000;
						Sign = 1;
						EXTOp = 1;
						LUOp = 0;
					end
					default: begin	//exception
						if(~PC31) begin
							PCSrc = 3'd5;
							RegWr = 1;
							RegDst = 2'd3;
							MemRd = 0;
							MemWr = 0;
							MemToReg = 2'd2;
							ALUSrc1 = 0;
							ALUSrc2 = 0;
							ALUFun = 6'b000000;
							Sign = 1;
							EXTOp = 1;
							LUOp = 0;
						end
						else begin
							PCSrc = 3'd0;
							RegWr = 0;
							RegDst = 2'd0;
							MemRd = 0;
							MemWr = 0;
							MemToReg = 2'd0;
							ALUSrc1 = 0;
							ALUSrc2 = 0;
							ALUFun = 6'b000000;
							Sign = 1;
							EXTOp = 1;
							LUOp = 0;						
						end
					end
				endcase
			end
			default: begin	//exception
				if(~PC31) begin
					PCSrc = 3'd5;
					RegWr = 1;
					RegDst = 2'd3;
					MemRd = 0;
					MemWr = 0;
					MemToReg = 2'd2;
					ALUSrc1 = 0;
					ALUSrc2 = 0;
					ALUFun = 6'b000000;
					Sign = 1;
					EXTOp = 1;
					LUOp = 0;
				end
				else begin
					PCSrc = 3'd0;
					RegWr = 0;
					RegDst = 2'd0;
					MemRd = 0;
					MemWr = 0;
					MemToReg = 2'd0;
					ALUSrc1 = 0;
					ALUSrc2 = 0;
					ALUFun = 6'b000000;
					Sign = 1;
					EXTOp = 1;
					LUOp = 0;
				end
			end
		endcase
	end
	else begin	//Interruption
		PCSrc = 3'd4;
		RegWr = 1;
		RegDst = 2'd3;
		MemRd = 0;
		MemWr = 0;
		MemToReg = 2'd2;
		ALUSrc1 = 0;
		ALUSrc2 = 0;
		ALUFun = 6'b000000;
		Sign = 1;
		EXTOp = 1;
		LUOp = 0;
	end
end

endmodule