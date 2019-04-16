`timescale 1ns / 1ps
module signal_passing(
    clk,
    i_plain_text,
    o_plain_text
);

    input logic           clk;
    input logic  [288:0]    i_plain_text;
    output logic [288:0]    o_plain_text;

    logic [288:0]   r_plain_text;
    
    always_ff @(posedge clk)
    begin
        r_plain_text    <= i_plain_text;
    end


    always_comb
    begin
        o_plain_text = r_plain_text;
    end
endmodule

module signal_bypasser( 
	clk,
	i_text,
	o_text,
);

    input logic             clk;
    input logic  [288:0]    i_text;
    output logic [288:0]    o_text;

    logic  [288:0]          bytext0;
    logic  [288:0]          bytext1;
    logic  [288:0]          bytext2;
    logic  [288:0]          bytext3;
    logic  [288:0]          bytext4;
    logic  [288:0]          bytext5;
    logic  [288:0]          bytext6;
    logic  [288:0]          bytext7;
    logic  [288:0]          bytext8;
    logic  [288:0]          bytext9;
    logic  [288:0]          bytext10;
    logic  [288:0]          bytext11;
    logic  [288:0]          bytext12;
    logic  [288:0]          bytext13;
    logic  [288:0]          bytext14;
    logic  [288:0]          bytext15;

	signal_passing pass
	(
		.clk(clk),
		.i_plain_text(i_text),
		.o_plain_text(bytext0)
	);

    signal_passing pass0
    (
        .clk(clk),
        .i_plain_text(bytext0),
        .o_plain_text(bytext1)
    );
        
    signal_passing pass1
    (
        .clk(clk),
        .i_plain_text(bytext1),
        .o_plain_text(bytext2)
    );
        
    signal_passing pass2
    (
        .clk(clk),
        .i_plain_text(bytext2),
        .o_plain_text(bytext3)
    );
        
    signal_passing pass3
    (
        .clk(clk),
        .i_plain_text(bytext3),
        .o_plain_text(bytext4)
    );
        
    signal_passing pass4
    (
        .clk(clk),
        .i_plain_text(bytext4),
        .o_plain_text(bytext5)
    );
        
    signal_passing pass5
    (
        .clk(clk),
        .i_plain_text(bytext5),
        .o_plain_text(bytext6)
    );
        
    signal_passing pass6
    (
        .clk(clk),
        .i_plain_text(bytext6),
        .o_plain_text(bytext7)
    );
        
    signal_passing pass7
    (
        .clk(clk),
        .i_plain_text(bytext7),
        .o_plain_text(bytext8)
    );
        
    signal_passing pass8
    (
        .clk(clk),
        .i_plain_text(bytext8),
        .o_plain_text(bytext9)
    );
        
    signal_passing pass9
    (
        .clk(clk),
        .i_plain_text(bytext9),
        .o_plain_text(bytext10)
    );
        
    signal_passing pass10
    (
        .clk(clk),
        .i_plain_text(bytext10),
        .o_plain_text(bytext11)
    );
        
    signal_passing pass11
    (
        .clk(clk),
        .i_plain_text(bytext11),
        .o_plain_text(bytext12)
    );
        
    signal_passing pass12
    (
        .clk(clk),
        .i_plain_text(bytext12),
        .o_plain_text(bytext13)
    );
        
        
	signal_passing pass15
	(
		.clk(clk),
		.i_plain_text(bytext13),
		.o_plain_text(o_text)
	);

endmodule
