`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/18/2026 12:05:35 AM
// Design Name: 
// Module Name: tb_systolic_accelerator_top_bram
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

module tb_systolic_accelerator_top_bram;

parameter WIDTH      = 8;
parameter N          = 4;
parameter ADDR_WIDTH = $clog2(N);
parameter C_WIDTH    = 2*WIDTH + $clog2(N);

logic clk;
logic rst;
logic start;
logic done;
logic test_pass;

logic load_we;
logic load_sel;
logic [ADDR_WIDTH-1:0] load_row;
logic [ADDR_WIDTH-1:0] load_col;
logic [WIDTH-1:0] load_data;

logic [WIDTH-1:0] A_mat [N][N];
logic [WIDTH-1:0] B_mat [N][N];
logic [C_WIDTH-1:0] expected_C [N][N];
logic [C_WIDTH-1:0] C [N][N];

systolic_accelerator_top_bram #(
    .WIDTH(WIDTH),
    .N(N)
) uut (
    .clk(clk),
    .rst(rst),
    .start(start),

    .load_we(load_we),
    .load_sel(load_sel),
    .load_row(load_row),
    .load_col(load_col),
    .load_data(load_data),

    .C(C),
    .done(done)
);

always #5 clk = ~clk;

// ------------------------------------------------------------
// Load one matrix element into BRAM.
// sel = 0: load A
// sel = 1: load B
// ------------------------------------------------------------
task automatic load_element(
    input logic sel,
    input int row,
    input int col,
    input logic [WIDTH-1:0] data
);
begin
    // Apply signals before the rising edge.
    @(negedge clk);

    load_we   = 1'b1;
    load_sel  = sel;
    load_row  = row[ADDR_WIDTH-1:0];
    load_col  = col[ADDR_WIDTH-1:0];
    load_data = data;

    // BRAM writes at this rising edge.
    @(posedge clk);

    // Stop writing before the next rising edge.
    @(negedge clk);
    load_we = 1'b0;
end
endtask

initial begin
    clk       = 1'b0;
    rst       = 1'b1;
    start     = 1'b0;
    load_we   = 1'b0;
    load_sel  = 1'b0;
    load_row  = '0;
    load_col  = '0;
    load_data = '0;
    test_pass = 1'b1;

    // --------------------------------------------------------
    // Initialize software-side matrices
    // --------------------------------------------------------
    A_mat[0] = '{8'd1,  8'd2,  8'd3,  8'd4};
    A_mat[1] = '{8'd5,  8'd6,  8'd7,  8'd8};
    A_mat[2] = '{8'd9,  8'd10, 8'd11, 8'd12};
    A_mat[3] = '{8'd13, 8'd14, 8'd15, 8'd16};

    B_mat[0] = '{8'd1, 8'd2, 8'd3, 8'd4};
    B_mat[1] = '{8'd5, 8'd6, 8'd7, 8'd8};
    B_mat[2] = '{8'd9, 8'd10, 8'd11, 8'd12};
    B_mat[3] = '{8'd13, 8'd14, 8'd15, 8'd16};

    // Expected C values
    for (int i = 0; i < N; i++) begin
        for (int j = 0; j < N; j++) begin
            expected_C[i][j] = '0;

            for (int k = 0; k < N; k++) begin
                expected_C[i][j] =
                    expected_C[i][j]
                    + A_mat[i][k] * B_mat[k][j];
            end
        end
    end

    // --------------------------------------------------------
    // Reset
    // --------------------------------------------------------
    repeat (2) @(posedge clk);
    @(negedge clk);
    rst = 1'b0;

    // --------------------------------------------------------
    // Load matrix A
    // --------------------------------------------------------
    for (int i = 0; i < N; i++) begin
        for (int j = 0; j < N; j++) begin
            load_element(
                1'b0,
                i,
                j,
                A_mat[i][j]
            );
        end
    end

    // --------------------------------------------------------
    // Load matrix B
    // --------------------------------------------------------
    for (int i = 0; i < N; i++) begin
        for (int j = 0; j < N; j++) begin
            load_element(
                1'b1,
                i,
                j,
                B_mat[i][j]
            );
        end
    end

    // --------------------------------------------------------
    // Start computation
    // --------------------------------------------------------
    @(negedge clk);
    start = 1'b1;

    @(posedge clk);

    @(negedge clk);
    start = 1'b0;

    // Timeout protection prevents simulation from hanging.
    fork
        begin
            wait(done === 1'b1);
        end

        begin
            repeat (100) @(posedge clk);
            $fatal(1, "Timeout: done was never asserted.");
        end
    join_any
    disable fork;

    // Allow combinational outputs to settle.
    #1;

    // --------------------------------------------------------
    // Display result
    // --------------------------------------------------------
    $display("C matrix:");

    for (int i = 0; i < N; i++) begin
        for (int j = 0; j < N; j++) begin
            $write("%0d ", C[i][j]);
        end
        $write("\n");
    end

    // --------------------------------------------------------
    // Check result
    // --------------------------------------------------------
    for (int i = 0; i < N; i++) begin
        for (int j = 0; j < N; j++) begin
            if (C[i][j] !== expected_C[i][j]) begin
                test_pass = 1'b0;

                $display(
                    "Mismatch C[%0d][%0d]: got %0d, expected %0d",
                    i,
                    j,
                    C[i][j],
                    expected_C[i][j]
                );
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