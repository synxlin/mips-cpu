module UART_Receiver(uart_rx, sysclk, rx_data, rx_status, rx_LoadFinish, reset);
input uart_rx, rx_LoadFinish, sysclk, reset;
output reg [7:0] rx_data;
output reg rx_status;

reg [3:0] cnt_catch;	// Sampling count
reg [4:0] cnt_clk;		// Count 153600Hz Clock to generate 9600Hz
reg status;				// Status of Receiver, 0 - idle & start bit, 1- busy
reg [8:0] brcnt16;		// Count sysclk to generate 153600Hz

always @(posedge sysclk or negedge reset)
begin
	if(~reset) begin
		brcnt16 <= 9'd0;
		cnt_catch <= 4'd0;
		cnt_clk <= 5'd0;
		status <= 0;
		rx_status <= 0;
		rx_data <= 8'd0;
		end
	else begin
		if(~status) begin
			if(rx_LoadFinish)
				rx_status <= 0;
			if(~uart_rx) begin
				if(cnt_clk==5'd8) begin
					cnt_clk <= 5'd0;
					status <= 1;
					brcnt16 <= 9'd0;
					end
				else begin
					if (brcnt16 == 9'd325) begin
						brcnt16 <= 9'd0;
						cnt_clk <= cnt_clk + 1;
						end
					else
						brcnt16 <= brcnt16 + 1;
				end
			end
		end
		else begin
			if(cnt_catch==4'd9) begin
				cnt_catch <= 4'd0;
				status <= 0;
				brcnt16 <= 9'd0;
				cnt_clk <= 5'd0;
				rx_status <= 1;
				end
			else begin
				if(cnt_clk == 5'd16) begin
					cnt_clk <= 5'd0;
					brcnt16 <= 9'd0;
					cnt_catch <= cnt_catch+1;
					if (cnt_catch < 4'd8)
						rx_data[cnt_catch]<=uart_rx;
					end
				else begin
					if(brcnt16 == 9'd325) begin
						brcnt16 <= 9'd0;
						cnt_clk <= cnt_clk + 1;
						end
					else
						brcnt16 <= brcnt16 + 1;
				end
			end
		end
	end
end

endmodule


module UART_Sender(tx_data, tx_en, sysclk, tx_status, uart_tx, reset);

input [7:0] tx_data;
input tx_en, sysclk, reset;
output reg tx_status, uart_tx;

reg [3:0] cnt;			// Count bit
reg [9:0] tmp_data;		// Buffer to save data temporily
reg [12:0] brcnt;		// Count sysclk to generate 9600Hz Clock

always @(posedge sysclk or negedge reset)
begin
	if (~reset) begin
		tx_status <= 1'b1;
		uart_tx <= 1'b1;
		cnt <= 4'd0;
		end
	else begin
		if(tx_status) begin
			uart_tx <= 1'b1;
			cnt <= 4'd0;
			brcnt <= 13'd5208;
			if(tx_en) begin
				tmp_data[0] <= 1'b0;
				tmp_data[8:1] <= tx_data;
				tmp_data[9] <= 1'b1;
				tx_status <= 1'b0;
				end
			end
		else begin
			if(brcnt == 13'd5208) begin
				brcnt <= 13'd0;
				if (cnt==4'd10) begin
					cnt <= 4'd0;
					tx_status <= 1'b1;
					end
				else
					uart_tx <= tmp_data[cnt];
					cnt <= cnt + 1;
			end
			else
				brcnt <= brcnt + 12'd1;
		end
	end
end

endmodule

module UART(reset, sysclk, clk, rd, wr, addr, wdata, rdata, UART_RX, UART_TX, RX_IRQ, TX_IRQ);
input sysclk, reset, clk, rd, wr, UART_RX;
input [31:0] addr, wdata;
output UART_TX, RX_IRQ, TX_IRQ;
output reg [31:0] rdata;
wire rx_status, tx_status, tx_over;
wire[7:0] rx_data;
reg[7:0] UART_RXD, UART_TXD;
reg[4:0] UART_CON;
reg tx_en; 

// Read Data
always @(*) begin
	if(rd) begin
		case(addr)
			32'h4000_0018: rdata = {24'd0, UART_TXD};
			32'h4000_001c: rdata = {24'd0, UART_RXD};
			32'h4000_0020: rdata = {27'd0, UART_CON};
			default: rdata = 32'd0;
		endcase
	end
	else
		rdata = 32'd0;
end

always @(posedge clk or negedge reset) begin
	if(~reset) begin
		UART_RXD <= 8'd0;
		UART_TXD <= 8'd0;
		UART_CON <= 5'd0;
		tx_en <= 0;
	end
	else begin
		
		// After receive the data
		if(rx_status) begin
			UART_RXD <= rx_data;
			UART_CON[3] <= 1'b1;
		end
		
		// After send the data
		if(UART_CON[4] && tx_status) begin
			UART_CON[2] <= 1'b1;
		end
		UART_CON[4] <= ~tx_status;
		
		// After read UART_CON
		if(rd && (addr == 32'h4000_0020)) begin
			UART_CON[2] <= 1'b0;
			UART_CON[3] <= 1'b0;
		end
		
		// Write Data
		if(wr) begin
			case(addr)
				32'h4000_0018: begin
					UART_TXD <= wdata[7:0];
					tx_en <= 1;
				end
				32'h4000_0020: UART_CON[1:0] <= wdata[1:0];
				default: ;
			endcase
		end
		if(tx_en)
			tx_en <= 0;
	end
end

// Set Interrupt
assign RX_IRQ = UART_CON[1] && UART_CON[3];
assign TX_IRQ = UART_CON[0] && UART_CON[2];

UART_Receiver UART_Receiver_1(.uart_rx(UART_RX), .sysclk(sysclk), .rx_data(rx_data), .rx_status(rx_status), .rx_LoadFinish(UART_CON[3]), .reset(reset));

UART_Sender UART_Sender_1(.tx_data(UART_TXD), .tx_en(tx_en), .sysclk(sysclk), .tx_status(tx_status), .uart_tx(UART_TX), .reset(reset));

endmodule