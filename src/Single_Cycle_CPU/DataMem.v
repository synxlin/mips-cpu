`timescale 1ns/1ps

module DataMem (reset,clk,rd,wr,addr,wdata,rdata);
input reset,clk;
input rd,wr;
input [31:0] addr;	//Address Must be Word Aligned
input [31:0] wdata;
output [31:0] rdata;

parameter RAM_SIZE = 256;
reg [31:0] RAMDATA [RAM_SIZE-1:0];

assign rdata = (rd && (addr[31:2] < RAM_SIZE)) ? RAMDATA[addr[31:2]] : 32'b0;

always@(posedge clk) begin
	if(wr && (addr[31:2] < RAM_SIZE))
		RAMDATA[addr[31:2]] <= wdata;
end

endmodule