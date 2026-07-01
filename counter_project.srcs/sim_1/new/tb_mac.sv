`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2026 11:29:39 PM
// Design Name: 
// Module Name: tb_mac
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
module tb_mac;

parameter WIDTH = 8;

logic clk;
logic rst;
logic en;
logic [WIDTH-1:0] a;
logic [WIDTH-1:0] b;
logic [2*WIDTH-1:0] acc;

mac #(
    .WIDTH(WIDTH)
) utt (
    .clk(clk),
    .rst(rst),
    .en(en),
    .a(a),
    .b(b),
    .acc(acc)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    en = 0;
    
    #10
    rst = 0;
    en = 1;
    
    a = 8'd2;
    b = 8'd3;
    #10;
    
    a = 8'd4;
    b = 8'd5;
    #10;
    
    a = 8'd1;
    b = 8'd7;
    #10;
    
    en = 0;
    #20;
    
    $finish;
end

endmodule
