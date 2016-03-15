module freq_counter(
	input [3:0] KEYS,
	input clk,
	output [27:0] FREQ,
	output [6:0] HEX_0,
	output [6:0] HEX_1,
	output [6:0] HEX_2,
	output [6:0] HEX_3,
	output [6:0] HEX_4,
	output [6:0] HEX_5
);
	wire [3:0] keys_inv;
	wire [27:0] f;
	wire [5:0] dispSel;
	
	invert_bus inv(KEYS,keys_inv);
	deadSimpleController dsc(clk,keys_inv,f,dispSel);
	hex_ssd HEX(f[3:0],f[7:4],f[11:8],f[15:12],
					f[19:16],f[23:20],dispSel,HEX_0,HEX_1,HEX_2,HEX_3,HEX_4,
					HEX_5);
	assign FREQ = f;
endmodule
