`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2026 03:51:57 PM
// Design Name: 
// Module Name: tb_counter
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

module tb_counter;

logic clk;
logic rst;
logic en;
logic [7:0] count;

counter uut(
    .clk(clk),
    .rst(rst),
    .en(en),
    .count(count)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    en = 0;
    
    #10;
    rst = 0;
    
    #10;
    en = 1;
    
    #40;
    en = 0;
    
    #30;
    en = 1;
    
    #40
    
    $finish;
end

endmodule
