`timescale 1ns / 1ps
module text_bypasser( 
	clk,
	i_text,
	o_text
);

    input logic             clk;
    input logic  [0:127]    i_text;
    output logic [0:127]    o_text;

	//logic [0:128 * 16 - 1]  passby1;
    logic  [0:127]          bypass0;
    logic  [0:127]          bypass1;
    logic  [0:127]          bypass2;
    logic  [0:127]          bypass3;
    logic  [0:127]          bypass4;
    logic  [0:127]          bypass5;
    logic  [0:127]          bypass6;
    logic  [0:127]          bypass7;
    logic  [0:127]          bypass8;
    logic  [0:127]          bypass9;
    logic  [0:127]          bypass10;
    logic  [0:127]          bypass11;
    logic  [0:127]          bypass12;
    logic  [0:127]          bypass13;
    logic  [0:127]          bypass14;
    logic  [0:127]          bypass15;

	aes_signal_passing pass
	(
		.clk(clk),
		.i_plain_text(i_text),
		.o_plain_text(bypass0)
	);
    aes_signal_passing pass0
    (
        .clk(clk),
        .i_plain_text(bypass0),
        .o_plain_text(bypass1)
    );
        
    aes_signal_passing pass1
    (
        .clk(clk),
        .i_plain_text(bypass1),
        .o_plain_text(bypass2)
    );
        
    aes_signal_passing pass2
    (
        .clk(clk),
        .i_plain_text(bypass2),
        .o_plain_text(bypass3)
    );
        
    aes_signal_passing pass3
    (
        .clk(clk),
        .i_plain_text(bypass3),
        .o_plain_text(bypass4)
    );
        
    aes_signal_passing pass4
    (
        .clk(clk),
        .i_plain_text(bypass4),
        .o_plain_text(bypass5)
    );
        
    aes_signal_passing pass5
    (
        .clk(clk),
        .i_plain_text(bypass5),
        .o_plain_text(bypass6)
    );
        
    aes_signal_passing pass6
    (
        .clk(clk),
        .i_plain_text(bypass6),
        .o_plain_text(bypass7)
    );
        
    aes_signal_passing pass7
    (
        .clk(clk),
        .i_plain_text(bypass7),
        .o_plain_text(bypass8)
    );
        
    aes_signal_passing pass8
    (
        .clk(clk),
        .i_plain_text(bypass8),
        .o_plain_text(bypass9)
    );
        
    aes_signal_passing pass9
    (
        .clk(clk),
        .i_plain_text(bypass9),
        .o_plain_text(bypass10)
    );
        
    aes_signal_passing pass10
    (
        .clk(clk),
        .i_plain_text(bypass10),
        .o_plain_text(bypass11)
    );
        
    aes_signal_passing pass11
    (
        .clk(clk),
        .i_plain_text(bypass11),
        .o_plain_text(bypass12)
    );
        
    aes_signal_passing pass12
    (
        .clk(clk),
        .i_plain_text(bypass12),
        .o_plain_text(bypass13)
    );
        
    //aes_signal_passing pass13
    //(
    //    .clk(clk),
    //    .i_plain_text(bypass13),
    //    .o_plain_text(bypass14)
    //);
    //    
    //aes_signal_passing pass14
    //(
    //    .clk(clk),
    //    .i_plain_text(bypass14),
    //    .o_plain_text(bypass15)
    //);
        
    aes_signal_passing pass15
    (
        .clk(clk),
        .i_plain_text(bypass13),
        .o_plain_text(o_text)
    );
        
endmodule
