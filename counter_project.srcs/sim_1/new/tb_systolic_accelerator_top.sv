`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/21/2026 09:55:13 PM
// Design Name: 
// Module Name: tb_systolic_accelerator_top
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
module tb_systolic_accelerator_top;

parameter WIDTH = 8;
parameter N = 4;

logic clk;
logic rst;
logic start;
logic done;
logic test_pass;

logic [WIDTH-1:0] A_mat [N][N];
logic [WIDTH-1:0] B_mat [N][N];
logic [2*WIDTH+$clog2(N)-1:0] C [N][N];

systolic_accelerator_top #(
    .WIDTH(WIDTH),
    .N(N)
) uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .A_mat(A_mat),
    .B_mat(B_mat),
    .C(C),
    .done(done)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    start = 0;
    test_pass = 1'b1;

    for (int i = 0; i < N; i++) begin
        for (int j = 0; j < N; j++) begin
            A_mat[i][j] = '0;
            B_mat[i][j] = '0;
        end
    end

    #12;
    rst = 0;

    A_mat[0] = '{8'd1,  8'd2,  8'd3,  8'd4};
    A_mat[1] = '{8'd5,  8'd6,  8'd7,  8'd8};
    A_mat[2] = '{8'd9,  8'd10, 8'd11, 8'd12};
    A_mat[3] = '{8'd13, 8'd14, 8'd15, 8'd16};

    B_mat[0] = '{8'd1, 8'd0, 8'd0, 8'd0};
    B_mat[1] = '{8'd0, 8'd1, 8'd0, 8'd0};
    B_mat[2] = '{8'd0, 8'd0, 8'd1, 8'd0};
    B_mat[3] = '{8'd0, 8'd0, 8'd0, 8'd1};

    #10;
    start = 1;
    #10;
    start = 0;

    wait(done == 1);
    #1;
    
    $display("Latency = %0d cycles", uut.run_count);

    $display("C matrix:");
    for (int i = 0; i < N; i++) begin
        for (int j = 0; j < N; j++) begin
            $write("%0d ", C[i][j]);
        end
        $write("\n");
    end

    for (int i = 0; i < N; i++) begin
        for (int j = 0; j < N; j++) begin
            if (C[i][j] !== A_mat[i][j]) begin
                test_pass = 1'b0;
                $display("Mismatch C[%0d][%0d]: got %0d expected %0d",
                         i, j, C[i][j], A_mat[i][j]);
            end
        end
    end

    if (test_pass)
        $display("TEST PASSED");
    else
        $display("TEST FAILED");

    $finish;
end

endmodule
