`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2026 10:04:04 PM
// Design Name: 
// Module Name: tb_systolic_array_2x2
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
module tb_systolic_array_2x2;

parameter WIDTH = 8;

logic clk;
logic rst;
logic clear;
logic en;

logic [WIDTH-1:0] a_left [2];
logic [WIDTH-1:0] b_top  [2];

logic [2*WIDTH+1:0] C [2][2];

systolic_array_2x2 #(
    .WIDTH(WIDTH)
) uut (
    .clk(clk),
    .rst(rst),
    .clear(clear),
    .en(en),
    .a_left(a_left),
    .b_top(b_top),
    .C(C)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    clear = 0;
    en = 0;

    a_left[0] = '0;
    a_left[1] = '0;
    b_top[0]  = '0;
    b_top[1]  = '0;

    #10;
    rst = 0;

    clear = 1;
    #10;
    clear = 0;

    en = 1;

    // Cycle 1
    a_left[0] = 8'd1;  // A00
    a_left[1] = 8'd0;
    b_top[0]  = 8'd5;  // B00
    b_top[1]  = 8'd0;

    #10;

    // Cycle 2
    a_left[0] = 8'd2;  // A01
    a_left[1] = 8'd3;  // A10
    b_top[0]  = 8'd7;  // B10
    b_top[1]  = 8'd6;  // B01

    #10;

    // Cycle 3
    a_left[0] = 8'd0;
    a_left[1] = 8'd4;  // A11
    b_top[0]  = 8'd0;
    b_top[1]  = 8'd8;  // B11

    #10;

    // Flush cycle
    a_left[0] = 8'd0;
    a_left[1] = 8'd0;
    b_top[0]  = 8'd0;
    b_top[1]  = 8'd0;

    #20;

    $display("C00 = %0d", C[0][0]);
    $display("C01 = %0d", C[0][1]);
    $display("C10 = %0d", C[1][0]);
    $display("C11 = %0d", C[1][1]);

    if (C[0][0] == 19 &&
        C[0][1] == 22 &&
        C[1][0] == 43 &&
        C[1][1] == 50)
        $display("TEST PASSED");
    else
        $display("TEST FAILED");

    $finish;
end

endmodule