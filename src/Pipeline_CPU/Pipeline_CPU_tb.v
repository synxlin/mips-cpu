`timescale 1ns/1ns

module baudrate_generator(sysclk, reset, brclk, brclk16);
input sysclk,reset;
output reg brclk, brclk16;
reg [11:0] cnt;
reg [7:0] cnt16;

always @(posedge sysclk or negedge reset)
begin
	if(~reset) begin
		cnt <= 12'd0;
		cnt16 <= 8'd0;
		brclk <= 1;
		brclk16 <= 1;
	end
	else begin
		if(cnt16 == 8'd162) begin
			cnt16 <= 8'd0;
			brclk16 <= ~brclk16;
			end
		else
			cnt16 <= cnt16 + 8'd1;
		if(cnt == 12'd2603) begin
			cnt <= 12'd0;
			brclk <= ~brclk;
			end
		else
			cnt <= cnt + 12'd1;
	end
end

endmodule



module CPU_tb;
reg reset, sysclk;
reg [7:0] switch;
reg [36:0] tmprx;
wire UART_RX, UART_TX, brclk9600, brclk153600;
wire [7:0] led;
wire [6:0] digi_1;
wire [6:0] digi_2;
wire [6:0] digi_3;
wire [6:0] digi_4;

initial begin
	reset <= 0;
	sysclk <= 0;
	reset <= 0;
	switch <= 8'b01001010;
	tmprx <= 37'b11_0_0000_0101_1_0_0001_1001_1111_1111_1111_1111;
end
	
initial fork
	#13 reset <= 1;
	forever #10 sysclk = ~sysclk;
join

baudrate_generator baudrate_generator_1(.sysclk(sysclk), .reset(reset), .brclk(brclk9600), .brclk16(brclk153600));

always @(posedge brclk9600)
begin
	tmprx <= tmprx<<1;
end

assign UART_RX = tmprx[36];
	
PipelineCPU PipelineCPU_1(reset, sysclk, UART_RX, UART_TX, switch, led, digi_1, digi_2, digi_3, digi_4);

endmodule