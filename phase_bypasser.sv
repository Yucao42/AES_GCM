`timescale 1ns / 1ps
module phase_bypasser( 
	clk,
	i_state,
	i_last,
	i_text,
	o_text,
	i_cipher,
	o_cipher,
	i_ready,
	o_ready
);

    input logic             clk;
    input logic  [288:0]    i_text;
    input logic  [0:3]      i_state;
    input logic             i_last;
    output logic [288:0]    o_text;
	//cipher 0 cipher 1
    input logic  [255:0]    i_cipher;
    output logic [127:0]    o_cipher;
    input logic             i_ready;
    output logic            o_ready;

	//logic [0:128 * 16 - 1]  passby1
    logic  [0:3]      r_1_state;
    logic  [288:0]    r_1_text;
    logic  [255:0]    r_1_cipher;
    logic             r_1_ready;
    logic             r_1_last;
    logic             r_2_last;
    logic             r_3_last;

    //logic             r_2_ready;
    //logic  [0:3]      r_2_state;
    //logic  [255:0]    r_2_cipher;
    //logic  [288:0]    r_2_text;

    logic  [127:0]    w_1_cipher;
    logic  [127:0]    w_2_cipher;
    logic  [127:0]    w_3_cipher;
    logic  [288:0]    w_text;
    logic  [0:3]      w_state;

	// FSM 
	localparam PKT_FIRST_WORD = 1;
	localparam PKT_SECOND_WORD = 2;
	localparam PKT_INNER_WORD = 4;

    always_ff @(posedge clk)
    begin
        //r_2_text          <= r_text;
        //r_2_state         <= r_state;
        //r_2_ready         <= r_ready;
		//r_2_cipher        <= r_cipher;
        r_1_text          <= i_text;
        r_1_state         <= i_state;
        r_1_last         <= i_last;
        r_2_last         <= r_1_last;
        r_3_last         <= r_2_last;
        r_1_ready         <= i_ready;
		r_1_cipher        <= i_cipher;
    end

	always_comb
	begin
        o_text     = w_text;
		o_cipher   = w_2_cipher;
		o_ready    = 0;
		case(i_state)
			PKT_FIRST_WORD:
			begin
				//if(r_1_ready)
				if(i_ready)
				begin
				    begin
                        w_text     = r_1_text;
                        w_state    = PKT_FIRST_WORD;
		                w_1_cipher = r_1_cipher[255:128];
				    end
				end
				else if(w_state == PKT_INNER_WORD)
				begin
					w_state    = PKT_FIRST_WORD;
                    o_text     = {r_1_cipher[15:0], w_1_cipher[127:16], w_text[160:0]};
                    o_ready    = 1;
                    o_cipher   = w_2_cipher;
				end
				else
				begin
					//w_state = PKT_FIRST_WORD;
					w_state = 3;
			    end
			end
					
			PKT_SECOND_WORD:
			begin
				if(i_ready)
				begin
                    o_text     = {i_cipher[15:0], w_text[272:0]};
                    o_ready    = 1;
                    o_cipher   = w_1_cipher;
                    w_state    = PKT_INNER_WORD;
					w_1_cipher = i_cipher[127:0];   //cipher 1 
					w_2_cipher = i_cipher[255:128]; //cipher 0  
                    w_text     = i_text;
				end
			end

			PKT_INNER_WORD:
			begin
				if(!r_2_last)
				begin
                    o_text     = {i_cipher[15:0], w_1_cipher[127:16], w_text[160:0]};
                    o_ready    = 1;
                    o_cipher   = w_2_cipher;
                    w_state    = PKT_INNER_WORD;
					w_1_cipher = i_cipher[127:0];
					w_2_cipher = i_cipher[255:128];
                    w_text     = i_text;
				end
				else
				begin
					w_state = PKT_FIRST_WORD;
				end
			end
		endcase
	end

	
endmodule
