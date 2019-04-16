`timescale 1ns / 1ps

module testbench(
);

    logic clk = 1'b1;
   
    /*
   * GCM Example 4 from
    * https://csrc.nist.gov/CSRC/media/Projects/Cryptographic-Standards-and-Guidelines/documents/examples/AES_GCM.pdf
    */
    logic [127:0] plain_text = 128'hD9313225F88406E5A55909C5AFF5269A;

	// In total 64 + 14 bytes
    logic [288:0] bypass_text = 289'hD9313225F88406E5A55909C5AFF5269A9313225F88406E5A00000DCAFF5269A;
    logic [288:0] o_bypass_text;
    logic [0:511] cipher_text;
    logic [127:0] i_plain_text = 128'hD9313225F88406E5A55909C5AFF5269A;

    logic [0:127] o_cipher_text;
    reg new_instance = 0;
    logic last_instance = 0;
	logic ct_ready;
	logic reset;

    logic [127:0] plain_text_1 = 128'hD9313225F88406E5A55909C5AFF5269A;
    logic [127:0] plain_text_2 = 128'hD9313225F88406E5A55909C5AFF5269A;
    logic ct_ready_d1;
    logic ct_ready_d2;

    always_ff @(posedge clk)
    begin
        ct_ready_d2   <= ct_ready_d1; // Cycle
        ct_ready_d1   <= ct_ready; // Cycle
		plain_text_2  <= plain_text_1;
		plain_text_1  <= i_plain_text;
	//	bypass_text   <= bypass_text + 1;
    end

    //always_ff @(negedge clk)
    //always_ff @(posedge clk)
    //begin
	//	bypass_text   <= bypass_text + 1;
    //end
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

    aes_api gcm_aes_instance(
        .clk(clk),
        .reset(reset),
        .i_new(new_instance),
        .i_last(last_instance),
        .i_plain_text(i_plain_text),
        .i_bypass_text({16'h0, 112'h0, bypass_text[160:0]}),
        .o_bypass_text(o_bypass_text),
        .o_cipher_text(o_cipher_text),
        .o_cp_ready(ct_ready)
    );

    
    logic [0:4] counter;
    
    initial
    begin
        #10 clk = ~clk; // Posedge
        reset = 1;
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedgej
        reset = 0;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk; // Posedge
	    //bypass_text = bypass_text + 1;
	    bypass_text[15:0] = 16'hff00;
        new_instance = 1;
        #10 clk = ~clk;
        #10 clk = ~clk;
        new_instance = 0;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk; // Posedge
        new_instance = 1;
	    bypass_text = bypass_text + 1;
	    bypass_text[15:0] = 16'h0f01;
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        new_instance = 0;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk; // Posedge
        new_instance = 1;
	    bypass_text = bypass_text + 1;
	    last_instance = 1;
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
	    last_instance = 0;
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
        //new_instance = 1;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
		//new_instance = 0;
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
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk; // Posedge
        new_instance = 1;
        #10 clk = ~clk;
        #10 clk = ~clk;
        new_instance = 0;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk; // Posedge
        new_instance = 1;
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        new_instance = 0;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk; // Posedge
        new_instance = 1;
	    last_instance = 1;
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
	    last_instance = 0;
	    new_instance = 0;
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk; // Posedge
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
        //new_instance = 1;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
		//new_instance = 0;
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
        //new_instance = 1;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
		//new_instance = 0;
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        //new_instance = 1;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
		//new_instance = 0;
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
    end
endmodule
