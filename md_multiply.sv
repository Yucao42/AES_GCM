`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2018 07:33:21 PM
// Design Name: 
// Module Name: md_multiply
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module md_multiply(
    clk,
    i1,
    i2,
    i3,
    o
);


    input clk;
    input logic [0:127] i1;
    input logic [0:127] i2;
    input logic [0:127] i3;
    output logic [0:127] o;
  
    logic [0:127] r_i1;
    logic [0:127] r_i2;
  
    always_ff @(posedge clk)
    begin
        r_i1 <= i1 ^ i2;
        r_i2 <= i3;
    end

    always_comb 
    begin
        o = fn_product(r_i1, r_i2);
    end
  
endmodule
    

module md_encrypt(
    clk,
    i1,
    i2,
    key,
    o
    );


    input clk;
    input logic [0:127] i1;
    input logic [0:3] i2;
    input logic [0:1407] key;
    output logic [0:127] o;
    
    logic [0:127] r_i1;
    logic [0:127] r_i2;
    logic [0:127] r_key;
    
    always_ff @(posedge clk)
    begin
        r_i1 <= i1;
        r_i2 <= i2;
        r_key <= key;
    end

    always_comb 
    begin
        o = fn_aes_encrypt_stage(r_i1, r_key,r_i2);
    end
    
endmodule
    
