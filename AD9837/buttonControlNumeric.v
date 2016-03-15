module buttonControlNumeric
	#(parameter dispNum=6,
					freq=50_000_000)
	(
		clk,
		buttons,
		number,
		dispSel
	);
	
	input clk;
	input [3:0] buttons;
	
	output reg [19:0] number;
	output reg [dispNum-1:0] dispSel;
	
	reg [dispNum-1:0] dispMask = 6'b000001;
	reg [31:0] counter = 0;
	reg [16:0] acc = 1;
	reg await = 0;
	
	always @(posedge clk) begin
		if (~await) begin
			if (buttons == 4'b1000) begin
				if (dispMask == 6'b100000) begin
					dispMask <= 6'b000001;
					acc <= 1;
				end else begin
					dispMask <= (dispMask << 1);
					acc <= acc * 10;
				end
				await <= 1;
			end else if (buttons == 4'b0100) begin
				if (dispMask == 6'b000001) begin
					dispMask <= 6'b100000;
					acc <= 100_000;
				end else begin
					dispMask <= (dispMask >> 1);
					acc <= acc / 10;
				end
				await <= 1;
			end else	if (buttons == 4'b0010) begin
				if (number + acc > 999_999) begin
					number <= 999_999;
				end else begin
					number <= number + acc;
				end				
				await <= 1;
			end else if (buttons == 4'b0001) begin
				if (number - acc > 999_999) begin
					number <= 0;
				end else begin
					number <= number - acc;
				end
				await <= 1;
			end else if (buttons > 4'b0000) begin
				await <= 1;
			end
		end else begin
			if (buttons == 4'b0000) begin
				await <= 0;
			end
		end
		
		if (counter < freq/4) begin
			dispSel <= dispMask;
			counter <= counter + 1;
		end else begin
			dispSel <= 6'b000000;
			if (counter < freq/2) begin
				counter <= counter + 1;
			end else begin
				counter <= 32'h0000_0000;
			end
		end
		
	end
endmodule
