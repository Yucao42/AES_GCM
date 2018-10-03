`timescale 1ns / 1ps

module testbench(
);

    logic clk = 1'b0;
   
    /*
    * GCM Example 4 from
    * https://csrc.nist.gov/CSRC/media/Projects/Cryptographic-Standards-and-Guidelines/documents/examples/AES_GCM.pdf
    */
    logic [0:127] tag;
    logic [0:127] cipher_key = 128'hFEFFE9928665731C6D6A8F9467308308;
    logic [0:95]  iv         = 96'hCAFEBABEFACEDBADDECAF888;
    logic [0:511] plain_text = 512'hD9313225F88406E5A55909C5AFF5269A86A7A9531534F7DA2E4C303D8A318A721C3C0C95956809532FCF0E2449A6B525B16AEDF5AA0DE657BA637B391AAFD255;
    logic [0:511] aad        = 512'h3AD77BB40D7A3660A89ECAF32466EF97F5D3D58503B9699DE785895A96FDBAAF43B1CD7F598ECE23881B00E3ED0306887B0C785E27E8AD3F8223207104725DD4;
    logic [0:511] cipher_text;
   
    logic [0:127] plain_text_block;
    logic [0:127] aad_block;
    logic [0:1407]  o_key_schedule;
    logic [0:127] cipher_text_block;
    logic new_instance = 0;
    logic pt_instance = 0;
    logic tag_ready;

    
    logic [0:4] counter;
    
    initial
    begin
        counter = 0;
        aad_block = aad[counter*128+:128];
        new_instance = 1;
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
		o_key_schedule = fn_key_expansion(cipher_key);
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
