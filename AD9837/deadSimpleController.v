module deadSimpleController(
	clk,
	buttons,
	number,
	dispSel
);
	input clk;
	input [3:0] buttons;
	output [27:0] number;
	output reg [5:0] dispSel;
	reg await = 0;
	reg [5:0] dispMask = 6'b000001;
	reg [23:0] acc = 0;
	reg [24:0] ctr = 0;
	reg [2:0] mul = 0;
	
	assign number = {4'b0000,acc};
	
	always @(posedge clk) begin
		if (~await) begin
			if (buttons == 4'b1000) begin
				if (dispMask == 6'b100000) begin
					dispMask <= 6'b000001;
					mul <= 0;
				end else begin
					dispMask <= dispMask << 1;
					mul <= mul + 3'b001;
				end
			end else if (buttons == 4'b0100) begin
				if (dispMask == 6'b000001) begin
					dispMask <= 6'b100000;
					mul <= 5;
				end else begin
					dispMask <= dispMask >> 1;
					mul <= mul - 3'b001;
				end
			end else if (buttons == 4'b0010) begin
				case (dispMask)
					6'b000001: acc <= acc + 24'h00_0001;
					6'b000010: acc <= acc + 24'h00_0010;
					6'b000100: acc <= acc + 24'h00_0100;
					6'b001000: acc <= acc + 24'h00_1000;
					6'b010000: acc <= acc + 24'h01_0000;
					6'b100000: acc <= acc + 24'h10_0000;
				endcase
			end else if (buttons == 4'b0001) begin
				case (dispMask)
					6'b000001: acc <= acc - 24'h00_0001;
					6'b000010: acc <= acc - 24'h00_0010;
					6'b000100: acc <= acc - 24'h00_0100;
					6'b001000: acc <= acc - 24'h00_1000;
					6'b010000: acc <= acc - 24'h01_0000;
					6'b100000: acc <= acc - 24'h10_0000;
				endcase
			end
			if (buttons != 4'b0000) begin
				await <= 1;
			end
		end else begin
			if (buttons == 4'b0000) begin
				await <= 0;
			end
		end
		if (ctr > 12_500_000) begin
			dispSel <= 6'b000000;
		end else begin
			dispSel <= dispMask;
		end
		if (ctr == 25_000_000) begin
			ctr <= 0;
		end else begin
			ctr <= ctr + 1'b1;
		end
	end
endmodule
