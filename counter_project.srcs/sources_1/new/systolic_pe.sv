`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2026 10:15:09 PM
// Design Name: 
// Module Name: systolic_pe
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
module systolic_pe #(
    parameter WIDTH = 8
)(
    input  logic clk,
    input  logic rst,
    input  logic clear,
    input  logic en,

    input  logic [WIDTH-1:0] a_in,
    input  logic [WIDTH-1:0] b_in,

    output logic [WIDTH-1:0] a_out,
    output logic [WIDTH-1:0] b_out,
    output logic [2*WIDTH+1:0] acc_out
);

always_ff @(posedge clk) begin
    if (rst) begin
        a_out   <= '0;
        b_out   <= '0;
        acc_out <= '0;
    end
    else if (clear) begin
        a_out   <= '0;
        b_out   <= '0;
        acc_out <= '0;
    end
    else if (en) begin
        a_out   <= a_in;              // pass A to the right
        b_out   <= b_in;              // pass B downward
        acc_out <= acc_out + a_in * b_in;
    end
end

endmodule