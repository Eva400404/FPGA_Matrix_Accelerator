`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2026 09:51:18 PM
// Design Name: 
// Module Name: tb_alu
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

module tb_alu;

logic [7:0] a;
logic [7:0] b;
logic [1:0] op;
logic [7:0] y;

alu uut (
    .a(a),
    .b(b),
    .op(op),
    .y(y)
);

initial begin
    a = 8'd10;
    b = 8'd3;
    
    op = 2'b00; #10 //add
    op = 2'b01; #10 //subtract
    op = 2'b10; #10 //AND
    op = 2'b11; #10 //OR
    
    a = 8'd20;
    b = 8'd5;
    
    op = 2'b00; #10 //add
    op = 2'b01; #10 //subtract
    op = 2'b10; #10 //AND
    op = 2'b11; #10 //OR
    
    $finish;
end

endmodule
