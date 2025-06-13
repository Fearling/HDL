`timescale 1ns / 1ps

module sim5;
    reg clk = 0;
    reg rst = 0;
    reg ps2_clk = 1;
    reg ps2_data = 1;

    wire [7:0] seg;
    wire [7:0] an;

    lab5 uut (
        .clk_i(clk),
        .rst_i(rst),
        .ps2_clk_i(ps2_clk),
        .ps2_data_i(ps2_data),
        .led7_seg_o(seg),
        .led7_an_o(an)
    );

    // Zegar systemowy 100 MHz
    always #5 clk = ~clk;

    // Zadawanie 11-bitowego pakietu PS/2 (1 start, 8 data, parzystoœæ, 1 stop)
    task send_ps2_byte(input [7:0] data);
        integer i;
        reg parity;
        begin
            parity = 1; // parzystoœæ nieparzysta

            // start bit (0)
            ps2_data = 0;
            #100;
            ps2_clk = 0; #50; ps2_clk = 1; #50;

            // 8 bitów danych (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                ps2_data = data[i];
                parity = parity ^ data[i];
                #100;
                ps2_clk = 0; #50; ps2_clk = 1; #50;
            end

            // bit parzystoœci
            ps2_data = ~parity;
            #100;
            ps2_clk = 0; #50; ps2_clk = 1; #50;

            // bit stopu
            ps2_data = 1;
            #100;
            ps2_clk = 0; #50; ps2_clk = 1; #50;

            // krótka przerwa
            #300000;
        end
    endtask

    initial begin
        $display("Start symulacji");

        // Reset
        rst = 1; #100;
        rst = 0; #100;
        rst = 1; #100;

        // Wpisujemy "1", "2", "+", "3", "4", "="
        send_ps2_byte(8'h16); // '1'
        send_ps2_byte(8'h1E); // '2'
        send_ps2_byte(8'h79); // '+'
        send_ps2_byte(8'h26); // '3'
        send_ps2_byte(8'h25); // '4'
        send_ps2_byte(8'h5A); // '=' (Enter)

        // Poczekaj trochê
        #1000000;

        // Wpisujemy "ESC" (reset)
        send_ps2_byte(8'h76); // ESC

        // Poczekaj
        #500000;

        $finish;
    end
endmodule
