`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2026 04:24:46 PM
// Design Name: 
// Module Name: dot_product
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


module dot_product #(
     parameter WIDTH = 8,
     parameter N = 4
)(
    input logic clk,
    input logic rst,
    input logic start,
    input logic [WIDTH-1:0] a [N],
    input logic [WIDTH-1:0] b [N],
    output logic [2*WIDTH+1:0] result,
    output logic done
    );

logic [2*WIDTH-1:0] product [N];
logic [2*WIDTH+1:0] sum_comb;

always_comb begin
    for (int i = 0; i < N; i++) begin
        product [i] = a[i] * b[i];
    end
    
    sum_comb = '0;
    for (int i = 0; i < N; i++) begin
        sum_comb = sum_comb + product[i];
    end
end    

always_ff @(posedge clk) begin
    if (rst) begin
        result <= '0;
        done <= 1'b0;
    end
    
    else begin
        done <= 1'b0;
        
        if (start) begin
            result <= sum_comb;
            done <= 1'b1;
        end
    end
end
endmodule
