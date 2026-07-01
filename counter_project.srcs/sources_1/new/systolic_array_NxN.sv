`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/21/2026 10:36:10 AM
// Design Name: 
// Module Name: systolic_array_NxN
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


module systolic_array_NxN #(
    parameter WIDTH = 8,
    parameter N =4
)(
    input logic clk,
    input logic rst,
    input logic en,
    input logic clear,
    
    input logic [WIDTH-1:0] a_left [N],
    input logic [WIDTH-1:0] b_top [N],
    
    output logic [2*WIDTH+$clog2(N)-1:0] C [N][N]
    );
    
logic [WIDTH-1:0] a_wire [N][N+1];
logic [WIDTH-1:0] b_wire [N+1][N];

genvar i, j;

generate
    for (i = 0; i < N; i++) begin : input_a
        assign a_wire[i][0] = a_left[i];
    end
    
    for (j = 0; j < N; j++) begin : input_b
        assign b_wire[0][j] = b_top[j];
    end
    
    for (i = 0; i < N; i++) begin : row_gen
        for (j = 0; j < N; j++) begin : col_gen
            systolic_pe #(
                .WIDTH(WIDTH)
            ) pe_inst (
                .clk(clk),
                .rst(rst),
                .clear(clear),
                .en(en),
                
                .a_in(a_wire[i][j]),
                .b_in(b_wire[i][j]),
                
                .a_out(a_wire[i][j+1]),
                .b_out(b_wire[i+1][j]),
                
                .acc_out(C[i][j])
            );
        end
    end
endgenerate
endmodule
