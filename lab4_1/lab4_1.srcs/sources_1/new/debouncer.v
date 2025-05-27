`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.05.2025 15:06:58
// Design Name: 
// Module Name: debouncer
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


module debouncer(
input wire clk_i, min_up, h_up, test, rst_i,
output reg pressed
    );
    parameter delay = 5000000;
    
    always @ (posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            pressed <= 0;
        end
        else begin
            
            
        end
    end
    
endmodule
