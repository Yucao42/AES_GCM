`timescale 1ns / 1ps

/* 
* Plain text and aad size here only refer to
* plain text and add block size and not the total
* size.
*/

module gcm_aes(
        clk,
        i_new_instance,
        i_pt_instance,
        i_iv,
        i_cipher_key,
        i_plain_text,
        i_aad,
        i_plain_text_size,
        i_aad_size,
        o_cp_ready,
        o_cipher_text,
        o_tag,
        o_tag_ready
    );

    input   clk;
    input   i_new_instance;
    input   i_pt_instance;

    input  [0:95]       i_iv;
    input  [0:127]      i_plain_text;
    input  [0:127]      i_aad;
    input  [0:127]      i_cipher_key;
    input  [0:63]       i_plain_text_size;
    input  [0:63]       i_aad_size;

    output logic [0:127]   o_cipher_text;
    output logic [0:127]   o_tag;
    output logic           o_tag_ready;
    output logic           o_cp_ready;
    
    /* Wires joining Stage1 and Stage2 */
    (* dont_touch = "true" *) logic [0:127]     w_s1_plain_text;
    logic [0:95]      w_s1_iv;
    logic [0:1407]    w_s1_key_schedule;
    (* dont_touch = "true" *) logic [0:127]     w_s1_aad;
    logic [0:127]     w_s1_instance_size;
    logic [0:2]       w_s1_phase;

    /* s1p are signals previous to stage 2 postior to stage 1 */
    (* dont_touch = "true" *) logic [0:127]     w_s1p_plain_text;
    logic [0:95]      w_s1p_iv;
    logic [0:1407]    w_s1p_key_schedule;
    (* dont_touch = "true" *) logic [0:127]     w_s1p_aad;
    logic [0:127]     w_s1p_instance_size;
    logic [0:127]     w_s1p_h;
    logic [0:2]       w_s1p_phase;

    /* Wires joining Stage2 and Stage3 */
    (* dont_touch = "true" *) logic [0:127]     w_s2_plain_text;
    (* dont_touch = "true" *) logic [0:127]     w_s2_aad;
    logic [0:127]     w_s2_j0;
    logic [0:127]     w_s2_cb;
    logic [0:127]     w_s2_h;
    logic [0:1407]    w_s2_key_schedule;
    logic [0:127]     w_s2_instance_size;
    logic [0:2]       w_s2_phase;
   
    /* s2p are signals postior to stage 2 */
    (* dont_touch = "true" *) logic [0:127]     w_s2p_plain_text;
    (* dont_touch = "true" *) logic [0:127]     w_s2p_aad;
    logic [0:1407]    w_s2p_key_schedule;
    logic [0:127]     w_s2p_instance_size;
    logic [0:127]     w_s2p_h;
    logic [0:2]       w_s2p_phase;
    logic [0:127]     w_s2p_encrypted_j0;
    logic [0:127]     w_s2p_encrypted_cb;
    
    /* Wires joining Stage3 and Stage4 */
    (* dont_touch = "true" *) logic [0:127]     w_s3_plain_text;
    logic [0:127]     w_s3_encrypted_j0;
    logic [0:127]     w_s3_encrypted_cb;
    logic [0:127]     w_s3_h;
    logic [0:1407]    w_s3_key_schedule;
    (* dont_touch = "true" *) logic [0:127]     w_s3_aad;
    logic [0:127]     w_s3_instance_size;
    logic [0:2]       w_s3_phase;

    /* s3p are signals postior to stage 3 */
    (* dont_touch = "true" *) logic [0:127]     w_s3p_plain_text;
    (* dont_touch = "true" *) logic [0:127]     w_s3p_aad;
    logic [0:1407]    w_s3p_key_schedule;
    logic [0:127]     w_s3p_instance_size;
    logic [0:127]     w_s3p_h;
    logic [0:2]       w_s3p_phase;
    logic [0:127]     w_s3p_encrypted_j0;
    logic [0:127]     w_s3p_encrypted_cb;

    /* Wires joining Stage4 and Stage5 */
    (* dont_touch = "true" *) logic [0:127]     w_s4_plain_text;
    logic [0:127]     w_s4_encrypted_j0;
    logic [0:127]     w_s4_encrypted_cb;
    logic [0:127]     w_s4_h;
    logic [0:1407]    w_s4_key_schedule;
    (* dont_touch = "true" *) logic [0:127]     w_s4_aad;
    logic [0:127]     w_s4_instance_size;
    logic [0:2]       w_s4_phase;

    /* s4p are signals postior to stage 4 */
    (* dont_touch = "true" *) logic [0:127]     w_s4p_plain_text;
    (* dont_touch = "true" *) logic [0:127]     w_s4p_aad;
    logic [0:1407]    w_s4p_key_schedule;
    logic [0:127]     w_s4p_instance_size;
    logic [0:127]     w_s4p_h;
    logic [0:2]       w_s4p_phase;
    logic [0:127]     w_s4p_encrypted_j0;
    logic [0:127]     w_s4p_encrypted_cb;

    /* Wires joining Stage4 and Stage5 */
    (* dont_touch = "true" *) logic [0:127]     w_s5_plain_text;
    logic [0:127]     w_s5_encrypted_j0;
    logic [0:127]     w_s5_encrypted_cb;
    logic [0:127]     w_s5_h;
    logic [0:1407]    w_s5_key_schedule;
    (* dont_touch = "true" *) logic [0:127]     w_s5_aad;
    logic [0:127]     w_s5_instance_size;
    logic [0:2]       w_s5_phase;
   
    /* s5p are signals postior to stage 5 */
    (* dont_touch = "true" *) logic [0:127]     w_s5p_plain_text;
    (* dont_touch = "true" *) logic [0:127]     w_s5p_aad;
    logic [0:1407]    w_s5p_key_schedule;
    logic [0:127]     w_s5p_instance_size;
    logic [0:127]     w_s5p_h;
    logic [0:2]       w_s5p_phase;
    logic [0:127]     w_s5p_encrypted_j0;
    logic [0:127]     w_s5p_encrypted_cb;

    /* Wires joining Stage5 and Stage6 */
    (* dont_touch = "true" *) logic [0:127]     w_s6_plain_text;
    logic [0:127]     w_s6_encrypted_j0;
    logic [0:127]     w_s6_encrypted_cb;
    logic [0:127]     w_s6_h;
    logic [0:1407]    w_s6_key_schedule;
    (* dont_touch = "true" *) logic [0:127]     w_s6_aad;
    logic [0:127]     w_s6_instance_size;
    logic [0:2]       w_s6_phase;

    /* s6p are signals postior to stage 6 */
    (* dont_touch = "true" *) logic [0:127]     w_s6p_plain_text;
    (* dont_touch = "true" *) logic [0:127]     w_s6p_aad;
    logic [0:1407]    w_s6p_key_schedule;
    logic [0:127]     w_s6p_instance_size;
    logic [0:127]     w_s6p_h;
    logic [0:2]       w_s6p_phase;
    logic [0:127]     w_s6p_encrypted_j0;
    logic [0:127]     w_s6p_encrypted_cb;

    /* Wires joining Stage6 and Stage7 */
    logic [0:127]     w_s7_cipher_text;
    logic [0:127]     w_s7_encrypted_j0;
    logic [0:127]     w_s7_h;
    logic [0:1407]    w_s7_key_schedule;
    (* dont_touch = "true" *) logic [0:127]     w_s7_aad;
    logic [0:127]     w_s7_instance_size;
    logic [0:2]       w_s7_phase;
   
    /* Wires joining Stage8 and Stage9 */
    logic             w_s8_sblock_ready;
    logic [0:1407]    w_s8_key_schedule;
    logic [0:127]     w_s8_cipher_text;
    logic [0:127]     w_s8_encrypted_j0;
    logic [0:127]     w_s8_sblock;
    logic [0:127]     w_s8_h;
    logic [0:127]     w_s8_instance_size;
    logic [0:2]       w_s8_phase;

    aes_pipeline_stage1 stage1(
        .clk(clk),
        .i_plain_text(i_plain_text),
        .i_aad(i_aad),
        .i_new_instance(i_new_instance),
        .i_iv(i_iv),
        .i_instance_size({i_aad_size, i_plain_text_size}),
        .i_pt_instance(i_pt_instance),
        .o_phase(w_s1_phase),
        .o_plain_text(w_s1_plain_text),
        .o_aad(w_s1_aad),
        .o_iv(w_s1_iv),
        .o_instance_size(w_s1_instance_size)
    );

    aes_key_gen1 keygen0(
        .clk(clk),
        .i_key_schedule(i_cipher_key),
        .o_key_schedule(w_s1_key_schedule)
    );

    aes_pipeline_stage2_pre stage2p(
        .clk(clk),
        .i_plain_text(w_s1_plain_text),
        .i_aad(w_s1_aad),
        .i_iv(w_s1_iv),
        .i_instance_size(w_s1_instance_size),
        .i_key_schedule(w_s1_key_schedule),
        .i_phase(w_s1_phase),
        .o_phase(w_s1p_phase),
        .o_h(w_s1p_h),
        .o_plain_text(w_s1p_plain_text),
        .o_aad(w_s1p_aad),
        .o_iv(w_s1p_iv),
        .o_instance_size(w_s1p_instance_size)
    );

    aes_key_gen2 keygen1(
        .clk(clk),
        .i_key_schedule(w_s1_key_schedule),
        .o_key_schedule(w_s1p_key_schedule)
    );
    
    aes_pipeline_stage2 stage2(
        .clk(clk),
        .i_plain_text(w_s1p_plain_text),
        .i_aad(w_s1p_aad),
        .i_iv(w_s1p_iv),
        .i_instance_size(w_s1p_instance_size),
        .i_key_schedule(w_s1p_key_schedule),
        .i_phase(w_s1p_phase),
        .i_h(w_s1p_h),
        .o_phase(w_s2_phase),
        .o_h(w_s2_h),
        .o_j0(w_s2_j0),
        .o_cb(w_s2_cb),
        .o_plain_text(w_s2_plain_text),
        .o_aad(w_s2_aad),
        .o_instance_size(w_s2_instance_size)
    );
    
    aes_key_gen3 keygen2(
        .clk(clk),
        .i_key_schedule(w_s1p_key_schedule),
        .o_key_schedule(w_s3_key_schedule)
    );

    // TODO rearrange the clks
    aes_pipeline_stage3_pre stage3p(
        .clk(clk),
        .i_phase(w_s2_phase),
        .i_h(w_s2_h),
        .i_j0(w_s2_j0),
        .i_cb(w_s2_cb),
        .i_plain_text(w_s2_plain_text),
        .i_aad(w_s2_aad),
        .i_instance_size(w_s2_instance_size),
        .i_key_schedule(w_s3_key_schedule),
        .o_phase(w_s2p_phase),
        .o_h(w_s2p_h),
        .o_encrypted_j0(w_s2p_encrypted_j0),
        .o_encrypted_cb(w_s2p_encrypted_cb),
        .o_plain_text(w_s2p_plain_text),
        .o_aad(w_s2p_aad),
        .o_instance_size(w_s2p_instance_size)
    );

    aes_key_gen4 keygen3(
        .clk(clk),
        .i_key_schedule(w_s3_key_schedule),
        .o_key_schedule(w_s2p_key_schedule)
    );

    aes_pipeline_stage3 stage3(
        .clk(clk),
        .i_plain_text(w_s2p_plain_text),
        .i_aad(w_s2p_aad),
        .i_h(w_s2p_h),
        .i_j0(w_s2p_encrypted_j0),
        .i_cb(w_s2p_encrypted_cb),
        .i_instance_size(w_s2p_instance_size),
        .i_key_schedule(w_s2p_key_schedule),
        .i_phase(w_s2p_phase),
        .o_phase(w_s3_phase),
        .o_h(w_s3_h),
        .o_encrypted_j0(w_s3_encrypted_j0),
        .o_encrypted_cb(w_s3_encrypted_cb),
        .o_plain_text(w_s3_plain_text),
        .o_aad(w_s3_aad),
        .o_instance_size(w_s3_instance_size)
    );

    aes_key_gen5 keygen4(
        .clk(clk),
        .i_key_schedule(w_s2p_key_schedule),
        .o_key_schedule(w_s4_key_schedule)
    );

    aes_pipeline_stage4_pre stage4p(
        .clk(clk),
        .i_plain_text(w_s3_plain_text),
        .i_aad(w_s3_aad),
        .i_h(w_s3_h),
        .i_encrypted_j0(w_s3_encrypted_j0),
        .i_encrypted_cb(w_s3_encrypted_cb),
        .i_instance_size(w_s3_instance_size),
        .i_key_schedule(w_s4_key_schedule),
        .i_phase(w_s3_phase),
        .o_phase(w_s3p_phase),
        .o_h(w_s3p_h),
        .o_encrypted_j0(w_s3p_encrypted_j0),
        .o_encrypted_cb(w_s3p_encrypted_cb),
        .o_plain_text(w_s3p_plain_text),
        .o_aad(w_s3p_aad),
        .o_instance_size(w_s3p_instance_size)
    );

    aes_key_gen6 keygen5(
        .clk(clk),
        .i_key_schedule(w_s4_key_schedule),
        .o_key_schedule(w_s5_key_schedule)
    );

    aes_pipeline_stage4 stage4(
        .clk(clk),
        .i_plain_text(w_s3p_plain_text),
        .i_aad(w_s3p_aad),
        .i_h(w_s3p_h),
        .i_encrypted_j0(w_s3p_encrypted_j0),
        .i_encrypted_cb(w_s3p_encrypted_cb),
        .i_instance_size(w_s3p_instance_size),
        .i_key_schedule(w_s5_key_schedule),
        .i_phase(w_s3p_phase),
        .o_phase(w_s4_phase),
        .o_h(w_s4_h),
        .o_encrypted_j0(w_s4_encrypted_j0),
        .o_encrypted_cb(w_s4_encrypted_cb),
        .o_plain_text(w_s4_plain_text),
        .o_aad(w_s4_aad),
        .o_instance_size(w_s4_instance_size)
    );

    aes_key_gen7 keygen6(
        .clk(clk),
        .i_key_schedule(w_s5_key_schedule),
        .o_key_schedule(w_s6_key_schedule)
    );

    aes_pipeline_stage5_pre stage5p(
        .clk(clk),
        .i_plain_text(w_s4_plain_text),
        .i_aad(w_s4_aad),
        .i_h(w_s4_h),
        .i_encrypted_j0(w_s4_encrypted_j0),
        .i_encrypted_cb(w_s4_encrypted_cb),
        .i_instance_size(w_s4_instance_size),
        .i_key_schedule(w_s6_key_schedule),
        .i_phase(w_s4_phase),
        .o_phase(w_s4p_phase),
        .o_h(w_s4p_h),
        .o_encrypted_j0(w_s4p_encrypted_j0),
        .o_encrypted_cb(w_s4p_encrypted_cb),
        .o_plain_text(w_s4p_plain_text),
        .o_aad(w_s4p_aad),
        .o_instance_size(w_s4p_instance_size)
    );

    aes_key_gen8 keygen7(
        .clk(clk),
        .i_key_schedule(w_s6_key_schedule),
        .o_key_schedule(w_s4p_key_schedule)
    );

    aes_pipeline_stage5 stage5(
        .clk(clk),
        .i_plain_text(w_s4p_plain_text),
        .i_aad(w_s4p_aad),
        .i_h(w_s4p_h),
        .i_encrypted_j0(w_s4p_encrypted_j0),
        .i_encrypted_cb(w_s4p_encrypted_cb),
        .i_instance_size(w_s4p_instance_size),
        .i_key_schedule(w_s4p_key_schedule),
        .i_phase(w_s4p_phase),
        .o_phase(w_s5_phase),
        .o_key_schedule(w_s7_key_schedule),
        .o_h(w_s5_h),
        .o_encrypted_j0(w_s5_encrypted_j0),
        .o_encrypted_cb(w_s5_encrypted_cb),
        .o_plain_text(w_s5_plain_text),
        .o_aad(w_s5_aad),
        .o_instance_size(w_s5_instance_size)
    );

    aes_pipeline_stage6_pre stage6p(
        .clk(clk),
        .i_plain_text(w_s5_plain_text),
        .i_aad(w_s5_aad),
        .i_h(w_s5_h),
        .i_encrypted_j0(w_s5_encrypted_j0),
        .i_encrypted_cb(w_s5_encrypted_cb),
        .i_instance_size(w_s5_instance_size),
        .i_key_schedule(w_s7_key_schedule),
        .i_phase(w_s5_phase),
        .o_phase(w_s5p_phase),
        .o_key_schedule(w_s5p_key_schedule),
        .o_h(w_s5p_h),
        .o_encrypted_j0(w_s5p_encrypted_j0),
        .o_encrypted_cb(w_s5p_encrypted_cb),
        .o_plain_text(w_s5p_plain_text),
        .o_aad(w_s5p_aad),
        .o_instance_size(w_s5p_instance_size)
    );


    aes_signal_passing pass6(
        .clk(clk),
        .i_plain_text(w_s5p_plain_text),
        .i_aad(w_s5p_aad),
        .i_instance_size(w_s5p_instance_size),
        .o_plain_text(w_s6_plain_text),
        .o_aad(w_s6_aad),
        .o_instance_size(w_s6_instance_size)
    );

    aes_pipeline_stage6 stage6(
        .clk(clk),
        .i_h(w_s5p_h),
        .i_encrypted_j0(w_s5p_encrypted_j0),
        .i_encrypted_cb(w_s5p_encrypted_cb),
        .i_key_schedule(w_s5p_key_schedule),
        .i_phase(w_s5p_phase),
        .o_key_schedule(w_s8_key_schedule),
        .o_phase(w_s6_phase),
        .o_h(w_s6_h),
        .o_encrypted_j0(w_s6_encrypted_j0),
        .o_encrypted_cb(w_s6_encrypted_cb)
    );

    aes_pipeline_stage7_pre stage7p(
        .clk(clk),
        .i_plain_text(w_s6_plain_text),
        .i_aad(w_s6_aad),
        .i_h(w_s6_h),
        .i_encrypted_j0(w_s6_encrypted_j0),
        .i_encrypted_cb(w_s6_encrypted_cb),
        .i_instance_size(w_s6_instance_size),
        .i_key_schedule(w_s8_key_schedule),
        .i_phase(w_s6_phase),
        .o_key_schedule(w_s6p_key_schedule),
        .o_phase(w_s6p_phase),
        .o_h(w_s6p_h),
        .o_encrypted_j0(w_s6p_encrypted_j0),
        .o_encrypted_cb(w_s6p_encrypted_cb),
        .o_plain_text(w_s6p_plain_text),
        .o_aad(w_s6p_aad),
        .o_instance_size(w_s6p_instance_size)
    );

    aes_pipeline_stage7 stage7(
        .clk(clk),
        .i_plain_text(w_s6p_plain_text),
        .i_aad(w_s6p_aad),
        .i_h(w_s6p_h),
        .i_encrypted_j0(w_s6p_encrypted_j0),
        .i_encrypted_cb(w_s6p_encrypted_cb),
        .i_instance_size(w_s6p_instance_size),
        .i_key_schedule(w_s6p_key_schedule),
        .i_phase(w_s6p_phase),
        .o_phase(w_s7_phase),
        .o_h(w_s7_h),
        .o_encrypted_j0(w_s7_encrypted_j0),
        .o_cipher_text(w_s7_cipher_text),
        .o_aad(w_s7_aad),
        .o_instance_size(w_s7_instance_size)
    );

    aes_pipeline_stage8 stage8(
        .clk(clk),
        .i_cipher_text(w_s7_cipher_text),
        .i_aad(w_s7_aad),
        .i_h(w_s7_h),
        .i_encrypted_j0(w_s7_encrypted_j0),
        .i_instance_size(w_s7_instance_size),
        .i_phase(w_s7_phase),
        .o_phase(w_s8_phase),
        .o_encrypted_j0(w_s8_encrypted_j0),
        .o_instance_size(w_s8_instance_size),
        .o_h(w_s8_h),
        .o_cipher_text(w_s8_cipher_text),
        .o_tag_ready(w_s8_sblock_ready),
        .o_tag(w_s8_sblock)
    );
    
    aes_pipeline_stage9 stage9(
        .clk(clk),
        .i_cipher_text(w_s8_cipher_text),
        .i_ready(w_s8_sblock_ready),
        .i_h(w_s8_h),
        .i_sblock(w_s8_sblock),
        .i_instance_size(w_s8_instance_size),
        .i_encrypted_j0(w_s8_encrypted_j0),
        .i_phase(w_s8_phase),
        .o_cp_ready(o_cp_ready),
        .o_cipher_text(o_cipher_text),
        .o_tag(o_tag),
        .o_tag_ready(o_tag_ready)
    );

endmodule
