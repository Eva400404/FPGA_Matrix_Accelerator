`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2026 10:42:00 PM
// Design Name: 
// Module Name: tb_controller
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
module tb_controller;

logic clk;
logic rst;
logic external_start;
logic compute_done;
logic compute_start;
logic done;

controller uut(
    .clk(clk),
    .rst(rst),
    .external_start(external_start),
    .compute_done(compute_done),
    .compute_start(compute_start),
    .done(done)
    );
    
always #5 clk = ~clk;
initial begin
    clk = 0;
    rst = 1;
    external_start = 0;
    compute_done = 0;
    
    #10;
    rst = 0;
    
    #10;
    external_start = 1;
    
    #10;
    external_start = 0;
    
    #10;
    compute_done = 1;
    
    #10;
    compute_done = 0;
    
    #20;
    $finish;
end
endmodule
