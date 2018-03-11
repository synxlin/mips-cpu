module CPU_clk (sysclk, reset, clk);
input sysclk, reset;
output reg clk;

// Frequency Divider
always @(posedge sysclk or negedge reset) begin
	if(~reset)
		clk <= 0;
	else
		clk <= ~clk;
end

endmodule