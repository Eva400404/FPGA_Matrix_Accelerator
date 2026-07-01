`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2026 10:32:17 PM
// Design Name: 
// Module Name: tb_matmul_2x2
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
module tb_matmul_NxN;

parameter WIDTH = 8;
parameter N = 4;

logic clk;
logic rst;
logic start;
logic done;
logic [WIDTH-1:0] A [N][N];
logic [WIDTH-1:0] B [N][N];
logic [2*WIDTH+$clog2(N)-1:0] C [N][N];
logic test_pass;

matmul_NxN #(
    .WIDTH(WIDTH),
    .N(N)
) uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .A(A),
    .B(B),
    .C(C),
    .done(done)
    );
    
always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    start = 0;
    test_pass = 1;
    
    for (int i = 0; i < N; i++) begin
        for (int j = 0; j < N; j++) begin
            A[i][j] = '0;
            B[i][j] = '0;
        end
    end
    
    #10;
    rst = 0;
    start = 1;
    
    A[0] = '{8'd1, 8'd2, 8'd3, 8'd4};
    A[1] = '{8'd5, 8'd6, 8'd7, 8'd8};
    A[2] = '{8'd9, 8'd10, 8'd11, 8'd12};
    A[3] = '{8'd13, 8'd14, 8'd15, 8'd16};

    B[0] = '{8'd1, 8'd0, 8'd0, 8'd0};
    B[1] = '{8'd0, 8'd1, 8'd0, 8'd0};
    B[2] = '{8'd0, 8'd0, 8'd1, 8'd0};
    B[3] = '{8'd0, 8'd0, 8'd0, 8'd1};
    
    #10;
    
    wait(done == 1);

    for (int i = 0; i < N; i++) begin
        for (int j = 0; j < N ; j++) begin
            if (C[i][j] !== A[i][j]) begin
                test_pass = 0;
                $display("Mismatch at [%0d][%0d]", i, j);
            end
        end
    end

    if (test_pass)
        $display("TEST PASSED");
    else
        $display("TEST FAILED");
    
    start = 0;
    
    $finish;
end
endmodule
