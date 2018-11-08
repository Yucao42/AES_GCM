module aes_pipeline_stage7(
    clk,
    i_plain_text,
    i_aad,
    i_h,
    i_encrypted_j0,
    i_encrypted_cb,
    i_instance_size,
    i_key_schedule,
    i_phase,
    o_phase,
    o_h,
    o_encrypted_j0,
    o_cipher_text,
    o_aad,
    o_instance_size
);

    input logic           clk;
    input logic [0:127]   i_plain_text;
    input logic [0:127]   i_aad;
    input logic [0:127]   i_h;
    input logic [0:127]   i_encrypted_j0;
    input logic [0:127]   i_encrypted_cb;
    input logic [0:127]   i_instance_size;
    input logic [0:1407]  i_key_schedule;
    input logic [0:2]     i_phase;
    
    output logic [0:2]      o_phase; 
    output logic [0:127]    o_cipher_text;
    output logic [0:127]    o_aad;
    output logic [0:127]    o_h;
    output logic [0:127]    o_encrypted_j0;
    output logic [0:127]    o_instance_size;
    
    logic [0:1407]  r_key_schedule;
    logic [0:127]   r_plain_text;
    logic [0:127]   r_aad;
    logic [0:127]   r_h;
    logic [0:127]   r_encrypted_j0;
    logic [0:127]   r_encrypted_cb;
    logic [0:127]   r_instance_size;
    
    logic [0:127]   w_encrypted_cb;
    logic [0:2]     r_phase;

    always_ff @(posedge clk)
    begin
        r_plain_text    <= i_plain_text;
        r_aad           <= i_aad;
        r_h             <= i_h;
        r_encrypted_j0  <= i_encrypted_j0;
        r_encrypted_cb  <= i_encrypted_cb;
        r_instance_size <= i_instance_size;
		r_phase         <= i_phase;
        r_key_schedule  <= i_key_schedule;
    end

    always_comb
    begin
        w_encrypted_cb = fn_aes_encrypt_stage(r_encrypted_cb, r_key_schedule, 10);
        o_cipher_text = r_plain_text ^ w_encrypted_cb;

        o_encrypted_j0 = fn_aes_encrypt_stage(r_encrypted_j0, r_key_schedule, 10);

        /* Carrying forward register values for subsequent stages */
		o_phase = r_phase;
        o_aad = r_aad;
        o_instance_size = r_instance_size;
        o_h = r_h;
    end
endmodule
