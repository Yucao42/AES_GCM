module aes_pipeline_stage2(
    clk,
    i_plain_text,
    i_aad,
    i_new_instance,
    i_iv,
    i_instance_size,
    i_pt_instance,
    i_key_schedule,
    o_h,
    o_j0,
    o_cb,
    o_key_schedule,
    o_plain_text,
    o_aad,
    o_instance_size,
    o_new_instance,
    o_pt_instance
);
    
    input logic           clk;
    input logic [0:127]   i_plain_text;
    input logic [0:127]   i_aad;
    input logic [0:95]    i_iv;
    input logic [0:127]   i_instance_size;
    input logic [0:1407]  i_key_schedule;
    input logic           i_new_instance;
    input logic           i_pt_instance;
    
    output logic [0:1407]   o_key_schedule;
    output logic [0:127]    o_plain_text;
    output logic [0:127]    o_aad;
    output logic [0:127]    o_h;
    output logic [0:127]    o_j0;
    output logic [0:127]    o_cb;
    output logic [0:127]    o_instance_size;
    output logic            o_new_instance;
    output logic            o_pt_instance;
    
    logic [0:95]    r_iv;
    logic [0:1407]  r_key_schedule;
    logic [0:127]   r_cb;
    logic [0:127]   r_plain_text;
    logic [0:127]   r_aad;
    logic [0:127]   r_h;
    logic [0:127]   r_j0;
    logic [0:127]   r_instance_size;
    logic           r_new_instance;
    logic           r_pt_instance;
 
    logic [0:127]   w_cb;

    always_ff@ (posedge clk)
    begin
        r_key_schedule  <= i_key_schedule;
        r_iv            <= i_iv;
        r_plain_text    <= i_plain_text;
        r_aad           <= i_aad;
        r_new_instance  <= i_new_instance;
        r_key_schedule  <= i_key_schedule;
        r_instance_size <= i_instance_size;
        r_pt_instance   <= i_pt_instance;
        r_cb            <= w_cb; // Cycle
    end
    
	always_comb
	begin
        o_h = fn_aes_encrypt_stage(128'd0, r_key_schedule, 1);
	end

    always_comb
    begin
        o_j0 = {r_iv, 32'd1};

		/* Calculate the seed of ciphered cb */
        if (r_pt_instance == 1)
            w_cb = {r_iv, 32'd2};
        else
            w_cb = {r_cb[0:95], r_cb[96:127] + 1'b1};
		o_cb = w_cb;

        /* Carrying forward register values for subsequent stages */
        o_plain_text    = r_plain_text;
        o_aad           = r_aad;
        o_new_instance  = r_new_instance;
        o_key_schedule  = r_key_schedule;
        o_instance_size = r_instance_size;
        o_pt_instance   = r_pt_instance;
    end
endmodule
