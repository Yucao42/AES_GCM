module aes_pipeline_stage8(
    clk,
    i_cipher_text,
    i_aad,
    i_new_instance,
    i_h,
    i_encrypted_j0,
    i_instance_size,
	i_ghashed_s0,
    o_cipher_text,
    o_tag_ready,
    o_tag
);

    input logic           clk;
    input logic [0:127]   i_cipher_text;
    input logic [0:127]   i_aad;
    input logic [0:127]   i_h;
    input logic [0:127]   i_encrypted_j0;
    input logic [0:127]   i_instance_size;
    input logic           i_new_instance;
    input logic [0:127]   i_ghashed_s0;
    
    output logic [0:127]    o_cipher_text;
    output logic [0:127]    o_tag;
    output logic            o_tag_ready;

	reg   [0:127]   r_mid;
    
    logic [0:127]   r_cipher_text;
    logic [0:127]   r_aad;
    logic [0:127]   r_h;
    logic [0:127]   r_encrypted_j0;
    logic [0:127]   r_instance_size;
    logic           r_new_instance;
    logic [0:127]   r_sblock;
    logic [0:127]    r_counter;
    logic [0:127]    r_ghashed_s0;

    logic [0:127]   w_encrypted_cb;
    logic [0:127]   w_sblock;
    logic [0:127]    w_counter;
    logic [0:127]   w_auth_input;
	

     
    /* Helper variables */
    integer aad_blocks;
    integer total_blocks;

    always_ff @(posedge clk)
    begin
        r_cipher_text    <= i_cipher_text;
        r_aad           <= i_aad;
        r_h             <= i_h;
        r_encrypted_j0  <= i_encrypted_j0;
        r_new_instance  <= i_new_instance;
        r_instance_size <= i_instance_size;
		r_ghashed_s0    <= i_ghashed_s0;

        r_sblock        <= w_sblock; // Cycle
        r_counter       <= w_counter; // Cycle
    end

    always_comb
    begin

        total_blocks = ((r_instance_size[0:63] + r_instance_size[64:127]) >> 7);
        aad_blocks = r_instance_size[64:127] >> 7;

		w_sblock = (r_ghashed_s0 ^ r_cipher_text);
		w_sblock = fn_product(w_sblock, r_h);

        w_sblock = (w_sblock ^ r_instance_size);
        w_sblock = fn_product(w_sblock, r_h);

		o_tag = w_sblock ^ r_encrypted_j0;
		o_tag_ready = 1;
		o_cipher_text = r_cipher_text;

    end
endmodule
