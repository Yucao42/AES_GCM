`timescale 1ns / 1ps

/* Top module for AES GCM */
module aes_api(
    clk,
    i_new,  // Signal that says it is a new instance
	i_plain_text,
	i_bypass_text,
	o_bypass_text,
    o_tag,
    o_cipher_text,
    o_cp_ready,
    o_tag_ready,
);

    input           clk;
    // Input including 96 bits iv, 128 bits aad block, 128 bits plaintext
    // block and 128 bits input key block.
    input           i_new;
	input [0:127]   i_plain_text;
	input [0:127]   i_bypass_text;
    output          o_tag_ready;
    // Cipher_text is ready
    output          o_cp_ready;
    output [0:127]  o_cipher_text;
	output [0:127]  o_bypass_text;
    output [0:127]  o_tag;

	// By default using all zeros to test the api 
	// TODO: Add customized keys
    reg [0:95]      iv = 96'd0;
    reg [0:127]     cipher_key = 128'd0;
    reg [0:127]     aad = 128'd0;

    /* GCM AES module (comes from gcm_aes.sv) */
    gcm_aes gcm_aes_instance(
        .clk(clk),
        .i_iv(iv),
        .i_new_instance(i_new),
        .i_cipher_key(cipher_key),
        .i_plain_text(i_plain_text),
        .i_bypass_text(i_bypass_text),
        .i_plain_text_size(64'd128),
        .i_aad_size(64'd0),
        .i_aad(aad),
        .o_bypass_text(o_bypass_text),
        .o_cp_ready(o_cp_ready),
        .o_cipher_text(o_cipher_text),
        .o_tag(o_tag),
        .o_tag_ready(o_tag_ready)
    );
    
endmodule
