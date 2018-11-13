module aes_key_gen2 (
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
        o_key_schedule = fn_key_expansion(128'b0, r_key_schedule, 2);
    end
endmodule

module aes_key_gen3 (
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

module aes_key_gen4 (
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
        o_key_schedule = fn_key_expansion(128'b0, r_key_schedule, 4);
    end
endmodule

module aes_key_gen5 (
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
        o_key_schedule = fn_key_expansion(128'b0, r_key_schedule, 5);
    end
endmodule

module aes_key_gen6 (
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
        o_key_schedule = fn_key_expansion(128'b0, r_key_schedule, 6);
    end
endmodule

module aes_key_gen7 (
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
        o_key_schedule = fn_key_expansion(128'b0, r_key_schedule, 7);
    end
endmodule

module aes_key_gen8 (
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
        o_key_schedule = fn_key_expansion(128'b0, r_key_schedule, 8);
    end
endmodule

module aes_key_gen9 (
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
        o_key_schedule = fn_key_expansion(128'b0, r_key_schedule, 9);
    end
endmodule

module aes_key_gen10 (
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
        o_key_schedule = fn_key_expansion(128'b0, r_key_schedule, 10);
    end
endmodule
