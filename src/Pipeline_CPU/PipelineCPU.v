`timescale 1ns/1ps

module PipelineCPU(reset, sysclk, UART_RX, UART_TX, switch, led, digi_1, digi_2, digi_3, digi_4);

/************************IO*************************/
input reset, sysclk, UART_RX;
input [7:0] switch;
output UART_TX;
output [7:0] led;
output [6:0] digi_1, digi_2, digi_3, digi_4;

wire irq, per_irq, rx_irq, tx_irq;
wire [11:0] digi;
wire [31:0] memRdData;
wire [31:0] periRdData;
wire [31:0] uartRdData;
wire [31:0] ReadData;
wire [31:0] WriteData;
wire [31:0] MemAddr;
wire MemRead;
wire MemWrite;
/************************Clk*************************/
wire clk;
assign clk = sysclk;

/************************Core*************************/
Pipeline_Core Pipeline_Core_1(.clk(clk), .reset(reset), .MemAddr(MemAddr), .WriteData(WriteData), 
	.ReadData(ReadData), .MemWrite(MemWrite), .MemRead(MemRead), .IRQ_in(irq));

/***********************Peripheral********************/
DataMem DataMem_1(.reset(reset), .clk(clk), .rd(MemRead), .wr(MemWrite), .addr(MemAddr), .wdata(WriteData), .rdata(memRdData));

assign irq = per_irq | rx_irq | tx_irq;
assign ReadData = memRdData | periRdData | uartRdData;
Peripheral Peripheral_1(.reset(reset), .clk(clk), .rd(MemRead), .wr(MemWrite), .addr(MemAddr), .wdata(WriteData), .rdata(periRdData), .led(led), .switch(switch), .digi(digi), .irqout(per_irq));
Digitube_scan Digitube_scan(.digi_in(digi), .digi_out1(digi_1), .digi_out2(digi_2), .digi_out3(digi_3), .digi_out4(digi_4));
UART UART_1(.reset(reset), .sysclk(sysclk), .clk(clk), .rd(MemRead), .wr(MemWrite), .addr(MemAddr), .wdata(WriteData), .rdata(uartRdData), .UART_RX(UART_RX), .UART_TX(UART_TX), .RX_IRQ(rx_irq), .TX_IRQ(tx_irq));

endmodule