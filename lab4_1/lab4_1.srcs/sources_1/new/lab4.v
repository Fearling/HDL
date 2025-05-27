`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.05.2025 14:20:24
// Design Name: 
// Module Name: lab4
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


module lab4(
input wire clk_i, rst_i, button_hr_i, button_min_i, button_test_i,
output reg led7_seg_o, led7_an_o
    );
    
    wire button_pressed = 0;
    parameter N = 100000000;
    reg [1:0] h_10 = 0;
    reg [3:0] h_1 = 0, min_10 = 0, min_1 = 0;
    
    
    debouncer d (
        .clk_i(clk_i),
        .button_hr_i(h_up),
        .button_min_i(min_up),
        .button_test_i(test),
        .rst_i(rst_i),
        .button_pressed(pressed)
    );
    
    
    always @ (posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            
        end
        else begin
            
            
        end
    end
endmodule
