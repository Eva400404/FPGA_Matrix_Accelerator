`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2026 04:56:55 PM
// Design Name: 
// Module Name: tb_dot_product
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
module tb_dot_product;

parameter WIDTH = 8;
parameter N = 4;

logic clk;
logic rst;
logic start;
logic done;
logic [WIDTH-1:0] a [N];
logic [WIDTH-1:0] b [N];
logic [2*WIDTH+1:0] result;

dot_product #(
    .WIDTH(WIDTH),
    .N(N)
) uut (
    .clk(clk),
    .rst(rst),
    .done(done),
    .start(start),
    .a(a),
    .b(b),
    .result(result)
    );

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    start = 0;
    
    a[0] = 8'd0; b[0] = 8'd0;
    a[1] = 8'd0; b[1] = 8'd0;
    a[2] = 8'd0; b[2] = 8'd0;
    a[3] = 8'd0; b[3] = 8'd0;
    
    #10;
    rst = 0;
    start = 1;
    
    a[0] = 8'd2; b[0] = 8'd3;
    a[1] = 8'd4; b[1] = 8'd5;
    a[2] = 8'd1; b[2] = 8'd7;
    a[3] = 8'd6; b[3] = 8'd2;
    
    #10;
    start = 0;
    
    #10;
    $finish;
end
endmodule
