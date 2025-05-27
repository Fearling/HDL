`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.05.2025 22:48:44
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


`timescale 1ns / 1ps

module lab4_tb;

    reg clk_i = 0;
    reg rst_i = 1;
    reg button_hr_i = 0;
    reg button_min_i = 0;
    reg button_test_i = 0;
    wire [7:0] led7_seg_o;
    wire [7:0] led7_an_o;

lab4 #(.N(10)) uut (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .button_hr_i(button_hr_i),
    .button_min_i(button_min_i),
    .button_test_i(button_test_i),
    .led7_seg_o(led7_seg_o),
    .led7_an_o(led7_an_o)
);


    always #5 clk_i = ~clk_i; // 100 MHz

    initial begin
        #10 rst_i = 0;
        #20 button_hr_i = 1;
        #20 button_hr_i = 0;
    end

endmodule
