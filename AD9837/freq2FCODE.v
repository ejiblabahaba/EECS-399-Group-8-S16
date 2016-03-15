module freq2FCODE(
	input [19:0] freq,
	output [27:0] FCODE
);
	assign FCODE = {freq,28'h000_0000}/16_000_000;
endmodule