`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/05/2026 02:50:02 PM
// Design Name: 
// Module Name: bram_simple
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
module bram_simple #(
    parameter WIDTH = 8,
    parameter DEPTH = 4,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  logic clk,

    input  logic we,
    input  logic [ADDR_WIDTH-1:0] addr,
    input  logic [WIDTH-1:0] din,
    output logic [WIDTH-1:0] dout
);

    (* ram_style = "block" *)
    logic [WIDTH-1:0] mem [0:DEPTH-1];

    always_ff @(posedge clk) begin
        if (we) begin
            mem[addr] <= din;
        end

        dout <= mem[addr];
    end

endmodule
