`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2026 11:55:41 PM
// Design Name: 
// Module Name: pe_array
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


module pe_array #(
    parameter WIDTH = 8,
    parameter NUM_PE = 4
)(
    input logic clk,
    input logic rst,
    input logic en,
    input logic clear,
    
    input logic [WIDTH-1:0] a_in [NUM_PE],
    input logic [WIDTH-1:0] b_in [NUM_PE],
    output logic [2*WIDTH-1:0] acc_out [NUM_PE]
    );
    
genvar i;

generate
    for (i = 0; i < NUM_PE; i++) begin : pe_gen
        pe #(
            .WIDTH(WIDTH)
        ) pe_inst (
            .clk(clk),
            .rst(rst),
            .en(en),
            .clear(clear),
            .a_in(a_in[i]),
            .b_in(b_in[i]),
            .acc_out(acc_out[i])
        );
    end
endgenerate

endmodule
