`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/21/2026 11:34:10 AM
// Design Name: 
// Module Name: tb_systolic_array_NxN
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


module tb_systolic_array_NxN;

parameter WIDTH = 8;
parameter N = 4;

logic clk;
logic rst;
logic clear;
logic en;
logic test_pass;

logic [WIDTH-1:0] a_left [N];
logic [WIDTH-1:0] b_top [N];
logic [2*WIDTH+$clog2(N)-1:0] C [N][N];
logic [WIDTH-1:0] A_mat [N][N];
logic [WIDTH-1:0] B_mat [N][N];

integer cycle_count;
logic counting;

always @(posedge clk) begin
    if (counting)
        cycle_count <= cycle_count + 1;
end

systolic_array_NxN #(
    .WIDTH(WIDTH),
    .N(N)
) utt(
    .clk(clk),
    .rst(rst),
    .clear(clear),
    .en(en),
    .a_left(a_left),
    .b_top(b_top),
    .C(C)
);

always #5 clk = ~clk;

initial begin

    A_mat[0] = '{8'd1,  8'd2,  8'd3,  8'd4};
    A_mat[1] = '{8'd5,  8'd6,  8'd7,  8'd8};
    A_mat[2] = '{8'd9,  8'd10, 8'd11, 8'd12};
    A_mat[3] = '{8'd13, 8'd14, 8'd15, 8'd16};

    B_mat[0] = '{8'd1, 8'd0, 8'd0, 8'd0};
    B_mat[1] = '{8'd0, 8'd1, 8'd0, 8'd0};
    B_mat[2] = '{8'd0, 8'd0, 8'd1, 8'd0};
    B_mat[3] = '{8'd0, 8'd0, 8'd0, 8'd1};

end

initial begin
    clk = 0;
    rst = 1;
    clear = 0;
    en = 0;
    test_pass = 1'b1;
    
    cycle_count = 0;
    counting = 0;

    for (int i = 0; i < N; i++) begin
        a_left[i] = '0;
        b_top[i]  = '0;
    end

    #10;
    rst = 0;

    clear = 1;
    #10;
    clear = 0;

    en = 1;
    
    cycle_count = 0;
    counting = 1;
    
    
    for (int t = 0; t < 2*N-1; t++) begin

        for (int i = 0; i < N; i++) begin
            if ((t-i) >= 0 && (t-i) < N)
                a_left[i] = A_mat[i][t-i];
            else
                a_left[i] = '0;
        end

        for (int j = 0; j < N; j++) begin
            if ((t-j) >= 0 && (t-j) < N)
                b_top[j] = B_mat[t-j][j];
            else
                b_top[j] = '0;
        end

        #10;
    end
    
    // Important: stop feeding useful data
    for (int i = 0; i < N; i++) begin
        a_left[i] = '0;
        b_top[i]  = '0;
    end

    // Let remaining data move through the array
    repeat (N) @(posedge clk);
    
    counting = 0;
    $display("Systolic latency = %0d cycles", cycle_count);
    
    $display("C matrix:");
    for (int i = 0; i < N; i++) begin
        for (int j = 0; j < N; j++) begin
            $write("%0d ", C[i][j]);
        end
        $write("\n");
    end

    for (int i = 0; i < N; i++) begin
        for (int j = 0; j < N; j++) begin
            if (C[i][j] !== (i*N + j + 1)) begin
                test_pass = 1'b0;
                $display("Mismatch C[%0d][%0d]: got %0d expected %0d",
                         i, j, C[i][j], i*N + j + 1);
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
