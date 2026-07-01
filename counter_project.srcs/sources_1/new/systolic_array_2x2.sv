`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2026 09:43:55 PM
// Design Name: 
// Module Name: systolic_array_2x2
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


module systolic_array_2x2 #(
    parameter WIDTH = 8
)(
    input logic clk,
    input logic en,
    input logic rst,
    input logic clear,
    
    input logic [WIDTH-1:0] a_left [2],
    input logic [WIDTH-1:0] b_top [2],
    output logic [2*WIDTH+1:0] C[2][2]
    );
    
//logic [WIDTH-1:0] a_mid [2];
//logic [WIDTH-1:0] b_mid [2];

logic [WIDTH-1:0] a_00_to_01;
logic [WIDTH-1:0] a_10_to_11;
logic [WIDTH-1:0] b_00_to_10;
logic [WIDTH-1:0] b_01_to_11;

systolic_pe #(.WIDTH(WIDTH)) pe00 (
    .clk(clk), .rst(rst), .clear(clear), .en(en),
    .a_in(a_left[0]),
    .b_in(b_top[0]),
    .a_out(a_00_to_01),
    .b_out(b_00_to_10),
    .acc_out(C[0][0])
);

systolic_pe #(.WIDTH(WIDTH)) pe01 (
    .clk(clk), .rst(rst), .clear(clear), .en(en),
    .a_in(a_00_to_01),
    .b_in(b_top[1]),
    .a_out(),
    .b_out(b_01_to_11),
    .acc_out(C[0][1])
);

systolic_pe #(.WIDTH(WIDTH)) pe10 (
    .clk(clk), .rst(rst), .clear(clear), .en(en),
    .a_in(a_left[1]),
    .b_in(b_00_to_10),
    .a_out(a_10_to_11),
    .b_out(),
    .acc_out(C[1][0])
);

systolic_pe #(.WIDTH(WIDTH)) pe11 (
    .clk(clk), .rst(rst), .clear(clear), .en(en),
    .a_in(a_10_to_11),
    .b_in(b_01_to_11),
    .a_out(),
    .b_out(),
    .acc_out(C[1][1])
);

endmodule
