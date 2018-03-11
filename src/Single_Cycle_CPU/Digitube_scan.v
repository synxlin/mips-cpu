`timescale 1ns/1ps

//For Altera DE2: Trans non-scanning Digital tube to scanning Digital tube

module Digitube_scan(digi_in,digi_out1,digi_out2,digi_out3,digi_out4);
input [11:0] digi_in;	//AN3,AN2,AN1,AN0,DP,CG,CF,CE,CD,CC,CB,CA
output [6:0] digi_out1;	//0: CG,CF,CE,CD,CC,CB,CA
output [6:0] digi_out2;	//1: CG,CF,CE,CD,CC,CB,CA
output [6:0] digi_out3;	//2: CG,CF,CE,CD,CC,CB,CA
output [6:0] digi_out4;	//3: CG,CF,CE,CD,CC,CB,CA

assign digi_out1 = (digi_in[11:8] == 4'b0001) ? digi_in[6:0] : 7'b111_1111;
assign digi_out2 = (digi_in[11:8] == 4'b0010) ? digi_in[6:0] : 7'b111_1111;
assign digi_out3 = (digi_in[11:8] == 4'b0100) ? digi_in[6:0] : 7'b111_1111;
assign digi_out4 = (digi_in[11:8] == 4'b1000) ? digi_in[6:0] : 7'b111_1111;

endmodule

