module ALU(A, B, ALUFun, Sign, Z);
input Sign;
input [5:0] ALUFun;
input [31:0] A, B;
output [31:0] Z;
wire zero,neg;
wire [31:0] S0, S1, S2, S3;
  
AddSub AddSub(.A(A), .B(B), .ALUFun(ALUFun), .Sign(Sign), .Z(zero), .N(neg), .S(S0));
Cmp Cmp(.ALUFun(ALUFun), .Sign(Sign), .Z(zero), .N(neg), .S(S1));
Logic Logic(.A(A), .B(B), .ALUFun(ALUFun), .S(S2));
Shift Shift(.A(A), .B(B), .ALUFun(ALUFun), .S(S3));

assign Z =
(ALUFun[5:4] == 2'b00)? S0:
(ALUFun[5:4] == 2'b10)? S3:
(ALUFun[5:4] == 2'b01)? S2: S1;

endmodule



module AddSub(A, B, ALUFun, Sign, Z, N, S);
input Sign;
input [5:0] ALUFun;
input [31:0] A, B;
output Z, N;
output [32:0] S;

assign Z =
(ALUFun[3] && |A)? 0: 
(~ALUFun[3] && |S)? 0: 1;
assign S = 
(ALUFun[0])? ({1'b0, A} - {1'b0, B}): ({1'b0, A} + {1'b0, B});
assign N = 
(ALUFun[3] && Sign && A[31])? 1:
(~ALUFun[3] && Sign && S[31])? 1:
(~ALUFun[3] && ~Sign && S[32])? 1: 0;

endmodule



module Cmp(ALUFun, Sign, Z, N, S);
input Sign, Z, N;
input [5:0] ALUFun;
output [31:0] S;

assign S[0] = 
(ALUFun[3:1] == 3'b001)? Z:
(ALUFun[3:1] == 3'b000)? ~Z:
(ALUFun[3:1] == 3'b010)? N:
(ALUFun[3:1] == 3'b110)? (N || Z):
(ALUFun[3:1] == 3'b101)? N: (~N && ~Z);
assign S[31:1]=0;

endmodule



module Logic(A, B, ALUFun, S);
input [5:0] ALUFun;
input [31:0] A, B;
output [31:0] S;

assign S = 
(ALUFun[3:0] == 4'b0001)? ~(A | B):
(ALUFun[3:0] == 4'b1110)? (A | B):
(ALUFun[3:0] == 4'b1000)? (A & B):
(ALUFun[3:0] == 4'b0110)? (A ^ B): A;

endmodule



module Shift(A, B, ALUFun, S);
input [5:0] ALUFun;
input [31:0] A, B; 
output [31:0] S;

assign S =
(ALUFun[1:0] == 2'b01 || (ALUFun[1:0] == 2'b11 && B[31] == 0))? B >> A[4:0]:
(ALUFun[1:0] == 2'b11 && B[31] == 1)? ({32'hFFFFFFFF, B} >> A[4:0]):
(ALUFun[1:0] == 2'b00)? B << A[4:0]: 0;

endmodule