`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2026 09:56:20 PM
// Design Name: 
// Module Name: matmul_2x2
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


module matmul_NxN #(
    parameter WIDTH = 8,
    parameter N = 4
)(
    input logic clk,
    input logic rst,
    input logic start,
    
    input logic [WIDTH-1:0] A [N][N],
    input logic [WIDTH-1:0] B [N][N],
    output logic [2*WIDTH+1:0] C [N][N],
    output logic done
    );
    
logic done_dp [N][N];
logic [WIDTH-1:0] row [N][N];
logic [WIDTH-1:0] col [N][N];

always_comb begin 
    for (int i = 0; i < N; i++) begin
        for (int k = 0; k < N; k++) begin
            row[i][k] = A[i][k];
            col[i][k] = B[k][i];
        end
    end
end

genvar i, j;

generate
    for (i = 0; i < N; i++) begin : row_gen
        for (j = 0; j < N; j++) begin : col_gen
            dot_product #(
                .WIDTH(WIDTH),
                .N(N)
            ) dp_inst (
                .clk(clk),
                .rst(rst),
                .start(start),
                .a(row[i]),
                .b(col[j]),
                .result(C[i][j]),
                .done(done_dp[i][j])
            );
        end
    end
endgenerate

always_comb begin
    done = 1'b1;
    for (int i = 0; i < N; i++) begin
        for (int j = 0; j < N; j++) begin
            done = done & done_dp[i][j];
        end
    end
end

endmodule
