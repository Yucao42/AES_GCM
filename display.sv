`timescale 1ns / 1ps

module display(  
        input [0:15] i_x,
        input [0:31] in_count,
        input clk,
        input clr,
        output reg [6:0] a_to_g,
        output reg [3:0] an,
        output wire dp
);
          
    reg [1:0] s;     
    reg [3:0] digit;
    wire [3:0] aen;
    reg [19:0] clkdiv = 0;
    reg [0:15] x;
    reg [0:31] count;
    
    assign dp = 1; 
    assign aen = 4'b1111; // all turned off initially
    
    always_ff @(posedge clk)
    begin
        x <= i_x;
        count <= in_count;
    end
    
    always_comb
    begin
        if (count >= 32'h3b9aca00)
            digit = 0;
        else
        begin
            case(s)
                1:digit = x[0:3]; // s is 00 -->0 ;  digit gets assigned 4 bit value assigned to x[3:0]
                0:digit = x[4:7]; // s is 01 -->1 ;  digit gets assigned 4 bit value assigned to x[7:4]
                3:digit = x[8:11]; // s is 10 -->2 ;  digit gets assigned 4 bit value assigned to x[11:8
                2:digit = x[12:15]; // s is 11 -->3 ;  digit gets assigned 4 bit value assigned to x[15:12]
                default:digit = x[0:3];
            endcase
        end
    end    


    always_comb
    begin
        case(digit)
            //Order of bits for 7 segment display gfedcba
            0:a_to_g = 7'b1000000;////0000                                                                    
            1:a_to_g = 7'b1111001;////0001                                                
            2:a_to_g = 7'b0100100;////0010                                                                                                                              
            3:a_to_g = 7'b0110000;////0011                                              
            4:a_to_g = 7'b0011001;////0100                                              
            5:a_to_g = 7'b0010010;////0101                                                
            6:a_to_g = 7'b0000010;////0110
            7:a_to_g = 7'b1111000;////0111
            8:a_to_g = 7'b0000000;////1000
            9:a_to_g = 7'b0010000;////1001
            'hA:a_to_g = 7'b0001000; 
            'hB:a_to_g = 7'b0000011; 
            'hC:a_to_g = 7'b0100111;
            'hD:a_to_g = 7'b0100001;
            'hE:a_to_g = 7'b0000110;
            'hF:a_to_g = 7'b0001110;
            default: a_to_g = 7'b0000000;
        endcase
    end
    
    always_comb
    begin
        s = clkdiv[19:18];
        an=4'b1111;
        if(aen[s] == 1)
            an[s] = 0;
    end

    always @(posedge clk or posedge clr)
    begin
        if ( clr == 1)
            clkdiv <= 0;
        else
            clkdiv <= clkdiv+1;
    end
endmodule
