`timescale 1 ps / 1 ps

module ser32to8(
	input RSTn,
	input clk50,
	input [31:0] din,
	input good,
	output reg [7:0] q,
	output reg wrreqout,
	input wrfullout,
	input cmdgate
);
	reg [2:0] frame;
	wire newframe;
	
	assign newframe = (frame < 4) & good;
	
	initial begin
		q = 0;
		wrreqout = 0;
		frame = 0;
	end
	
	always @(negedge RSTn, negedge clk50) begin
		if (~RSTn) begin
			wrreqout <= 0;
			q <= 0;
			frame <= 0;
		end else begin
			if (cmdgate & (newframe & ~wrfullout)) begin
				wrreqout <= 1;
			end else begin
				wrreqout <= 0;
			end
			if (cmdgate & newframe) begin
				case (frame)
					2'b00: q <= din[7:0];
					2'b01: q <= din[15:8];
					2'b10: q <= din[23:16];
					2'b11: q <= din[31:24];
					default: q <= 0;
				endcase
				frame <= frame + 1;
			end else if (~good) begin
				frame <= 2'b00;
			end
		end
	end
endmodule 