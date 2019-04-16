`timescale 1ns / 1ps

/* Top module for AES GCM */
module aes_api(
    clk,
    reset,
    i_new,  // Signal that says it is a new instance
    i_last,  // Signal that says it is a new instance
	i_plain_text,
	i_bypass_text,
	o_bypass_text,
    o_cipher_text,
    o_cp_ready,
);

    input           clk;
    input           reset;
    // Input including 96 bits iv, 128 bits aad block, 128 bits plaintext
    // block and 128 bits input key block.
    input           i_new;
    input           i_last;
	input [0:127]   i_plain_text;
	input [288:0]   i_bypass_text;

    // Cipher_text is ready
    output          o_cp_ready;
    output [0:127]  o_cipher_text;
	output [288:0]  o_bypass_text;

	// By default using all zeros to test the api 
	// TODO: Add customized keys
    reg [15:0]      bitsfromlast;
    reg [15:0]      bits_delay;
    wire [0:95]      iv = 96'd0;
    wire [0:127]     cipher_key = 128'd0;
    wire [0:127]     pt_size;
    wire [0:127]     aad = 128'd0;
    wire             cp_ready_0;
    reg              new_delay;
    reg              last_delay;
    wire             aes_last;
    wire [0:127]     cipher_text_0;
    wire             cp_ready_1;
    wire [0:127]     cipher_text_1;
	wire [288:0]     bypass_text;
	
	// FSM 
	localparam PKT_ZERO_WORD = 0;
	localparam PKT_FIRST_WORD = 1;
	localparam PKT_SECOND_WORD = 2;
	localparam PKT_INNER_WORD = 4;

	logic [3:0]        state, next_state, aes_state;
	
	assign pt_size = ({112'd0, i_bypass_text[48:33] - 14}) << 3; 
	
    always @(posedge clk) begin
		if(reset)
		begin
			state <= PKT_FIRST_WORD;
			//state <= PKT_ZERO_WORD;
	        bits_delay <= i_bypass_text[288: 273];
	        new_delay <= i_new;
	        last_delay <= i_last;
		end
		else
		begin
	        bits_delay <= i_bypass_text[288: 273];
	        new_delay <= i_new;
	        last_delay <= i_last;
            state <= next_state;
        end
    end

    /* GCM AES module (comes from gcm_aes.sv) */
    gcm_aes gcm_aes_instance1(
        .clk(clk),
        .i_iv(iv),
        .i_id(4'd0),
        .i_new_instance(i_new),
        .i_last_instance(i_last),
        .i_cipher_key(cipher_key),
        .i_plain_text(i_plain_text),
        .i_bypass_text(i_bypass_text),
        .i_plain_text_size(pt_size),
        .i_aad_size(64'd0),
        .i_aad(aad),
        .o_bypass_text(bypass_text),
        .o_cp_ready(cp_ready_0),
        .o_cipher_text(cipher_text_0)
    );
    
    /* GCM AES module (comes from gcm_aes.sv) */
    gcm_aes gcm_aes_instance2(
        .clk(clk),
        .i_iv(iv),
        .i_id(4'd1),
        .i_new_instance(new_delay),
        .i_last_instance(last_delay),
        .i_cipher_key(cipher_key),
        .i_plain_text({i_bypass_text[272:161], bits_delay}),
        .i_plain_text_size(pt_size),
        .i_aad_size(64'd0),
        .i_aad(aad),
        .o_cp_ready(cp_ready_1),
        .o_cipher_text(cipher_text_1)
    );
    
	//By pass aes state
	text_bypasser aes_state_bypasser(
		.clk(clk),
		//.i_text({state, i_last}),
		//.o_text({aes_state, aes_last})
		.i_text(state),
		.o_text(aes_state),
		.i_tlast(i_last),
		.o_tlast(aes_last)
	);
   
	//output module
	phase_bypasser outputer(
		.clk(clk),
		.i_state(aes_state),
		.i_last(aes_last),
		.i_text(bypass_text),
		.i_cipher({cipher_text_0, cipher_text_1}),
		.i_ready(cp_ready_0),
		.o_ready(o_cp_ready),
		.o_cipher(o_cipher_text),
		.o_text(o_bypass_text)
	);

	always @(state, i_last, i_new, last_delay)
	begin
	next_state = state;
        case(state)
	    	PKT_ZERO_WORD:
	    	begin
	    		//if(i_new && !i_last)
	    		if(i_new)
	    		begin
	    			next_state = PKT_FIRST_WORD;
	    		end
	    	end

	    	PKT_FIRST_WORD:
	    	begin
	    		//if(i_new && !i_last)
	    		if(i_new)
	    		begin
	    			next_state = PKT_SECOND_WORD;
	    		end
	    	end

	    	PKT_SECOND_WORD:
	    	begin
	    		if(i_new)
	    		begin
	    		    next_state = PKT_INNER_WORD;
	    		end
	    		//else begin
	    		//    next_state = PKT_FIRST_WORD;
	    		//end
	    	end

	    	PKT_INNER_WORD:
	    	begin
	    		if(i_last)
	    			    next_state = PKT_FIRST_WORD;
			//			next_state = PKT_INNER_WORD;
			//	else
	    	//		    next_state = PKT_FIRST_WORD;
	    	end
	    endcase
    end

endmodule
