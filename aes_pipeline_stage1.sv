module aes_pipeline_stage1 (
    clk,
    i_cipher_key,
    i_plain_text,
    i_aad,
    i_new_instance,
    i_iv,
    i_instance_size,
    i_pt_instance,
    o_key_schedule,
    o_plain_text,
    o_aad,
    o_iv,
    o_instance_size,
    o_new_instance,
    o_pt_instance
);

    input logic           clk;
    input logic [0:127]   i_cipher_key;
    input logic [0:127]   i_plain_text;
    input logic [0:127]   i_aad;
    input logic [0:95]    i_iv;
    input logic [0:127]   i_instance_size;
    input logic           i_new_instance;
    input logic           i_pt_instance;

    output logic [0:127]   o_plain_text;
    output logic [0:127]   o_aad;
    output logic [0:95]    o_iv;
    output logic [0:127]   o_instance_size;
    output logic           o_new_instance;
    output logic           o_pt_instance;
    output logic [0:1407]  o_key_schedule;

    logic [0:127]   r_cipher_key;
    logic [0:127]   r_plain_text;
    logic [0:127]   r_aad;
    logic [0:95]    r_iv;
    logic [0:127]   r_instance_size;
    logic           r_new_instance;
    logic           r_pt_instance;

    always_ff @(posedge clk)
    begin
        r_cipher_key    <= i_cipher_key;
        r_plain_text    <= i_plain_text;
        r_aad           <= i_aad;
        r_iv            <= i_iv;
        r_instance_size <= i_instance_size;
        r_new_instance  <= i_new_instance;
        r_pt_instance   <= i_pt_instance;
    end
    
    always_comb
    begin
        o_key_schedule = fn_key_expansion(r_cipher_key, 1407'b0, 1);

        /* Carrying forward register values for subsequent stages */
        o_plain_text    = r_plain_text;
        o_aad           = r_aad;
        o_iv            = r_iv;
        o_instance_size = r_instance_size;
        o_new_instance  = r_new_instance;
        o_pt_instance   = r_pt_instance;
    end
endmodule
