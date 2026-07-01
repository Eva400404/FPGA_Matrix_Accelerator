`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2026 10:56:54 PM
// Design Name: 
// Module Name: pe
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


module pe #(
    parameter WIDTH = 8
)(
    input logic clk,
    input logic rst,
    input logic en,
    input logic clear,
    input logic [WIDTH-1:0] a_in,
    input logic [WIDTH-1:0] b_in,
    output logic [2*WIDTH-1:0] acc_out
    );
    
always_ff @(posedge clk) begin
    if (rst)
        acc_out <= '0;
    else if (clear)
        acc_out <= '0;
    else if (en)
        acc_out <= acc_out + (a_in * b_in);
end
endmodule
