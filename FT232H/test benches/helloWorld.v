`timescale 1 ps/ 1 ps

module helloWorld(
	input clk,
	input rst_n,
	input wrfull,
	output reg wrreq,
	output reg [7:0] data
);
	// "H" = 0x48; "E" = 0x45; "L" = 0x4C; "O" = 0x4F; " " = 0x20;
	// "W" = 0x57; "R" = 0x52; "D" = 0x44; "!" = 0x21; \0  = 0x00;
	reg [3:0] count = 0;
	initial begin
		wrreq = 0;
	end
	always @(negedge clk, negedge rst_n) begin
		if (~rst_n) begin
			count <= 0;
		end else begin
			case (count)
				4'h0: data <= 8'h48;
				4'h1: data <= 8'h45;
				4'h2: data <= 8'h4c;
				4'h3: data <= 8'h4c;
				4'h4: data <= 8'h4f;
				4'h5: data <= 8'h20;
				4'h6: data <= 8'h57;
				4'h7: data <= 8'h4f;
				4'h8: data <= 8'h52;
				4'h9: data <= 8'h4c;
				4'ha: data <= 8'h44;
				4'hb: data <= 8'h21;
				4'hc: data <= 8'h00;
				default: data <= 8'he6;
			endcase
			if (rst_n & ~(wrfull | (count > 12))) begin
				wrreq <= 1;
				count <= count + 1;
			end else begin
				wrreq <= 0;
			end
		end
	end
endmodule
