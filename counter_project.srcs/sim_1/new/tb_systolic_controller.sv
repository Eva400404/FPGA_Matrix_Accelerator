`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/21/2026 09:29:14 PM
// Design Name: 
// Module Name: tb_systolic_controller
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

module tb_systolic_controller;

parameter N = 4;

logic clk;
logic rst;
logic start;
logic clear;
logic en;
logic done;
logic [$clog2(3*N)-1:0] run_count;

systolic_controller #(
    .N(N)
) uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .clear(clear),
    .en(en),
    .done(done),
    .run_count(run_count)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    start = 0;

    #12;
    rst = 0;

    #10;
    start = 1;

    #10;
    start = 0;

    wait(done == 1);
    #1;

    $display("Controller done at time %0t", $time);
    $display("Final run_count = %0d", run_count);

    #20;
    $finish;
end

endmodule
