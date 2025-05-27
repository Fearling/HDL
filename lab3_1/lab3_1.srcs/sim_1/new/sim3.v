`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2025 14:20:01
// Design Name: 
// Module Name: lab2_sim
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


module lab2_sim();

    reg clk_i;
    reg rst_i;
    reg RXD_i;
    wire TXD_o;
    
    lab2 sim(clk_i, rst_i, led_o);
    integer counter;
        initial begin
            clk_i = 0;
            rst_i = 0;
            counter = 'd0;
            RXD_i = 1;
            #20 RXD_i = 0;
            #20 RXD_i = 1;
            #20 RXD_i = 0;
            #20 RXD_i = 0;
            #20 RXD_i = 1;
            #20 RXD_i = 1;
            #20 RXD_i = 0;
            #20 RXD_i = 0;
            #20 RXD_i = 0;
            #20 RXD_i = 1;
        end
        
        always begin
            #2;
            clk_i = ~clk_i;
            counter = counter+1;
            $monitor("[%0t] counter=%0d clk_i=%0b rst_i=%0b TXD_o = %0b", $time, counter, clk_i, rst_i, TXD_o);
        end
        
        
    
endmodule
