`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/21/2026 08:45:15 PM
// Design Name: 
// Module Name: systolic_controller
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

module systolic_controller #(
    parameter N = 4
)(
    input  logic clk,
    input  logic rst,
    input  logic start,

    output logic clear,
    output logic en,
    output logic done,

    output logic [$clog2(3*N)-1:0] run_count
);

localparam TOTAL_CYCLES = 3*N - 2;
localparam COUNT_WIDTH  = $clog2(3*N);

typedef enum logic [1:0] {
    IDLE,
    CLEAR,
    RUN,
    DONE
} state_t;

state_t state, next_state;

logic [COUNT_WIDTH-1:0] count;

assign run_count = count;

always_ff @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
        count <= '0;
    end
    else begin
        state <= next_state;

        if (state == RUN)
            count <= count + 1;
        //else if (state == CLEAR)
        else
            count <= '0;
    end
end

always_comb begin
    next_state = state;

    case (state)
        IDLE: begin
            if (start)
                next_state = CLEAR;
        end

        CLEAR: begin
            next_state = RUN;
        end

        RUN: begin
            if (count == TOTAL_CYCLES - 1)
                next_state = DONE;
        end

        DONE: begin
            next_state = IDLE;
        end

        default: next_state = IDLE;
    endcase
end

always_comb begin
    clear = 1'b0;
    en    = 1'b0;
    done  = 1'b0;

    case (state)
        CLEAR: clear = 1'b1;
        RUN:   en    = 1'b1;
        DONE:  done  = 1'b1;
    endcase
end

endmodule