`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2026 06:55:56 PM
// Design Name: 
// Module Name: tb_basys3_accelerator_top
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

module tb_basys3_accelerator_top;

    logic clk;
    logic btnC;
    logic btnU;

    logic led_done;
    logic led_pass;

    // Instantiate the Basys 3 wrapper
    basys3_accelerator_top #(
        .WIDTH(8),
        .N(4)
    ) dut (
        .clk(clk),
        .btnC(btnC),
        .btnU(btnU),
        .led_done(led_done),
        .led_pass(led_pass)
    );


    // 100 MHz clock
    // Period = 10 ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end


    initial begin

        // Initial conditions
        btnC = 0;
        btnU = 1;

        // Hold reset for a few clock cycles
        repeat (3) @(posedge clk);

        // Release reset
        btnU = 0;


        // Press center button
        @(negedge clk);
        btnC = 1;

        @(negedge clk);

        // Release center button
        btnC = 0;


        // Wait until the whole hardware test finishes
        wait (led_done == 1);

        $finish;
    end

endmodule