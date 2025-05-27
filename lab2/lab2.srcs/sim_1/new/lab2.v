`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.03.2025 19:54:03
// Design Name: 
// Module Name: lab2
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


`timescale 1 ns/ 1 ps
module lab_sim();
// test vector input registers
wire clk_i;
wire rst_i;
// wires
reg led_o;
// assign statements (if any)
lab2 i1 (

// port map - connection between master ports and signals/registers
clk_i,
led_o,
rst_i
);

defparam i1.N=5;
    initial
    begin
        
        clk_i = '0';

    end
    



endmodule
