module aes_pipeline_stage2_pre(
    clk,
    i_plain_text,
    i_aad,
    i_iv,
    i_instance_size,
    i_key_schedule,
    i_phase,
    i_new_instance,
    i_counter,
    o_counter,
    o_new_instance,
    o_plain_text,
    o_aad,
    o_iv,
    o_instance_size,
    o_key_schedule,
    o_phase,
    o_h
);
    
    input logic           clk;
    input logic [0:127]   i_plain_text;
    input logic [0:127]   i_aad;
    input logic [0:95]    i_iv;
    input logic [0:127]   i_instance_size;
    input logic [0:1407]  i_key_schedule;
    input logic [0:2]     i_phase;
    input logic           i_new_instance;
    input logic [0:127]   i_counter;
    
    output logic [0:127]   o_counter;
    output logic           o_new_instance;
    output logic [0:127]   o_plain_text;
    output logic [0:127]   o_aad;
    output logic [0:95]    o_iv;
    output logic [0:127]   o_instance_size;
    output logic [0:127]   o_h;
    output logic [0:1407]  o_key_schedule;
    output logic [0:2]     o_phase;
    
    logic [0:127]   r_plain_text;
    logic           r_new_instance;
    logic [0:127]   r_aad;
    logic [0:95]    r_iv;
    logic [0:127]   r_instance_size;
    logic [0:1407]  r_key_schedule;
    logic [0:2]     r_phase;
    logic [0:127]   r_counter;
   
    always_ff@ (posedge clk)
    begin
        r_iv            <= i_iv;
	r_counter       <= i_counter;
        r_plain_text    <= i_plain_text;
        r_aad           <= i_aad;
        r_key_schedule  <= i_key_schedule;
        r_instance_size <= i_instance_size;
        r_phase         <= i_phase;
        r_new_instance  <= i_new_instance;
    end
    
    always_comb
    begin
        o_h = fn_aes_encrypt_stage(128'd0, r_key_schedule, 1);
        o_new_instance = r_new_instance;
    end

    always_comb
    begin
        o_plain_text    = r_plain_text;
        o_aad           = r_aad;
        o_iv            = r_iv;
        o_key_schedule  = r_key_schedule;
        o_instance_size = r_instance_size;
        o_phase         = r_phase;
        o_counter       = r_counter;
    end
endmodule
