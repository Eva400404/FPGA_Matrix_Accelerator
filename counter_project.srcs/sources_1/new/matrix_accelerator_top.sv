`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2026 11:04:55 PM
// Design Name: 
// Module Name: matrix_accelerator_top
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


module matrix_accelerator_top #(
    parameter WIDTH = 8,
    parameter N = 4
)(
    input logic clk,
    input logic rst,
    input logic external_start,
    
    input logic [WIDTH-1:0] A [N][N],
    input logic [WIDTH-1:0] B [N][N],
    
    output logic [2*WIDTH+1:0] C [N][N],
    output logic done
    );

logic compute_start;
logic compute_done;
    
controller ctrl (
    .clk(clk),
    .rst(rst),
    .external_start(external_start),
    .compute_start(compute_start),
    .compute_done(compute_done),
    .done(done)
);

matmul_NxN #(
    .WIDTH(WIDTH),
    .N(N)
) matmul (
    .clk(clk),
    .rst(rst),
    .start(compute_start),
    .A(A),
    .B(B),
    .C(C),
    .done(compute_done)
);
endmodule
