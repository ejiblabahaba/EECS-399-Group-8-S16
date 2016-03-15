module db9(
	input clk,
	input s9,s8,s7,s6,s5,s4,s3,s2,s1,s0,
	output o9,o8,o7,o6,o5,o4,o3,o2,o1,o0
);
	debounce d9(clk,s9,o9);
	debounce d8(clk,s8,o8);
	debounce d7(clk,s7,o7);
	debounce d6(clk,s6,o6);
	debounce d5(clk,s5,o5);
	debounce d4(clk,s4,o4);
	debounce d3(clk,s3,o3);
	debounce d2(clk,s2,o2);
	debounce d1(clk,s1,o1);
	debounce d0(clk,s0,o0);
endmodule