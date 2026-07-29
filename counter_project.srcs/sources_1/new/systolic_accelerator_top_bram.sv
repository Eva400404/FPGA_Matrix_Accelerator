`timescale 1ns / 1ps

module systolic_accelerator_top_bram #(
    parameter WIDTH = 8,
    parameter N = 4,
    parameter ADDR_WIDTH = $clog2(N),
    parameter COUNT_WIDTH = $clog2(3*N)
)(
    input  logic clk,
    input  logic rst,
    input  logic start,

    // Load interface. Use this before start.
    input  logic load_we,
    input  logic load_sel, // 0 = load A, 1 = load B
    input  logic [ADDR_WIDTH-1:0] load_row,
    input  logic [ADDR_WIDTH-1:0] load_col,
    input  logic [WIDTH-1:0] load_data,

    output logic [2*WIDTH+$clog2(N)-1:0] C [N][N],
    output logic done
);

logic clear;
logic en;
logic read_en;

logic [COUNT_WIDTH-1:0] run_count;
logic [COUNT_WIDTH-1:0] read_count;

logic [WIDTH-1:0] a_left [N];
logic [WIDTH-1:0] b_top  [N];

// One A BRAM per row, one B BRAM per column.
logic                  A_we   [N];
logic                  B_we   [N];
logic [ADDR_WIDTH-1:0] A_addr [N];
logic [ADDR_WIDTH-1:0] B_addr [N];
logic [WIDTH-1:0]      A_din  [N];
logic [WIDTH-1:0]      B_din  [N];
logic [WIDTH-1:0]      A_dout [N];
logic [WIDTH-1:0]      B_dout [N];

systolic_controller #(
    .N(N)
) ctrl (
    .clk(clk),
    .rst(rst),
    .start(start),
    .clear(clear),
    .en(en),
    .read_en(read_en),
    .done(done),
    .run_count(run_count),
    .read_count(read_count)
);

// ------------------------------------------------------------
// Address/control generation for BRAMs
// ------------------------------------------------------------
always_comb begin
    for (int i = 0; i < N; i++) begin
        A_we[i]   = 1'b0;
        A_addr[i] = '0;
        A_din[i]  = load_data;

        B_we[i]   = 1'b0;
        B_addr[i] = '0;
        B_din[i]  = load_data;
        
        // ----------------------------------------------------
        // Loading phase
        // ----------------------------------------------------
        if (load_we && !read_en) begin
            // Load A[row][col]: bank = row, address = col.
            if (!load_sel) begin
                if (load_row == i[ADDR_WIDTH-1:0]) begin
                    A_we[i]   = 1'b1;
                    A_addr[i] = load_col;
                    A_din[i]  = load_data;
                end
            end
            // Load B[row][col]: bank = col, address = row.
            else begin
                if (load_col == i[ADDR_WIDTH-1:0]) begin
                    B_we[i]   = 1'b1;
                    B_addr[i] = load_row;
                    B_din[i]  = load_data;
                end
            end
        end
        
        // ----------------------------------------------------
        // PREFETCH or RUN phase
        // ----------------------------------------------------
        else if (read_en) begin
            // Compute stream address for A row-bank i.
            if ((read_count >= i) && ((read_count - i) < N)) begin
                A_addr[i] = read_count - i;
                B_addr[i] = read_count - i;
            end
        end
    end
end

// ------------------------------------------------------------
// BRAM banks
// ------------------------------------------------------------
genvar bank;
generate
    for (bank = 0; bank < N; bank++) begin : bram_banks
        bram_simple #(
            .WIDTH(WIDTH),
            .DEPTH(N),
            .ADDR_WIDTH(ADDR_WIDTH)
        ) A_bram (
            .clk(clk),
            .we(A_we[bank]),
            .addr(A_addr[bank]),
            .din(A_din[bank]),
            .dout(A_dout[bank])
        );

        bram_simple #(
            .WIDTH(WIDTH),
            .DEPTH(N),
            .ADDR_WIDTH(ADDR_WIDTH)
        ) B_bram (
            .clk(clk),
            .we(B_we[bank]),
            .addr(B_addr[bank]),
            .din(B_din[bank]),
            .dout(B_dout[bank])
        );
    end
endgenerate

// ------------------------------------------------------------
// Feed BRAM outputs into systolic array.
// The zero/stagger pattern still uses the original run_count.
// ------------------------------------------------------------
always_comb begin
    for (int i = 0; i < N; i++) begin
        if (en && (run_count >= i) && ((run_count - i) < N))
            a_left[i] = A_dout[i];
        else
            a_left[i] = '0;
    end

    for (int j = 0; j < N; j++) begin
        if (en && (run_count >= j) && ((run_count - j) < N))
            b_top[j] = B_dout[j];
        else
            b_top[j] = '0;
    end
end

systolic_array_NxN #(
    .WIDTH(WIDTH),
    .N(N)
) array (
    .clk(clk),
    .rst(rst),
    .clear(clear),
    .en(en),
    .a_left(a_left),
    .b_top(b_top),
    .C(C)
);

endmodule