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
    logic [0:127] plain_text = 128'd0;
    //logic [0:511] aad        = 128'h3AD77BB40D7A3660A89ECAF32466EF97;
    logic [0:511] aad        = 128'd0;
    logic [0:511] cipher_text;

    logic [0:127] plain_text_block;
    logic [0:127] aad_block;
    logic [0:127] cipher_text_block;
    logic new_instance = 0;
    logic pt_instance = 0;
    logic tag_ready;
    logic ct_ready;
    
    aes_pipeline_stage1 stg1_instance(
        .clk(clk),
        .i_new_instance(new_instance),
        .i_pt_instance(pt_instance),
        .i_cipher_key(cipher_key),
        .i_iv(iv),
        .i_plain_text(plain_text),
        .i_aad(aad_block),
        .i_instance_size({64'd0, 64'd128}),
        .o_plain_text,
        .o_aad,
        .o_iv,
        .o_instance_size,
        .o_new_instance,
        .o_phase,
        .o_pt_instance
    );

    
    logic [0:4] counter;
    
    initial
    begin
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        new_instance = 1;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk; // Posedge
        #10 clk = ~clk;
		new_instance = 0;
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
    end
endmodule
