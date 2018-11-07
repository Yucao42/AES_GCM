`timescale 1ns / 1ps

/* Top module for AES GCM */
module aes(
    clk,
    sw,
    i_reset,  // Signal that says it is a new instance
    an,
    dp,
    seg
);

    input           clk;
	// Input including 96 bits iv, 128 bits aad block, 128 bits plaintext
	// block and 128 bits input key block.
    input  [0:352+ 128]   sw;
    input           i_reset;
    output [3:0]    an;
    output          dp;
    output [6:0]    seg;

    logic           clk_out;
    logic           locked;
    logic           pt_delay;

	logic [0:95]    iv_sw = sw[0+:96];
	logic [0:127]   plain_text_sw = sw[96+:128];
	logic [0:127]   cipher_key_sw = sw[224+:128];
	logic [0:127]   aad = sw[352+:128];

    logic [0:127]   cipher_text;
    logic [0:127]   tag;
    reg tag_ready;
    
    /* Clock module (Comes from clk_gen.sv) */    
    clk_gen clk_gen_instance(
        .i_clk_in(clk),
        .i_reset(1'b0),
        .o_locked(locked),
        .o_clk_out(clk_out)
    );  
    
    /* GCM AES module (comes from gcm_aes.sv) */
    gcm_aes gcm_aes_instance(
        .clk(clk_out),
        .i_iv(iv_sw),
        .i_new_instance(i_reset),
        .i_cipher_key(cipher_key_sw),
        .i_plain_text(plain_text_sw),
        .i_plain_text_size(64'd128),
        .i_aad_size(64'd128),
        .i_aad(aad),
        .o_cipher_text(cipher_text),
        .o_tag(tag),
        .o_tag_ready(tag_ready)
    );
    
    /* Display module (comes from display.sv) */
    display u (
        .in_count(1),
        .i_x(tag),
        .clk(clk_out),
        .clr(1'b0),
        .a_to_g(seg),
        .an(an),
        .dp(dp)
    );

endmodule
