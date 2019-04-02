`timescale 1ns / 1ps

module testbench(
);

    logic clk = 1'b1;
   
    /*
   * GCM Example 4 from
    * https://csrc.nist.gov/CSRC/media/Projects/Cryptographic-Standards-and-Guidelines/documents/examples/AES_GCM.pdf
    */
    logic [0:127] tag;

    logic [0:127] cipher_key = 128'd0;
    logic [0:95]  iv         = 96'd0;
    //logic [0:127] plain_text = 128'hD9313225F88406E5A55909C5AFF5269A;
    //logic [127:0] plain_text = 128'hD9313225F88406E5A55909C5AFF5269A;
    logic [127:0] plain_text = 128'h62626262626262626262626262626262;
    logic [288:0] bypass_text = 289'hD9313225F88406E5A55909C5AFF5269A9313225F88406E5A55909C5AFF5269A;
    logic [288:0] o_bypass_text;
    logic [160:0] o_bypass_text_1;
    logic [127:0] o_bypass_text_2;
    //logic [127:0] plain_text = 128'd0;
    logic [0:511] aad        = 128'h3AD77BB40D7A3660A89ECAF32466EF97;
    //logic [0:511] aad        = 128'd0;
    logic [0:511] cipher_text;
    //logic [0:127] i_plain_text = 128'hD9313225F88406E5A55909C5AFF5269A;
    logic [127:0] i_plain_text = 128'h62626262626262626262626262626262;
    //logic [127:0] i_plain_text = 128'hD9313225F88406E5A55909C5AFF5269A;

    logic [0:127] plain_text_block;
    logic [0:127] aad_block;
    logic [0:127] cipher_text_block;
    reg new_instance = 0;
    logic pt_instance = 0;
    logic tag_ready;
    logic ct_ready;
	wire  [31: 0] key = 32'h00000001;
    
	// Reverse bit direction
	genvar n;
	generate
	for(n = 0; n < 16; n = n + 1)
	begin
	    always_comb
	    begin
	    	//i_plain_text[n*8:(n+1)*8-1] = plain_text[(16 - n) * 8 - 1:(15-n) * 8];
	    	i_plain_text[(n+1)*8-1: 8 * n] = plain_text[(16 - n) * 8 - 1:(15 - n) * 8];
	    	//i_plain_text[n*8:(n+1)*8-1] = plain_text[(15 - n) * 8:(16 - n) * 8 - 1];
	    end
	end
    endgenerate

    gcm_aes gcm_aes_instance(
        .clk(clk),
        .i_new_instance(new_instance),
        .i_pt_instance(pt_instance),
        .i_cipher_key(cipher_key),
        .i_iv(iv),
        .i_plain_text(i_plain_text),
        .i_aad(aad_block),
        .i_plain_text_size(64'd128),
        .i_aad_size(64'd0),
        .i_bypass_text({bypass_text[288:128], i_plain_text}),
        //.o_bypass_text(o_bypass_text),
        .o_bypass_text({o_bypass_text_1, o_bypass_text_2}),
        .o_cipher_text(cipher_text_block),
        .o_tag(tag),
        .o_tag_ready(tag_ready),
        .o_cp_ready(ct_ready)
    );

    
    logic [0:4] counter;
    
    initial
    begin
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        new_instance = 1;
        bypass_text = 289'hF5269A;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk; // Posedge
		i_plain_text[0] = 0;
	//new_instance = 0;
        #10 clk = ~clk;
        #10 clk = ~clk;
        bypass_text = 289'h9A;
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
	new_instance = 0;
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge

        counter = 0;
        aad_block = aad[counter*128+:128];
        new_instance = 1;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
		new_instance = 0;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
		/*
        counter = counter + 1;
        aad_block = aad[counter*128+:128];
        new_instance = 0;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        counter = counter + 1;
        aad_block = aad[counter*128+:128];
        new_instance = 0;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        counter = counter + 1;
        aad_block = aad[counter*128+:128];
        new_instance = 0;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
		*/
        counter = 0;
        plain_text_block = plain_text[counter*128+:128];
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        pt_instance = 0;
		

        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
    end
endmodule
