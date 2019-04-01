module aes_signal_passing(
    clk,
    i_plain_text,
    i_aad,
    i_instance_size,
	i_signal,
	o_signal,
    o_plain_text,
    o_aad,
    o_instance_size
);

    input logic           clk;
    input logic           i_signal;
    input logic [0:127]   i_plain_text;
    input logic [0:127]   i_aad;
    input logic [0:127]   i_instance_size;
    
    output logic [0:127]    o_plain_text;
    output logic            o_signal;
    output logic [0:127]    o_aad;
    output logic [0:127]    o_instance_size;
    
    logic [0:127]   r_plain_text;
    logic [0:127]   r_aad;
    logic [0:127]   r_instance_size;
    logic           r_signal;
    
    always_ff @(posedge clk)
    begin
        r_plain_text    <= i_plain_text;
        r_aad           <= i_aad;
        r_instance_size <= i_instance_size;
		r_signal        <= i_signal;
    end


    always_comb
    begin
        o_plain_text = r_plain_text;
        o_aad = r_aad;
        o_instance_size = r_instance_size;
		o_signal = r_signal;
    end

endmodule
