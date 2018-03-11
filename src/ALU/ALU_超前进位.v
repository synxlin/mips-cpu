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
wire [31:0] S1,S2;
wire Co1, Co2;
adder_32 adder_32_1(A,B,S1,1'b0,Co1);
adder_32 adder_32_2(A,~B,S2,1'b0,Co2);


assign Z =
(ALUFun[3] && |A)? 0: 
(~ALUFun[3] && |S)? 0: 1;


assign S = 
(ALUFun[0])? ({Co2,S2}): ({Co1,S1});
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

module adder_32(a,b,s,cin,cout);
input [31:0]a,b;
input cin;
output [31:0]s;
output cout;


adder_16 adder_16_1 (a[15:0],b[15:0],s[15:0],cin,co1);
adder_16 adder_16_2 (a[31:16],b[31:16],s[31:16],co1,cout);

endmodule


module adder_16 (a,b,s,cin,gg5);
input [15:0] a, b;
input cin;
output [15:0] s;
output gg5;

wire pp4, pp3, pp2, pp1;
wire gg4, gg3, gg2, gg1;
wire [14:0] Cp;
wire [15:0] p, g;


claslice i1 (p[3], p[2], p[1], p[0], g[3], g[2], g[1], g[0], cin, Cp[2], Cp[1], Cp[0], pp1, gg1);
claslice i2 (p[7], p[6], p[5], p[4], g[7], g[6], g[5], g[4], Cp[3], Cp[6], Cp[5], Cp[4], pp2, gg2);
claslice i3 (p[11], p[10], p[9], p[8], g[11], g[10], g[9], g[8], Cp[7], Cp[10], Cp[9], Cp[8], pp3, gg3);
claslice i4 (p[15], p[14], p[13], p[12], g[15], g[14], g[13], g[12], Cp[11], Cp[14], Cp[13], Cp[12], pp4, gg4);
claslice i5 (pp4, pp3, pp2, pp1, gg4, gg3, gg2, gg1, cin, Cp[11], Cp[7], Cp[3], pp5, gg5);

pg i0(a[15:0], b[15:0], p[15:0], g[15:0]);

assign s[0] = p[0] ^ cin;
assign s[1] = p[1] ^ Cp[0];
assign s[2] = p[2] ^ Cp[1];
assign s[3] = p[3] ^ Cp[2];
assign s[4] = p[4] ^ Cp[3];
assign s[5] = p[5] ^ Cp[4];
assign s[6] = p[6] ^ Cp[5];
assign s[7] = p[7] ^ Cp[6];
assign s[8] = p[8] ^ Cp[7];
assign s[9] = p[9] ^ Cp[8];
assign s[10] = p[10] ^ Cp[9];
assign s[11] = p[11] ^ Cp[10];
assign s[12] = p[12] ^ Cp[11];
assign s[13] = p[13] ^ Cp[12];
assign s[14] = p[14] ^ Cp[13];
assign s[15] = p[15] ^ Cp[14];

endmodule

module claslice(p[3], p[2], p[1], p[0], g[3], g[2], g[1], g[0], Co, Cp[2], Cp[1], Cp[0], pp, gg);

input [3:0] p,  g;
input Co;
output [2:0] Cp;
output pp, gg;
assign Cp[0] = g[0] | p[0] & Co;
assign Cp[1] = g[1] | p[1] & Cp[0];
assign Cp[2] = g[2] | p[2] & Cp[1];
assign pp = p[3] & p[2] & p[1] & p[0];
assign gg = g[3] | (p[3] & (g[2] | p[2] & (g[1] | p[1] & g[0])));
endmodule

module pg(a, b, p, g);
input [15:0] a, b;
output [15:0] p, g;
assign p = a ^ b;
assign g = a & b;
endmodule

