`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2026 10:55:23 PM
// Design Name: 
// Module Name: counter
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


module counter(
    input logic clk,
    input logic rst,
    input logic en,
    output logic [7:0] count
);
    
always_ff @(posedge clk) begin
    if (rst)
        count <= 8'd0;
    else if (en)
        count <= count + 1;
end    
endmodule
