`timescale 1ns / 1ps

/* Top module for AES GCM */
module aes(
    clk,
    sw,
    key,
    an,
    dp,
    seg
);

    input                  clk;
    input  logic [0:15]   sw;
    input  logic [0:1407]  key;
    output [3:0]    an;
    output          dp;
    output [6:0]    seg;


    logic [0:127] tag;

    (* keep = "true" *) logic [0:127] D;
    (* keep = "true" *) logic [0:127] E;

    (* keep = "true" *) logic [0:127] Aw   = {sw[8:11], sw[8:11], sw[8:11], sw[8:11], sw[8:11], sw[8:11], sw[8:11], sw[8:11],
                                     sw[8:11], sw[8:11], sw[8:11], sw[8:11], sw[8:11], sw[8:11], sw[8:11], sw[8:11],
                                     sw[8:11], sw[8:11], sw[8:11], sw[8:11], sw[8:11], sw[8:11], sw[8:11], sw[8:11],
                                     sw[8:11], sw[8:11], sw[8:11], sw[8:11], sw[8:11], sw[8:11], sw[8:11], sw[8:11]};

    (* keep = "true" *) logic [0:127] Bw   = {sw[12:15], sw[12:15], sw[12:15], sw[12:15], sw[12:15], sw[12:15], sw[12:15], sw[12:15],
                                     sw[12:15], sw[12:15], sw[12:15], sw[12:15], sw[12:15], sw[12:15], sw[12:15], sw[12:15],
                                     sw[12:15], sw[12:15], sw[12:15], sw[12:15], sw[12:15], sw[12:15], sw[12:15], sw[12:15],
                                     sw[12:15], sw[12:15], sw[12:15], sw[12:15], sw[12:15], sw[12:15], sw[12:15], sw[12:15]};

    
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
		E <= D;
	end

	md_multiply m2(
	   .clk(clk_out),
	   .i1(Aw),
	   .i2(128'b0),
	   .i3(Bw),
	   .o(D)
	);	
  

	md_multiply m3(
       .clk(clk_out),
       .i1(E),
       .i2(Bw),
       .i3(Aw),
       .o(tag)
    );    

    /* Display module (comes from display.sv) */
    display u (
        .in_count(1),
		/* Calculation of tag will exceed the LUT limitation on Basys3 board.
        .i_x({tag[0+:8], tag[8+:8]}),
		*/
        .i_x(tag),
        //.i_x({cipher_text[8+:8], cipher_text[0+:8]}),
        .clk(clk_out),
        .clr(1'b0),
        .a_to_g(seg),
        .an(an),
        .dp(dp)
    );

    //970
endmodule
