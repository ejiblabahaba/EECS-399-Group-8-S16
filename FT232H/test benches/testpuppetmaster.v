`timescale 1 ps / 1 ps

module testpuppetmaster(
	input clk50,
	input clk60,
	input [1:0] CMD,
	output reg d
);
	
	always @(posedge clk50) begin
		d <= clk60 | (CMD[0] & CMD[1]);
	end
endmodule
