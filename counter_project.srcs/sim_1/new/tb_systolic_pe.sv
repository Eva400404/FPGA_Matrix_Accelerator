`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2026 10:19:41 PM
// Design Name: 
// Module Name: tb_systolic_pe
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


module tb_systolic_pe;

parameter WIDTH = 8;

logic clk;
logic rst;
logic clear;
logic en;
logic [WIDTH-1:0] a_in;
logic [WIDTH-1:0] b_in;

logic [WIDTH-1:0] a_out;
logic [WIDTH-1:0] b_out;
logic [2*WIDTH+1:0] acc_out;

systolic_pe #(
    .WIDTH(WIDTH)
) uut (
    .clk(clk),
    .rst(rst),
    .clear(clear),
    .en(en),
    .a_in(a_in),
    .b_in(b_in),
    .a_out(a_out),
    .b_out(b_out),
    .acc_out(acc_out)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    clear = 0;
    en = 0;
    
    a_in = 0;
    b_in = 0;
    
    #10;
    rst = 0;
    en = 1;
    
    // Cycle 1
    a_in = 8'd1;
    b_in = 8'd5;
    #10;
    
    // Cycle 2
    a_in = 8'd2;
    b_in = 8'd7;
    #10;
    
    
    // Stop feeding data
    a_in = 0;
    b_in = 0;

    #10;

    if (acc_out == 19)
        $display("TEST PASSED");
    else begin
        $display("TEST FAILED");
        $display("acc_out = %0d", acc_out);
    end

    $finish;

end
endmodule
