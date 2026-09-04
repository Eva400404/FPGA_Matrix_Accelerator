`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/03/2026 08:40:14 PM
// Design Name: 
// Module Name: result_bram
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
module result_bram #(
    parameter int WIDTH      = 18,
    parameter int DEPTH      = 16,
    parameter int ADDR_WIDTH = $clog2(DEPTH)
)(
    input  logic                  clk,
    input  logic                  en,
    input  logic                  we,
    input  logic [ADDR_WIDTH-1:0] addr,
    input  logic [WIDTH-1:0]      din,
    output logic [WIDTH-1:0]      dout
);

    (* ram_style = "block" *)
    logic [WIDTH-1:0] mem [0:DEPTH-1];

    always_ff @(posedge clk) begin
        if (en) begin
            if (we)
                mem[addr] <= din;
            else
                dout <= mem[addr];
        end
    end

endmodule