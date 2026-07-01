`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/21/2026 09:35:11 PM
// Design Name: 
// Module Name: systolic_accelerator_top
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
module systolic_accelerator_top #(
    parameter WIDTH = 8,
    parameter N = 4
)(
    input  logic clk,
    input  logic rst,
    input  logic start,

    input  logic [WIDTH-1:0] A_mat [N][N],
    input  logic [WIDTH-1:0] B_mat [N][N],

    output logic [2*WIDTH+$clog2(N)-1:0] C [N][N],
    output logic done
);

logic clear;
logic en;
logic [$clog2(3*N)-1:0] run_count;

logic [WIDTH-1:0] a_left [N];
logic [WIDTH-1:0] b_top  [N];

systolic_controller #(
    .N(N)
) ctrl (
    .clk(clk),
    .rst(rst),
    .start(start),
    .clear(clear),
    .en(en),
    .done(done),
    .run_count(run_count)
);

always_comb begin
    for (int i = 0; i < N; i++) begin
        if ((run_count >= i) && ((run_count - i) < N))
            a_left[i] = A_mat[i][run_count - i];
        else
            a_left[i] = '0;
    end

    for (int j = 0; j < N; j++) begin
        if ((run_count >= j) && ((run_count - j) < N))
            b_top[j] = B_mat[run_count - j][j];
        else
            b_top[j] = '0;
    end
end

systolic_array_NxN #(
    .WIDTH(WIDTH),
    .N(N)
) array (
    .clk(clk),
    .rst(rst),
    .clear(clear),
    .en(en),
    .a_left(a_left),
    .b_top(b_top),
    .C(C)
);

endmodule
