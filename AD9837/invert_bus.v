module invert_bus
	#(parameter width=4)
	(input [width-1:0] in,
	output [width-1:0] out
);
	assign out = ~in;
endmodule
