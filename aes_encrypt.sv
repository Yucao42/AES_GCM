`timescale 1ns / 1ps

/* Top module for AES GCM */
module aes(
    clk,
    sw,
    key,
    tag
);

    input                  clk;
    input  logic [0:511]   sw;
    input  logic [0:1407]  key;
    output logic [0:127]   tag;

	logic [0:127] A;
	logic [0:127] B;
//    (* keep = "true" *) 
    logic [0:127] C;
//    (* keep = "true" *) 
    logic [0:127] D;
    (* keep = "true" *) logic [0:127] E;
//    (* keep = "true" *) 
    logic [0:127] F;
    
    logic locked;
    logic clk_out;

    /* Clock module (Comes from clk_gen.sv) */    
    clk_gen clk_gen_instance(
        .i_clk_in(clk),
        .i_reset(1'b0),
        .o_locked(locked),
        .o_clk_out(clk_out)
    );  
    
	always_ff @(posedge clk_out)
	begin
 		A <= sw[0+:128];
        B <= sw[128+:128];
        C <= sw[256+:128];	

		E <= D;
		F <= E;
	end

	
	md_encrypt m1(
	   .clk(clk_out),
	   .i1(A),
	   .i2(3'd1),
	   .key(key),
	   .o(D)
	);

	md_encrypt m2(
	   .clk(clk_out),
	   .i1(E),
	   .i2(3'd3),
	   .key(key),
	   .o(F)
	);	
  
	md_encrypt m3(
       .clk(clk_out),
       .i1(F),
       .i2(3'd5),
	   .key(key),
       .o(tag)
    );    
    //970
endmodule
