module aes_pipeline_stage13 (
    clk,
	i_key_schedule,
    o_key_schedule,
);

    input logic           clk;
    input logic [0:1407]  i_key_schedule;

    output logic [0:1407]  o_key_schedule;

    logic [0:1407]  r_key_schedule;

    always_ff @(posedge clk)
    begin
        r_key_schedule <= i_key_schedule;
    end
    
    always_comb
    begin
        o_key_schedule = fn_key_expansion(128'b0, r_key_schedule, 3);
    end
endmodule
