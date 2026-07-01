`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2026 11:12:53 PM
// Design Name: 
// Module Name: tb_matrix_accelerator_top
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
module tb_matrix_accelerator_top;

parameter WIDTH = 8;
parameter N = 4;

logic clk;
logic rst;
logic external_start;
logic done;
logic test_pass;

logic [WIDTH-1:0] A [N][N];
logic [WIDTH-1:0] B [N][N];
logic [2*WIDTH+1:0] C [N][N];

integer cycle_count;
logic counting;

always @(posedge clk) begin
    if (counting)
    cycle_count <= cycle_count + 1;
end

matrix_accelerator_top #(
    .WIDTH(WIDTH),
    .N(N)
) uut (
    .clk(clk),
    .rst(rst),
    .external_start(external_start),
    .A(A),
    .B(B),
    .C(C),
    .done(done)
    );
    
always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    external_start = 0;
    test_pass = 1'b1;
    cycle_count = 0;
    counting = 0;

    for (int i = 0; i < N; i++) begin
        for (int j = 0; j < N; j++) begin
            A[i][j] = '0;
            B[i][j] = '0;
        end
    end

    #10;
    rst = 0;

    A[0] = '{8'd1,  8'd2,  8'd3,  8'd4};
    A[1] = '{8'd5,  8'd6,  8'd7,  8'd8};
    A[2] = '{8'd9,  8'd10, 8'd11, 8'd12};
    A[3] = '{8'd13, 8'd14, 8'd15, 8'd16};

    B[0] = '{8'd1, 8'd0, 8'd0, 8'd0};
    B[1] = '{8'd0, 8'd1, 8'd0, 8'd0};
    B[2] = '{8'd0, 8'd0, 8'd1, 8'd0};
    B[3] = '{8'd0, 8'd0, 8'd0, 8'd1};

    #10;
    cycle_count = 0;
    counting = 1;
    external_start = 1;

    wait(done == 1);
    counting = 0;
    $display("Latency = %0d cycles", cycle_count);
    
    #1;

    for (int i = 0; i < N; i++) begin
        for (int j = 0; j < N; j++) begin
            if (C[i][j] !== A[i][j]) begin
                test_pass = 1'b0;
                $display("Mismatch at C[%0d][%0d]: got %0d expected %0d",
                         i, j, C[i][j], A[i][j]);
            end
        end
    end

    if (test_pass)
        $display("TEST PASSED");
    else
        $display("TEST FAILED");

    external_start = 0;

    #20;
    $finish;
end

endmodule  

