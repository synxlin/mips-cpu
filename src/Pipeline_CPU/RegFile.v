`timescale 1ns/1ps

module RegFile (reset,clk,addr1,data1,addr2,data2,wr,addr3,data3);
input reset,clk;
input wr;
input [4:0] addr1,addr2,addr3;
output [31:0] data1,data2;
input [31:0] data3;

reg [31:0] RF_data[31:0];

assign data1 = RF_data[addr1];
assign data2 = RF_data[addr2];

always@(negedge reset or negedge clk) begin
	if(~reset) begin
		RF_data[0]<=32'b0;
		RF_data[1]<=32'b0;
		RF_data[2]<=32'b0;
		RF_data[3]<=32'b0;
		RF_data[4]<=32'b0;
		RF_data[5]<=32'b0;
		RF_data[6]<=32'b0;
		RF_data[7]<=32'b0;
		RF_data[8]<=32'b0;
		RF_data[9]<=32'b0;
		RF_data[10]<=32'b0;
		RF_data[11]<=32'b0;
		RF_data[12]<=32'b0;
		RF_data[13]<=32'b0;
		RF_data[14]<=32'b0;
		RF_data[15]<=32'b0;
		RF_data[16]<=32'b0;
		RF_data[17]<=32'b0;
		RF_data[18]<=32'b0;
		RF_data[19]<=32'b0;
		RF_data[20]<=32'b0;
		RF_data[21]<=32'b0;
		RF_data[22]<=32'b0;
		RF_data[23]<=32'b0;
		RF_data[24]<=32'b0;
		RF_data[25]<=32'b0;
		RF_data[26]<=32'b0;
		RF_data[27]<=32'b0;
		RF_data[28]<=32'b0;
		RF_data[29]<=32'b0;
		RF_data[30]<=32'b0;
		RF_data[31]<=32'b0;
	end
	else begin
		//$0 MUST be all zeros
		if(wr && (|addr3))
			RF_data[addr3] <= data3;
	end
end
endmodule
