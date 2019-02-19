module aes_pipeline_stage2(
    clk,
    i_plain_text,
    i_aad,
    i_iv,
    i_instance_size,
    i_key_schedule,
    i_phase,
    i_h,
    i_new_instance,
    i_counter, 
    o_counter, 
    o_new_instance,
    o_h,
    o_j0,
    o_cb,
    o_key_schedule,
    o_plain_text,
    o_aad,
    o_instance_size,
    o_phase
);
    
    input logic           clk;
    input logic [0:127]   i_plain_text;
    input logic [0:127]   i_aad;
    input logic [0:95]    i_iv;
    input logic [0:127]   i_instance_size;
    input logic [0:127]   i_h;
    input logic [0:1407]  i_key_schedule;
    input logic [0:2]     i_phase;
    input logic           i_new_instance;
    input logic [0:127]   i_counter;
    
    output logic [0:127]    o_counter;
    output logic            o_new_instance;
    output logic [0:1407]   o_key_schedule;
    output logic [0:127]    o_plain_text;
    output logic [0:127]    o_aad;
    output logic [0:127]    o_h;
    output logic [0:127]    o_j0;
    output logic [0:127]    o_cb;
    output logic [0:127]    o_instance_size;
    output logic [0:2]      o_phase;
    
    logic [0:95]    r_iv;
    logic [0:1407]  r_key_schedule;
    logic [0:127]   r_cb;
    logic [0:127]   r_plain_text;
    logic [0:127]   r_aad;
    logic [0:127]   r_h;
    logic [0:127]   r_j0;
    logic [0:127]   r_counter;
    logic [0:127]   r_instance_size;
    logic           r_new_instance;
 
    logic [0:127]   w_cb;

    logic [0:2]     r_phase;
    integer aad_blocks;

    always_ff@ (posedge clk)
    begin
        r_key_schedule  <= i_key_schedule;
        r_iv            <= i_iv;
        r_plain_text    <= i_plain_text;
        r_aad           <= i_aad;
        r_counter       <= i_counter;
        r_key_schedule  <= i_key_schedule;
        r_instance_size <= i_instance_size;
        r_cb            <= w_cb; // Cycle
        r_h             <= i_h; // Cycle
        r_phase         <= i_phase;
        r_new_instance  <= i_new_instance;
    end
    
    always_comb
    begin
        o_h = fn_aes_encrypt_stage(r_h, r_key_schedule, 2);
        o_new_instance = r_new_instance;
    end

    always_comb
    begin
        o_j0 = {r_iv, 32'd1};
        o_phase = r_phase;

        /* Calculate the seed of ciphered cb
        First two cases the aad is delivering
        */
        aad_blocks = r_instance_size[0:63] >> 7;
        w_cb = {r_iv, r_counter[96:127] - aad_blocks + 2'd2};
        /*
        case(r_phase)
            3'b000:   w_cb = {r_iv, 32'd2};
            3'b111:   w_cb = {r_iv, 32'd2};
            default: w_cb = {r_iv, r_counter[96:127] - aad_blocks + 2'd3};
        endcase
        */

        /* Carrying forward register values for subsequent stages */
        o_counter = r_counter;
        o_cb = w_cb;
        o_plain_text    = r_plain_text;
        o_aad           = r_aad;
        o_key_schedule  = r_key_schedule;
        o_instance_size = r_instance_size;
    end
endmodule
