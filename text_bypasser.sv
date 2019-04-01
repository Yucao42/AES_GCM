`timescale 1ns / 1ps
module text_bypasser( 
	clk,
	i_text,
	o_text,
	i_tuser,
	o_tuser,
	i_tkeep,
	o_tkeep,
	i_tlast,
	o_tlast
);

    input logic             clk;
    input logic  [0:127]    i_text;
    output logic [0:127]    o_text;
    input logic  [0:127]    i_tuser;
    output logic [0:127]    o_tuser;
    input logic  [0:127]    i_tkeep;
    output logic [0:127]    o_tkeep;
    input logic             i_tlast;
    output logic            o_tlast;

	//logic [0:128 * 16 - 1]  passby1;
    logic  [0:127]          bytext0;
    logic  [0:127]          bytext1;
    logic  [0:127]          bytext2;
    logic  [0:127]          bytext3;
    logic  [0:127]          bytext4;
    logic  [0:127]          bytext5;
    logic  [0:127]          bytext6;
    logic  [0:127]          bytext7;
    logic  [0:127]          bytext8;
    logic  [0:127]          bytext9;
    logic  [0:127]          bytext10;
    logic  [0:127]          bytext11;
    logic  [0:127]          bytext12;
    logic  [0:127]          bytext13;
    logic  [0:127]          bytext14;
    logic  [0:127]          bytext15;

    logic  [0:127]          byins0;
    logic  [0:127]          byins1;
    logic  [0:127]          byins2;
    logic  [0:127]          byins3;
    logic  [0:127]          byins4;
    logic  [0:127]          byins5;
    logic  [0:127]          byins6;
    logic  [0:127]          byins7;
    logic  [0:127]          byins8;
    logic  [0:127]          byins9;
    logic  [0:127]          byins10;
    logic  [0:127]          byins11;
    logic  [0:127]          byins12;
    logic  [0:127]          byins13;

    logic  [0:127]          byaad0;
    logic  [0:127]          byaad1;
    logic  [0:127]          byaad2;
    logic  [0:127]          byaad3;
    logic  [0:127]          byaad4;
    logic  [0:127]          byaad5;
    logic  [0:127]          byaad6;
    logic  [0:127]          byaad7;
    logic  [0:127]          byaad8;
    logic  [0:127]          byaad9;
    logic  [0:127]          byaad10;
    logic  [0:127]          byaad11;
    logic  [0:127]          byaad12;
    logic  [0:127]          byaad13;

    logic                   bysig0;
    logic                   bysig1;
    logic                   bysig2;
    logic                   bysig3;
    logic                   bysig4;
    logic                   bysig5;
    logic                   bysig6;
    logic                   bysig7;
    logic                   bysig8;
    logic                   bysig9;
    logic                   bysig10;
    logic                   bysig11;
    logic                   bysig12;
    logic                   bysig13;

	aes_signal_passing pass
	(
		.clk(clk),
		.i_plain_text(i_text),
		.i_aad(i_tuser),
		.i_signal(i_tlast),
		.i_instance_size(i_tkeep),
		.o_plain_text(bytext0),
		.o_aad(byaad0),
		.o_signal(bysig0),
		.o_instance_size(byins0)
	);

    aes_signal_passing pass0
    (
        .clk(clk),
        .i_plain_text(bytext0),
        .i_aad(byaad0),
        .i_signal(bysig0),
        .i_instance_size(byins0),
        .o_instance_size(byins1),
        .o_aad(byaad1),
        .o_signal(bysig1),
        .o_plain_text(bytext1)
    );
        
    aes_signal_passing pass1
    (
        .clk(clk),
        .i_plain_text(bytext1),
        .i_aad(byaad1),
        .i_signal(bysig1),
        .i_instance_size(byins1),
        .o_instance_size(byins2),
        .o_aad(byaad2),
        .o_signal(bysig2),
        .o_plain_text(bytext2)
    );
        
    aes_signal_passing pass2
    (
        .clk(clk),
        .i_plain_text(bytext2),
        .i_aad(byaad2),
        .i_signal(bysig2),
        .i_instance_size(byins2),
        .o_instance_size(byins3),
        .o_aad(byaad3),
        .o_signal(bysig3),
        .o_plain_text(bytext3)
    );
        
    aes_signal_passing pass3
    (
        .clk(clk),
        .i_plain_text(bytext3),
        .i_aad(byaad3),
        .i_signal(bysig3),
        .i_instance_size(byins3),
        .o_instance_size(byins4),
        .o_aad(byaad4),
        .o_signal(bysig4),
        .o_plain_text(bytext4)
    );
        
    aes_signal_passing pass4
    (
        .clk(clk),
        .i_plain_text(bytext4),
        .i_aad(byaad4),
        .i_signal(bysig4),
        .i_instance_size(byins4),
        .o_instance_size(byins5),
        .o_aad(byaad5),
        .o_signal(bysig5),
        .o_plain_text(bytext5)
    );
        
    aes_signal_passing pass5
    (
        .clk(clk),
        .i_plain_text(bytext5),
        .i_aad(byaad5),
        .i_signal(bysig5),
        .i_instance_size(byins5),
        .o_instance_size(byins6),
        .o_aad(byaad6),
        .o_signal(bysig6),
        .o_plain_text(bytext6)
    );
        
    aes_signal_passing pass6
    (
        .clk(clk),
        .i_plain_text(bytext6),
        .i_aad(byaad6),
        .i_signal(bysig6),
        .i_instance_size(byins6),
        .o_instance_size(byins7),
        .o_aad(byaad7),
        .o_signal(bysig7),
        .o_plain_text(bytext7)
    );
        
    aes_signal_passing pass7
    (
        .clk(clk),
        .i_plain_text(bytext7),
        .i_aad(byaad7),
        .i_signal(bysig7),
        .i_instance_size(byins7),
        .o_instance_size(byins8),
        .o_aad(byaad8),
        .o_signal(bysig8),
        .o_plain_text(bytext8)
    );
        
    aes_signal_passing pass8
    (
        .clk(clk),
        .i_plain_text(bytext8),
        .i_aad(byaad8),
        .i_signal(bysig8),
        .i_instance_size(byins8),
        .o_instance_size(byins9),
        .o_aad(byaad9),
        .o_signal(bysig9),
        .o_plain_text(bytext9)
    );
        
    aes_signal_passing pass9
    (
        .clk(clk),
        .i_plain_text(bytext9),
        .i_aad(byaad9),
        .i_signal(bysig9),
        .i_instance_size(byins9),
        .o_instance_size(byins10),
        .o_aad(byaad10),
        .o_signal(bysig10),
        .o_plain_text(bytext10)
    );
        
    aes_signal_passing pass10
    (
        .clk(clk),
        .i_plain_text(bytext10),
        .i_aad(byaad10),
        .i_signal(bysig10),
        .i_instance_size(byins10),
        .o_instance_size(byins11),
        .o_aad(byaad11),
        .o_signal(bysig11),
        .o_plain_text(bytext11)
    );
        
    aes_signal_passing pass11
    (
        .clk(clk),
        .i_plain_text(bytext11),
        .i_aad(byaad11),
        .i_signal(bysig11),
        .i_instance_size(byins11),
        .o_instance_size(byins12),
        .o_aad(byaad12),
        .o_signal(bysig12),
        .o_plain_text(bytext12)
    );
        
    aes_signal_passing pass12
    (
        .clk(clk),
        .i_plain_text(bytext12),
        .i_aad(byaad12),
        .i_signal(bysig12),
        .i_instance_size(byins12),
        .o_instance_size(byins13),
        .o_aad(byaad13),
        .o_signal(bysig13),
        .o_plain_text(bytext13)
    );
        
        
	aes_signal_passing pass15
	(
		.clk(clk),
		.i_plain_text(bytext13),
		.i_aad(byaad13),
		.i_signal(bysig13),
		.i_instance_size(byins13),
		.o_plain_text(o_text),
		.o_aad(o_tuser),
		.o_signal(o_tlast),
		.o_instance_size(o_tkeep)
	);

endmodule
