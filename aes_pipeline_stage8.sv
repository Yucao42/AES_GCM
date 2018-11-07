module aes_pipeline_stage8(
    clk,
    i_cipher_text,
    i_aad,
    i_new_instance,
    i_h,
    i_encrypted_j0,
    i_instance_size,
    i_phase,
    o_encrypted_j0,
	o_instance_size,
	o_h,
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
    input logic [0:1]     i_phase;
    
    output logic [0:127]    o_encrypted_j0;
    output logic [0:127]    o_cipher_text;
    output logic [0:127]    o_tag;
    output logic            o_tag_ready;
    output logic [0:127]    o_h;
    output logic [0:127]    o_instance_size;
    
    logic [0:127]   r_cipher_text;
    logic [0:127]   r_aad;
    logic [0:127]   r_h;
    logic [0:127]   r_encrypted_j0;
    logic [0:127]   r_instance_size;
    logic           r_new_instance;
    logic [0:127]   r_sblock;
    logic [0:127]   r_counter;

    logic [0:127]   w_encrypted_cb;
    logic [0:127]   w_sblock;
    logic [0:127]   w_counter;
    logic [0:127]   w_auth_input;
     
    logic [0:1]     r_phase;
    /* Helper variables */
    integer aad_blocks;
    integer total_blocks;

    always_ff @(posedge clk)
    begin
        r_cipher_text   <= i_cipher_text;
        r_aad           <= i_aad;
        r_h             <= i_h;
        r_encrypted_j0  <= i_encrypted_j0;
        r_new_instance  <= i_new_instance;
        r_instance_size <= i_instance_size;
		r_phase         <= i_phase;

        if (r_new_instance == 1)
        begin
            r_sblock <= 128'd0;
        end
        else
        begin
            r_sblock <= w_sblock;
        end
    end

    always_comb
    begin
        w_sblock = r_sblock;
		case(r_phase)
			2'b11:   o_tag_ready = 1;
		    default: o_tag_ready = 0;
		endcase
			
		case(r_phase)
			2'b10:   w_auth_input = r_aad;
		    default: w_auth_input = r_cipher_text;
		endcase

        w_sblock = (w_sblock ^ w_auth_input);
        w_sblock = fn_product(w_sblock, r_h);

		/*
		* This part deprecated as it doesn't meet the time requirement.
		* Instead we assign the value to exact time on 128-bit case.
		*/
      	o_tag = w_sblock;
        o_cipher_text = r_cipher_text;
		o_h = r_h;
		o_instance_size = r_instance_size;
		o_encrypted_j0 = r_encrypted_j0;
    end
endmodule
