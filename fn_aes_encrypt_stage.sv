`timescale 1ns / 1ps

function logic [0:127] fn_aes_encrypt_stage(
    input logic [0:127]   in_state,
    input logic [0:1407]  key_schedule,
    input logic [0:31]     round
);

    const bit [0:7] SBOX [256] = {
        8'h63, 8'h7c, 8'h77, 8'h7b, 8'hf2, 8'h6b, 8'h6f, 8'hc5, 8'h30, 8'h01, 8'h67, 8'h2b, 8'hfe, 8'hd7, 8'hab, 8'h76,
        8'hca, 8'h82, 8'hc9, 8'h7d, 8'hfa, 8'h59, 8'h47, 8'hf0, 8'had, 8'hd4, 8'ha2, 8'haf, 8'h9c, 8'ha4, 8'h72, 8'hc0,
        8'hb7, 8'hfd, 8'h93, 8'h26, 8'h36, 8'h3f, 8'hf7, 8'hcc, 8'h34, 8'ha5, 8'he5, 8'hf1, 8'h71, 8'hd8, 8'h31, 8'h15,
        8'h04, 8'hc7, 8'h23, 8'hc3, 8'h18, 8'h96, 8'h05, 8'h9a, 8'h07, 8'h12, 8'h80, 8'he2, 8'heb, 8'h27, 8'hb2, 8'h75,
        8'h09, 8'h83, 8'h2c, 8'h1a, 8'h1b, 8'h6e, 8'h5a, 8'ha0, 8'h52, 8'h3b, 8'hd6, 8'hb3, 8'h29, 8'he3, 8'h2f, 8'h84,
        8'h53, 8'hd1, 8'h00, 8'hed, 8'h20, 8'hfc, 8'hb1, 8'h5b, 8'h6a, 8'hcb, 8'hbe, 8'h39, 8'h4a, 8'h4c, 8'h58, 8'hcf,
        8'hd0, 8'hef, 8'haa, 8'hfb, 8'h43, 8'h4d, 8'h33, 8'h85, 8'h45, 8'hf9, 8'h02, 8'h7f, 8'h50, 8'h3c, 8'h9f, 8'ha8,
        8'h51, 8'ha3, 8'h40, 8'h8f, 8'h92, 8'h9d, 8'h38, 8'hf5, 8'hbc, 8'hb6, 8'hda, 8'h21, 8'h10, 8'hff, 8'hf3, 8'hd2,
        8'hcd, 8'h0c, 8'h13, 8'hec, 8'h5f, 8'h97, 8'h44, 8'h17, 8'hc4, 8'ha7, 8'h7e, 8'h3d, 8'h64, 8'h5d, 8'h19, 8'h73,
        8'h60, 8'h81, 8'h4f, 8'hdc, 8'h22, 8'h2a, 8'h90, 8'h88, 8'h46, 8'hee, 8'hb8, 8'h14, 8'hde, 8'h5e, 8'h0b, 8'hdb,
        8'he0, 8'h32, 8'h3a, 8'h0a, 8'h49, 8'h06, 8'h24, 8'h5c, 8'hc2, 8'hd3, 8'hac, 8'h62, 8'h91, 8'h95, 8'he4, 8'h79,
        8'he7, 8'hc8, 8'h37, 8'h6d, 8'h8d, 8'hd5, 8'h4e, 8'ha9, 8'h6c, 8'h56, 8'hf4, 8'hea, 8'h65, 8'h7a, 8'hae, 8'h08,
        8'hba, 8'h78, 8'h25, 8'h2e, 8'h1c, 8'ha6, 8'hb4, 8'hc6, 8'he8, 8'hdd, 8'h74, 8'h1f, 8'h4b, 8'hbd, 8'h8b, 8'h8a,
        8'h70, 8'h3e, 8'hb5, 8'h66, 8'h48, 8'h03, 8'hf6, 8'h0e, 8'h61, 8'h35, 8'h57, 8'hb9, 8'h86, 8'hc1, 8'h1d, 8'h9e,
        8'he1, 8'hf8, 8'h98, 8'h11, 8'h69, 8'hd9, 8'h8e, 8'h94, 8'h9b, 8'h1e, 8'h87, 8'he9, 8'hce, 8'h55, 8'h28, 8'hdf,
        8'h8c, 8'ha1, 8'h89, 8'h0d, 8'hbf, 8'he6, 8'h42, 8'h68, 8'h41, 8'h99, 8'h2d, 8'h0f, 8'hb0, 8'h54, 8'hbb, 8'h16
    };

    const bit [0:7] gf_table_2 [256] = {
        8'h00, 8'h02, 8'h04, 8'h06, 8'h08, 8'h0a, 8'h0c, 8'h0e, 8'h10, 8'h12, 8'h14, 8'h16, 8'h18, 8'h1a, 8'h1c, 8'h1e,
        8'h20, 8'h22, 8'h24, 8'h26, 8'h28, 8'h2a, 8'h2c, 8'h2e, 8'h30, 8'h32, 8'h34, 8'h36, 8'h38, 8'h3a, 8'h3c, 8'h3e,
        8'h40, 8'h42, 8'h44, 8'h46, 8'h48, 8'h4a, 8'h4c, 8'h4e, 8'h50, 8'h52, 8'h54, 8'h56, 8'h58, 8'h5a, 8'h5c, 8'h5e,
        8'h60, 8'h62, 8'h64, 8'h66, 8'h68, 8'h6a, 8'h6c, 8'h6e, 8'h70, 8'h72, 8'h74, 8'h76, 8'h78, 8'h7a, 8'h7c, 8'h7e,
        8'h80, 8'h82, 8'h84, 8'h86, 8'h88, 8'h8a, 8'h8c, 8'h8e, 8'h90, 8'h92, 8'h94, 8'h96, 8'h98, 8'h9a, 8'h9c, 8'h9e,
        8'ha0, 8'ha2, 8'ha4, 8'ha6, 8'ha8, 8'haa, 8'hac, 8'hae, 8'hb0, 8'hb2, 8'hb4, 8'hb6, 8'hb8, 8'hba, 8'hbc, 8'hbe,
        8'hc0, 8'hc2, 8'hc4, 8'hc6, 8'hc8, 8'hca, 8'hcc, 8'hce, 8'hd0, 8'hd2, 8'hd4, 8'hd6, 8'hd8, 8'hda, 8'hdc, 8'hde,
        8'he0, 8'he2, 8'he4, 8'he6, 8'he8, 8'hea, 8'hec, 8'hee, 8'hf0, 8'hf2, 8'hf4, 8'hf6, 8'hf8, 8'hfa, 8'hfc, 8'hfe,
        8'h1b, 8'h19, 8'h1f, 8'h1d, 8'h13, 8'h11, 8'h17, 8'h15, 8'h0b, 8'h09, 8'h0f, 8'h0d, 8'h03, 8'h01, 8'h07, 8'h05,
        8'h3b, 8'h39, 8'h3f, 8'h3d, 8'h33, 8'h31, 8'h37, 8'h35, 8'h2b, 8'h29, 8'h2f, 8'h2d, 8'h23, 8'h21, 8'h27, 8'h25,
        8'h5b, 8'h59, 8'h5f, 8'h5d, 8'h53, 8'h51, 8'h57, 8'h55, 8'h4b, 8'h49, 8'h4f, 8'h4d, 8'h43, 8'h41, 8'h47, 8'h45,
        8'h7b, 8'h79, 8'h7f, 8'h7d, 8'h73, 8'h71, 8'h77, 8'h75, 8'h6b, 8'h69, 8'h6f, 8'h6d, 8'h63, 8'h61, 8'h67, 8'h65,
        8'h9b, 8'h99, 8'h9f, 8'h9d, 8'h93, 8'h91, 8'h97, 8'h95, 8'h8b, 8'h89, 8'h8f, 8'h8d, 8'h83, 8'h81, 8'h87, 8'h85,
        8'hbb, 8'hb9, 8'hbf, 8'hbd, 8'hb3, 8'hb1, 8'hb7, 8'hb5, 8'hab, 8'ha9, 8'haf, 8'had, 8'ha3, 8'ha1, 8'ha7, 8'ha5,
        8'hdb, 8'hd9, 8'hdf, 8'hdd, 8'hd3, 8'hd1, 8'hd7, 8'hd5, 8'hcb, 8'hc9, 8'hcf, 8'hcd, 8'hc3, 8'hc1, 8'hc7, 8'hc5,
        8'hfb, 8'hf9, 8'hff, 8'hfd, 8'hf3, 8'hf1, 8'hf7, 8'hf5, 8'heb, 8'he9, 8'hef, 8'hed, 8'he3, 8'he1, 8'he7, 8'he5
    };

    const bit [0:7] gf_table_3 [256] = {
        8'h00, 8'h03, 8'h06, 8'h05, 8'h0c, 8'h0f, 8'h0a, 8'h09, 8'h18, 8'h1b, 8'h1e, 8'h1d, 8'h14, 8'h17, 8'h12, 8'h11,
        8'h30, 8'h33, 8'h36, 8'h35, 8'h3c, 8'h3f, 8'h3a, 8'h39, 8'h28, 8'h2b, 8'h2e, 8'h2d, 8'h24, 8'h27, 8'h22, 8'h21,
        8'h60, 8'h63, 8'h66, 8'h65, 8'h6c, 8'h6f, 8'h6a, 8'h69, 8'h78, 8'h7b, 8'h7e, 8'h7d, 8'h74, 8'h77, 8'h72, 8'h71,
        8'h50, 8'h53, 8'h56, 8'h55, 8'h5c, 8'h5f, 8'h5a, 8'h59, 8'h48, 8'h4b, 8'h4e, 8'h4d, 8'h44, 8'h47, 8'h42, 8'h41,
        8'hc0, 8'hc3, 8'hc6, 8'hc5, 8'hcc, 8'hcf, 8'hca, 8'hc9, 8'hd8, 8'hdb, 8'hde, 8'hdd, 8'hd4, 8'hd7, 8'hd2, 8'hd1,
        8'hf0, 8'hf3, 8'hf6, 8'hf5, 8'hfc, 8'hff, 8'hfa, 8'hf9, 8'he8, 8'heb, 8'hee, 8'hed, 8'he4, 8'he7, 8'he2, 8'he1,
        8'ha0, 8'ha3, 8'ha6, 8'ha5, 8'hac, 8'haf, 8'haa, 8'ha9, 8'hb8, 8'hbb, 8'hbe, 8'hbd, 8'hb4, 8'hb7, 8'hb2, 8'hb1,
        8'h90, 8'h93, 8'h96, 8'h95, 8'h9c, 8'h9f, 8'h9a, 8'h99, 8'h88, 8'h8b, 8'h8e, 8'h8d, 8'h84, 8'h87, 8'h82, 8'h81,
        8'h9b, 8'h98, 8'h9d, 8'h9e, 8'h97, 8'h94, 8'h91, 8'h92, 8'h83, 8'h80, 8'h85, 8'h86, 8'h8f, 8'h8c, 8'h89, 8'h8a,
        8'hab, 8'ha8, 8'had, 8'hae, 8'ha7, 8'ha4, 8'ha1, 8'ha2, 8'hb3, 8'hb0, 8'hb5, 8'hb6, 8'hbf, 8'hbc, 8'hb9, 8'hba,
        8'hfb, 8'hf8, 8'hfd, 8'hfe, 8'hf7, 8'hf4, 8'hf1, 8'hf2, 8'he3, 8'he0, 8'he5, 8'he6, 8'hef, 8'hec, 8'he9, 8'hea,
        8'hcb, 8'hc8, 8'hcd, 8'hce, 8'hc7, 8'hc4, 8'hc1, 8'hc2, 8'hd3, 8'hd0, 8'hd5, 8'hd6, 8'hdf, 8'hdc, 8'hd9, 8'hda,
        8'h5b, 8'h58, 8'h5d, 8'h5e, 8'h57, 8'h54, 8'h51, 8'h52, 8'h43, 8'h40, 8'h45, 8'h46, 8'h4f, 8'h4c, 8'h49, 8'h4a,
        8'h6b, 8'h68, 8'h6d, 8'h6e, 8'h67, 8'h64, 8'h61, 8'h62, 8'h73, 8'h70, 8'h75, 8'h76, 8'h7f, 8'h7c, 8'h79, 8'h7a,
        8'h3b, 8'h38, 8'h3d, 8'h3e, 8'h37, 8'h34, 8'h31, 8'h32, 8'h23, 8'h20, 8'h25, 8'h26, 8'h2f, 8'h2c, 8'h29, 8'h2a,
        8'h0b, 8'h08, 8'h0d, 8'h0e, 8'h07, 8'h04, 8'h01, 8'h02, 8'h13, 8'h10, 8'h15, 8'h16, 8'h1f, 8'h1c, 8'h19, 8'h1a
    };

    const bit [0:7] rcon [256] = {
        8'h8d, 8'h01, 8'h02, 8'h04, 8'h08, 8'h10, 8'h20, 8'h40, 8'h80, 8'h1b, 8'h36, 8'h6c, 8'hd8, 8'hab, 8'h4d, 8'h9a,
        8'h2f, 8'h5e, 8'hbc, 8'h63, 8'hc6, 8'h97, 8'h35, 8'h6a, 8'hd4, 8'hb3, 8'h7d, 8'hfa, 8'hef, 8'hc5, 8'h91, 8'h39,
        8'h72, 8'he4, 8'hd3, 8'hbd, 8'h61, 8'hc2, 8'h9f, 8'h25, 8'h4a, 8'h94, 8'h33, 8'h66, 8'hcc, 8'h83, 8'h1d, 8'h3a,
        8'h74, 8'he8, 8'hcb, 8'h8d, 8'h01, 8'h02, 8'h04, 8'h08, 8'h10, 8'h20, 8'h40, 8'h80, 8'h1b, 8'h36, 8'h6c, 8'hd8,
        8'hab, 8'h4d, 8'h9a, 8'h2f, 8'h5e, 8'hbc, 8'h63, 8'hc6, 8'h97, 8'h35, 8'h6a, 8'hd4, 8'hb3, 8'h7d, 8'hfa, 8'hef,
        8'hc5, 8'h91, 8'h39, 8'h72, 8'he4, 8'hd3, 8'hbd, 8'h61, 8'hc2, 8'h9f, 8'h25, 8'h4a, 8'h94, 8'h33, 8'h66, 8'hcc,
        8'h83, 8'h1d, 8'h3a, 8'h74, 8'he8, 8'hcb, 8'h8d, 8'h01, 8'h02, 8'h04, 8'h08, 8'h10, 8'h20, 8'h40, 8'h80, 8'h1b,
        8'h36, 8'h6c, 8'hd8, 8'hab, 8'h4d, 8'h9a, 8'h2f, 8'h5e, 8'hbc, 8'h63, 8'hc6, 8'h97, 8'h35, 8'h6a, 8'hd4, 8'hb3,
        8'h7d, 8'hfa, 8'hef, 8'hc5, 8'h91, 8'h39, 8'h72, 8'he4, 8'hd3, 8'hbd, 8'h61, 8'hc2, 8'h9f, 8'h25, 8'h4a, 8'h94,
        8'h33, 8'h66, 8'hcc, 8'h83, 8'h1d, 8'h3a, 8'h74, 8'he8, 8'hcb, 8'h8d, 8'h01, 8'h02, 8'h04, 8'h08, 8'h10, 8'h20,
        8'h40, 8'h80, 8'h1b, 8'h36, 8'h6c, 8'hd8, 8'hab, 8'h4d, 8'h9a, 8'h2f, 8'h5e, 8'hbc, 8'h63, 8'hc6, 8'h97, 8'h35,
        8'h6a, 8'hd4, 8'hb3, 8'h7d, 8'hfa, 8'hef, 8'hc5, 8'h91, 8'h39, 8'h72, 8'he4, 8'hd3, 8'hbd, 8'h61, 8'hc2, 8'h9f,
        8'h25, 8'h4a, 8'h94, 8'h33, 8'h66, 8'hcc, 8'h83, 8'h1d, 8'h3a, 8'h74, 8'he8, 8'hcb, 8'h8d, 8'h01, 8'h02, 8'h04,
        8'h08, 8'h10, 8'h20, 8'h40, 8'h80, 8'h1b, 8'h36, 8'h6c, 8'hd8, 8'hab, 8'h4d, 8'h9a, 8'h2f, 8'h5e, 8'hbc, 8'h63,
        8'hc6, 8'h97, 8'h35, 8'h6a, 8'hd4, 8'hb3, 8'h7d, 8'hfa, 8'hef, 8'hc5, 8'h91, 8'h39, 8'h72, 8'he4, 8'hd3, 8'hbd,
        8'h61, 8'hc2, 8'h9f, 8'h25, 8'h4a, 8'h94, 8'h33, 8'h66, 8'hcc, 8'h83, 8'h1d, 8'h3a, 8'h74, 8'he8, 8'hcb, 8'h8d
    };

    parameter IV_SIZE           = 96;
    parameter BLOCK_SIZE        = 128;
    parameter PLAIN_TEXT_SIZE   = 128;
    parameter AAD_SIZE          = 128; // Ignoring AAD for now
    parameter TAG_SIZE          = 128;
    parameter AUTH_INPUT_SIZE   = 640; //AAD_SIZE + PLAIN_TEXT_SIZE + 64 + 64 (Ignoring AAD length for now)
    logic [0:127]    o_state;

    logic [0:127]    state_0;
    logic [0:127]    state_1;


    logic [0:127]    mix_column_state_0;


        $display("--------------------Input--------------------");
        $display("State: %h", in_state);
        $display("Round Key Value: %h", key_schedule[0:127]);

        $display("-------------------- Round 0 --------------------");

        if (round-1 == 0)
        begin
            state_0 = in_state ^ key_schedule[0:127]; // Adding the first round key
        end
        else
        begin
            state_0 = in_state;
        end

        $display("After AddRoundKey %h", state_0);

        $display("-------------------- Round 1 --------------------");
        $display("State: %h", state_0);

        // Applying SubBytes operation

    state_0[0+:8]   = SBOX[state_0[0+:8]];
    state_0[8+:8]   = SBOX[state_0[8+:8]];
    state_0[16+:8]  = SBOX[state_0[16+:8]];
    state_0[24+:8]  = SBOX[state_0[24+:8]];
    state_0[32+:8]  = SBOX[state_0[32+:8]];
    state_0[40+:8]  = SBOX[state_0[40+:8]];
    state_0[48+:8]  = SBOX[state_0[48+:8]];
    state_0[56+:8]  = SBOX[state_0[56+:8]];
    state_0[64+:8]  = SBOX[state_0[64+:8]];
    state_0[72+:8]  = SBOX[state_0[72+:8]];
    state_0[80+:8]  = SBOX[state_0[80+:8]];
    state_0[88+:8]  = SBOX[state_0[88+:8]];
    state_0[96+:8]  = SBOX[state_0[96+:8]];
    state_0[104+:8] = SBOX[state_0[104+:8]];
    state_0[112+:8] = SBOX[state_0[112+:8]];
    state_0[120+:8] = SBOX[state_0[120+:8]];

    //$display("After SubBytes: %h", state_0);

    // Applying ShiftRows operation on the state_0
    {state_0[(0 * 8)+0 +:8], state_0[(0 * 8)+32 +:8], state_0[(0 * 8)+64 +:8], state_0[(0 * 8)+96 +:8]} =
        {state_0[(0 * 8)+0 +:8], state_0[(0 * 8)+32 +:8], state_0[(0 * 8)+64 +:8], state_0[(0 * 8)+96 +:8]};
    {state_0[(1 * 8)+0 +:8], state_0[(1 * 8)+32 +:8], state_0[(1 * 8)+64 +:8], state_0[(1 * 8)+96 +:8]} =
        {state_0[(1 * 8)+32 +:8], state_0[(1 * 8)+64 +:8], state_0[(1 * 8)+96 +:8], state_0[(1 * 8)+0 +:8]};
    {state_0[(2 * 8)+0 +:8], state_0[(2 * 8)+32 +:8], state_0[(2 * 8)+64 +:8], state_0[(2 * 8)+96 +:8]} =
        {state_0[(2 * 8)+64 +:8], state_0[(2 * 8)+96 +:8], state_0[(2 * 8)+0 +:8], state_0[(2 * 8)+32 +:8]};
    {state_0[(3 * 8)+0 +:8], state_0[(3 * 8)+32 +:8], state_0[(3 * 8)+64 +:8], state_0[(3 * 8)+96 +:8]} =
        {state_0[(3 * 8)+96 +:8], state_0[(3 * 8)+0 +:8], state_0[(3 * 8)+32 +:8], state_0[(3 * 8)+64 +:8]};

    //$display("After ShiftRows: %h", state_0);

    // Applying MixColumns operation
	//
	if (round != 10)
	begin
        mix_column_state_0[0*32+0  +:8]  = gf_table_2[state_0[0*32+0+:8]] ^ gf_table_3[state_0[0*32+8+:8]] ^ state_0[0*32+16+:8] ^ state_0[0*32+24+:8];
        mix_column_state_0[0*32+8  +:8]  = state_0[0*32+0+:8] ^ gf_table_2[state_0[0*32+8+:8]] ^ gf_table_3[state_0[0*32+16+:8]] ^ state_0[0*32+24+:8];
        mix_column_state_0[0*32+16 +:8]  = state_0[0*32+0+:8] ^ state_0[0*32+8+:8] ^ gf_table_2[state_0[0*32+16+:8]] ^ gf_table_3[state_0[0*32+24+:8]];
        mix_column_state_0[0*32+24 +:8]  = gf_table_3[state_0[0*32+0+:8]] ^ state_0[0*32+8+:8] ^ state_0[0*32+16+:8] ^ gf_table_2[state_0[0*32+24+:8]];
 
        mix_column_state_0[1*32+0  +:8]  = gf_table_2[state_0[1*32+0+:8]] ^ gf_table_3[state_0[1*32+8+:8]] ^ state_0[1*32+16+:8] ^ state_0[1*32+24+:8];
        mix_column_state_0[1*32+8  +:8]  = state_0[1*32+0+:8] ^ gf_table_2[state_0[1*32+8+:8]] ^ gf_table_3[state_0[1*32+16+:8]] ^ state_0[1*32+24+:8];
        mix_column_state_0[1*32+16 +:8]  = state_0[1*32+0+:8] ^ state_0[1*32+8+:8] ^ gf_table_2[state_0[1*32+16+:8]] ^ gf_table_3[state_0[1*32+24+:8]];
        mix_column_state_0[1*32+24 +:8]  = gf_table_3[state_0[1*32+0+:8]] ^ state_0[1*32+8+:8] ^ state_0[1*32+16+:8] ^ gf_table_2[state_0[1*32+24+:8]];
 
        mix_column_state_0[2*32+0  +:8]  = gf_table_2[state_0[2*32+0+:8]] ^ gf_table_3[state_0[2*32+8+:8]] ^ state_0[2*32+16+:8] ^ state_0[2*32+24+:8];
        mix_column_state_0[2*32+8  +:8]  = state_0[2*32+0+:8] ^ gf_table_2[state_0[2*32+8+:8]] ^ gf_table_3[state_0[2*32+16+:8]] ^ state_0[2*32+24+:8];
        mix_column_state_0[2*32+16 +:8]  = state_0[2*32+0+:8] ^ state_0[2*32+8+:8] ^ gf_table_2[state_0[2*32+16+:8]] ^ gf_table_3[state_0[2*32+24+:8]];
        mix_column_state_0[2*32+24 +:8]  = gf_table_3[state_0[2*32+0+:8]] ^ state_0[2*32+8+:8] ^ state_0[2*32+16+:8] ^ gf_table_2[state_0[2*32+24+:8]];
 
        mix_column_state_0[3*32+0  +:8]  = gf_table_2[state_0[3*32+0+:8]] ^ gf_table_3[state_0[3*32+8+:8]] ^ state_0[3*32+16+:8] ^ state_0[3*32+24+:8];
        mix_column_state_0[3*32+8  +:8]  = state_0[3*32+0+:8] ^ gf_table_2[state_0[3*32+8+:8]] ^ gf_table_3[state_0[3*32+16+:8]] ^ state_0[3*32+24+:8];
        mix_column_state_0[3*32+16 +:8]  = state_0[3*32+0+:8] ^ state_0[3*32+8+:8] ^ gf_table_2[state_0[3*32+16+:8]] ^ gf_table_3[state_0[3*32+24+:8]];
        mix_column_state_0[3*32+24 +:8]  = gf_table_3[state_0[3*32+0+:8]] ^ state_0[3*32+8+:8] ^ state_0[3*32+16+:8] ^ gf_table_2[state_0[3*32+24+:8]];
	end
	else
	begin
		mix_column_state_0 = state_0;
	end

    //$display("After MixColumns: %h", mix_column_state_0);

    // Applying AddRoundKey operation to the state
    state_1 = mix_column_state_0 ^ key_schedule[(round)*128 +:128];

	return state_1;
endfunction
