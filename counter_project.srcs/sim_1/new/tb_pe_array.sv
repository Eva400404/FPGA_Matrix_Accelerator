`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2026 12:10:33 AM
// Design Name: 
// Module Name: tb_pe_array
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
module tb_pe_array;
parameter WIDTH = 8;
parameter NUM_PE = 4;

logic clk;
logic rst;
logic en;
logic clear;
logic [WIDTH-1:0] a_in [NUM_PE];
logic [WIDTH-1:0] b_in [NUM_PE];
logic [2*WIDTH-1:0] acc_out [NUM_PE];

pe_array #(
    .WIDTH(WIDTH),
    .NUM_PE(NUM_PE)
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
    
    #10
    rst = 0;
    en = 1;
    
    // PE0
    a_in[0] = 8'd2; b_in[0] = 8'd3;
    
    // PE1
    a_in[1] = 8'd4; b_in[1] = 8'd5;
    
    // PE2
    a_in[2] = 8'd1; b_in[2] = 8'd7;
    
    // PE3
    a_in[3] = 8'd6; b_in[3] = 8'd2;
    
    #10;
    clear = 1;
    
    #10
    clear = 0;
    
    $finish;
end
endmodule

