module sevenSegDisplay(
	val,
	light
);
	
	input [3:0] val;
	
	output reg [6:0] light;
	// light bits from msb to lsb:
	// 6: middle
	// 5: top left
	// 4: bottom left
	// 3: bottom
	// 2: bottom right
	// 1: top right
	// 0: top
	
	always @(val) begin
		case (val)
			4'h0 : light <= 7'b1000000;
			4'h1 : light <= 7'b1111001;
			4'h2 : light <= 7'b0100100;
			4'h3 : light <= 7'b0110000;
			4'h4 : light <= 7'b0011001;
			4'h5 : light <= 7'b0010010;
			4'h6 : light <= 7'b0000010;
			4'h7 : light <= 7'b1111000;
			4'h8 : light <= 7'b0000000;
			4'h9 : light <= 7'b0010000;
			4'ha : light <= 7'b0001000;
			4'hb : light <= 7'b0000011;
			4'hc : light <= 7'b1000110;
			4'hd : light <= 7'b0100001;
			4'he : light <= 7'b0000110;
			4'hf : light <= 7'b0001110;
		endcase
	end

endmodule
