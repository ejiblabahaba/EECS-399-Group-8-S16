module debounce
	#(parameter clkFreq = 50_000_000,
					debounceDelay = 10)
(
	input clk,
	input in,
	output reg out
);
	
	reg [31:0] counter = 0;
	
	always @(posedge clk) begin
		if (in ^ out) begin
			counter <= counter + 1;
		end else begin
			counter <= 0;
		end
		
		if (counter > clkFreq/debounceDelay) begin
			out <= in;
		end
	end
endmodule	