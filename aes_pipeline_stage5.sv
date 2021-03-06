module aes_pipeline_stage5(
    clk,
    i_plain_text,
    i_aad,
    i_h,
    i_encrypted_j0,
    i_encrypted_cb,
    i_instance_size,
    i_key_schedule,
    i_phase,
    i_new_instance,
    o_new_instance,
    o_phase,
    o_h,
    o_encrypted_j0,
    o_encrypted_cb,
    o_key_schedule,
    o_plain_text,
    o_aad,
    o_instance_size,
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
    input logic           i_new_instance;
    
    output logic            o_new_instance;
    output logic [0:2]      o_phase; 
    output logic [0:1407]   o_key_schedule;
    output logic [0:127]    o_plain_text;
    output logic [0:127]    o_aad;
    output logic [0:127]    o_h;
    output logic [0:127]    o_encrypted_j0;
    output logic [0:127]    o_encrypted_cb;
    output logic [0:127]    o_instance_size;
    
    logic [0:1407]  r_key_schedule;
    logic [0:127]   r_plain_text;
    logic [0:127]   r_aad;
    logic [0:127]   r_h;
    logic [0:127]   r_encrypted_j0;
    logic [0:127]   r_encrypted_cb;
    logic [0:127]   r_instance_size;
    logic           r_pt_instance;
    logic [0:2]     r_phase;
    logic           r_new_instance;
    
    always_ff @(posedge clk)
    begin
        r_plain_text    <= i_plain_text;
        r_phase         <= i_phase;
        r_aad           <= i_aad;
        r_h             <= i_h;
        r_encrypted_j0  <= i_encrypted_j0;
        r_encrypted_cb  <= i_encrypted_cb;
        r_key_schedule  <= i_key_schedule;
        r_instance_size <= i_instance_size;
        r_new_instance  <= i_new_instance;
    end

    always_comb
    begin
        o_h = fn_aes_encrypt_stage(r_h, r_key_schedule, 8);
        o_encrypted_cb = fn_aes_encrypt_stage(r_encrypted_cb, r_key_schedule, 6);
        o_encrypted_j0 = fn_aes_encrypt_stage(r_encrypted_j0, r_key_schedule, 6);

        /* Carrying forward register values for subsequent stages */
        o_phase = r_phase;
        o_plain_text = r_plain_text;
        o_aad = r_aad;
        o_key_schedule = r_key_schedule;
        o_instance_size = r_instance_size;
        o_new_instance = r_new_instance;
    end
endmodule
