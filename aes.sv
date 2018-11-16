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
    output logic [0:1407]   tag;

	logic [0:127] A;
	logic [0:127] B;
//    (* keep = "true" *) 
    logic [0:127] C;
//    (* keep = "true" *) 
    logic [0:1407] D;

    logic [0:1407]  k1;
    (* keep = "true" *) logic [0:127] E;
//    (* keep = "true" *) 
    (* keep = "true" *) logic [0:127] F;
    (* keep = "true" *) logic [0:127] G;
    
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
	end

	/*
	md_multiply_2 m1(
	   .clk(clk_out),
	   .i1(A),
	   .i2(B),
	   .i3(C),
	   .i4(D),
	   .o1(G),
	   .o2(F)
	);
	*/

   aes_key_gen2 k_1(
	   .clk(clk_out),
	   .i_key_schedule(key),
	   .o_key_schedule(k1)
   );

   aes_key_gen3 k_2(
	   .clk(clk_out),
	   .i_key_schedule(k1),
	   .o_key_schedule(tag)
   );

    //970
endmodule
