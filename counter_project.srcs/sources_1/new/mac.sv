`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2026 11:24:20 PM
// Design Name: 
// Module Name: mac
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


module mac #(
     parameter WIDTH = 8
)(
     input logic clk,
     input logic rst,
     input logic en,
     input logic [WIDTH-1:0] a,
     input logic [WIDTH-1:0] b,
     output logic [2*WIDTH-1:0] acc
);

always_ff @(posedge clk) begin
    if (rst)
         acc <= 16'd0;
    else if (en)
        acc <= acc + (a * b); 
end

endmodule