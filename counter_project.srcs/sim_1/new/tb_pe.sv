`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2026 11:04:52 PM
// Design Name: 
// Module Name: tb_pe
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
module tb_pe;

parameter WIDTH = 8;

logic clk;
logic rst;
logic en;
logic clear;
logic [WIDTH-1:0] a_in;
logic [WIDTH-1:0] b_in;
logic [2*WIDTH-1:0] acc_out;

pe #(
    .WIDTH(WIDTH)
) uut (
    .clk(clk),
    .rst(rst),
    .en(en),
    .clear(clear),
    .a_in(a_in),
    .b_in(b_in),
    .acc_out(acc_out)
    );
    
always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    en = 0;
    clear = 0;
    a_in = 0;
    b_in = 0;
    
    #10;
    rst = 0;
    en = 1;
    
    a_in = 8'd2; b_in = 8'd3; #10;
    a_in = 8'd4; b_in = 8'd5; #10;
    a_in = 8'd1; b_in = 8'd7; #10;
    
    en = 0;
    #20;
    
    clear = 1;
    #10
    
    clear = 0;
    en = 1;
    a_in = 8'd3; b_in = 8'd3; #10;
    
    $finish;
end

endmodule
