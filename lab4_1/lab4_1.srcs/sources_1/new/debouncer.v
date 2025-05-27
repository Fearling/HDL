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
output reg h_1, min_1, test_p
    );
    parameter delay = 5000000;
    reg pressing = 0, pressed = 0;
    integer count = 0;
    
    
    always @ (posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            pressed <= 0;
            pressing <= 0;
        end
        else begin
            pressing <= min_up | h_up | test;
            count <= count + 1;
            if (pressing && pressed == 0) begin
                count <= count + 1;
                if (count > delay) begin
                    count <= 0;
                    if (h_up) begin
                        h_1 <= h_1 + 1;
                    end
                    else if (min_up) begin
                        min_1 <= min_1 + 1;
                    end
                    else if (test) begin
                        test_p <= ~test_p;
                    end
                end
            end
            else if (pressing == 0 && pressed) begin
                count <= count + 1;
                if (count > delay) begin
                    count <= 0;
                    pressed <= 0;
                end
            end
            
        end
    end
    
endmodule
