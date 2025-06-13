`timescale 1ns / 1ps
module ps2_keyboard(
    input wire clk,
    input wire rst_n,
    input wire ps2_clk,
    input wire ps2_data,
    output reg [7:0] data_out,
    output reg new_data
);
    // Minimalny dekoder PS/2 do odczytu bajtów ze strumienia
    // Dzia³a w uproszczonym trybie - trzeba rozbudowaæ o mapê skan kodów -> ASCII

    reg [3:0] bit_count = 0;
    reg [10:0] shift_reg = 0;
    reg ps2_clk_prev = 1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_count <= 0;
            shift_reg <= 0;
            new_data <= 0;
        end else begin
            ps2_clk_prev <= ps2_clk;
            new_data <= 0;

            if (ps2_clk_prev == 1 && ps2_clk == 0) begin
                shift_reg <= {ps2_data, shift_reg[10:1]};
                bit_count <= bit_count + 1;

                if (bit_count == 10) begin
                    data_out <= shift_reg[8:1];
                    new_data <= 1;
                    bit_count <= 0;
                end
            end
        end
    end
endmodule
