module aes_pipeline_stage9(
    clk,
    i_cipher_text,
    i_ready,
    i_h,
	i_sblock,
    i_instance_size,
	i_encrypted_j0,
    o_cipher_text,
    o_tag_ready,
    o_tag
);

    input logic           clk;
    input logic [0:127]   i_cipher_text;
    input logic           i_ready;
    input logic [0:127]   i_h;
    input logic [0:127]   i_sblock;
    input logic [0:127]   i_instance_size;
    input logic [0:127]   i_encrypted_j0;

    
    output logic [0:127]    o_cipher_text;
    output logic [0:127]    o_tag;
    output logic            o_tag_ready;
    
    logic [0:127]   r_cipher_text;
	logic           r_ready;
    logic [0:127]   r_h;
    logic [0:127]   r_sblock;
    logic [0:127]   r_instance_size;
    logic [0:127]   r_encrypted_j0;

    logic [0:127]   w_sblock;

    always_ff @(posedge clk)
    begin
        r_cipher_text   <= i_cipher_text;
        r_ready         <= i_ready;
        r_h             <= i_h;
        r_sblock        <= i_sblock;
        r_instance_size <= i_instance_size;
		r_encrypted_j0  <= i_encrypted_j0;
    end

    always_comb
    begin
		if (r_ready == 1)
		begin
        	w_sblock = (r_sblock ^ r_instance_size);
        	w_sblock = fn_product(w_sblock, r_h);
			o_tag_ready = 1'b1;
		end
		else
		begin
			w_sblock = r_sblock;
			o_tag_ready = 1'b0;
		end

      	o_tag = w_sblock ^ r_encrypted_j0;
        o_cipher_text = r_cipher_text;

    end
endmodule
