module bin2dec
	#(parameter count=6, dataWidth=20, digitWidth=4)
	(output reg [count*digitWidth-1:0] decOut,
	input [dataWidth-1:0] binIn
);
	reg [dataWidth-1:0] binData;
	reg [3:0] gross;
	integer i;
	always @* begin
		binData = binIn;
		for (i = count*digitWidth-1; i >= 0; i = i - 4) begin
			gross = binData / 10**(((i+1)/4)-1);
			decOut[i-:4] = gross;
			binData = binData - (gross * 10**(((i+1)/4)-1));
		end
	end
endmodule
