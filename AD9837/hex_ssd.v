module hex_ssd(
	input [3:0] i_HEX0,
	input [3:0] i_HEX1,
	input [3:0] i_HEX2,
	input [3:0] i_HEX3,
	input [3:0] i_HEX4,
	input [3:0] i_HEX5,
	input [5:0] dispSel,
	output [6:0] o_HEX0,
	output [6:0] o_HEX1,
	output [6:0] o_HEX2,
	output [6:0] o_HEX3,
	output [6:0] o_HEX4,
	output [6:0] o_HEX5
);
	wire [41:0] w_HEX;
	
	sevenSegDisplay d_HEX0(i_HEX0,w_HEX[6:0]);
	sevenSegDisplay d_HEX1(i_HEX1,w_HEX[13:7]);
	sevenSegDisplay d_HEX2(i_HEX2,w_HEX[20:14]);
	sevenSegDisplay d_HEX3(i_HEX3,w_HEX[27:21]);
	sevenSegDisplay d_HEX4(i_HEX4,w_HEX[34:28]);
	sevenSegDisplay d_HEX5(i_HEX5,w_HEX[41:35]);
	
	assign o_HEX0 = w_HEX[6:0]   | {7{dispSel[0]}};
	assign o_HEX1 = w_HEX[13:7]  | {7{dispSel[1]}};
	assign o_HEX2 = w_HEX[20:14] | {7{dispSel[2]}};
	assign o_HEX3 = w_HEX[27:21] | {7{dispSel[3]}};
	assign o_HEX4 = w_HEX[34:28] | {7{dispSel[4]}};
	assign o_HEX5 = w_HEX[41:35] | {7{dispSel[5]}};
	
endmodule
