module test_aes(
);

	logic clk = 1'b0;

	logic [0:15]   sw;
	logic [3:0]    an;
	logic          dp;
	logic [6:0]    sg;
	aes aes_instance(
		.clk(clk),
		.sw(sw),
		.i_reset(1'b0),
		.an(an),
		.dp(dp),
		.seg(seg)
	);
 
	initial
	begin
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		sw = 16'd0;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 clk = ~clk;
	end
endmodule



	
