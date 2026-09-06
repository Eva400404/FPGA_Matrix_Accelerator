`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2026 05:04:46 PM
// Design Name: 
// Module Name: basys3_accelerator_top
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


module basys3_accelerator_top#(
    parameter WIDTH = 8,
    parameter N = 4
)(
    input logic clk,
    input logic btnC,   //Center button: start
    input logic btnU,   //Up button: reset
    
    output logic led_done,
    output logic led_pass
);
    
// --------------------------------------------------------
// Derived widths
// --------------------------------------------------------
localparam ADDR_WIDTH = $clog2(N);
localparam C_WIDTH = 2*WIDTH + $clog2(N);
localparam RESULT_ADDR_WIDTH = $clog2(N*N);

// --------------------------------------------------------
// Signals connecting wrapper to accelerator
// --------------------------------------------------------
logic rst;
logic start;
logic done;

logic load_we;
logic load_sel;

logic [ADDR_WIDTH-1:0] load_row;
logic [ADDR_WIDTH-1:0] load_col;
logic [WIDTH-1:0] load_data;

logic result_re;
logic [RESULT_ADDR_WIDTH-1:0] result_addr;
logic [C_WIDTH-1:0] result_data;

// --------------------------------------------------------
// Accelerator instance
// --------------------------------------------------------

systolic_accelerator_top_bram #(
    .WIDTH(WIDTH),
    .N(N)
) accelerator (
    .clk(clk),
    .rst(rst),
    .start(start),
    
    .load_we(load_we),
    .load_sel(load_sel),
    .load_row(load_row),
    .load_col(load_col),
    .load_data(load_data),
    
    .result_re(result_re),
    .result_addr(result_addr),
    .result_data(result_data),
    
    .done(done)
);

// --------------------------------------------------------
// Board-controller FSM states
// --------------------------------------------------------
typedef enum logic [3:0] {
    IDLE,
    LOAD_A,
    LOAD_B,
    START_ACCEL,
    WAIT_DONE,
    READ_RESULT,
    WAIT_RESULT,
    CHECK_RESULT,
    FINISHED
} state_t;

state_t state;

logic [3:0] load_count;

logic [ADDR_WIDTH-1:0] current_row;
logic [ADDR_WIDTH-1:0] current_col;

logic [3:0] result_count;
logic pass_flag;


assign rst = btnU;

assign current_row = load_count / N;
assign current_col = load_count % N;

always_comb begin

    //Default values
    load_we = 0;
    load_sel = 0;
    
    load_row = current_row;
    load_col = current_col;
    load_data = load_count + 1;
    
    case (state)
    
        LOAD_A: begin
            load_we = 1;
            load_sel = 0;
        end
        
        LOAD_B: begin
            load_we = 1;
            load_sel = 1;
        end
        
        default: begin
            load_we = 0;
        end
    endcase
end

always_ff @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
        load_count <= 0;
        start <= 0;
        
        result_re <= 0;
        result_addr <= 0;
        
        led_done <= 0;
        led_pass <= 0;
        
        result_count <= 0;
        pass_flag    <= 1;
    end
    
    else begin
        
        case (state)
            IDLE: begin
                load_count   <= 0;
                result_count <= 0;
                pass_flag    <= 1;

                start        <= 0;
                result_re    <= 0;

                led_done     <= 0;
                led_pass     <= 0;
                
                if (btnC)
                    state <= LOAD_A;
            end
            
            LOAD_A: begin
                if (load_count == N*N-1) begin
                    load_count <= 0;
                    state <= LOAD_B;
                end
                else begin
                    load_count <= load_count + 1;
                end
            end
            
            LOAD_B: begin
                if (load_count == N*N-1) begin
                    load_count <= 0;
                    state <= START_ACCEL;
                end
                else begin
                    load_count <= load_count + 1;
                end
            end
            
            START_ACCEL: begin
                start <= 1;
                state <= WAIT_DONE;
            end
            
            WAIT_DONE: begin
                start <= 0;
                
                if (done)
                    state <= READ_RESULT;
            end
            
            READ_RESULT: begin
                result_re   <= 1;
                result_addr <= result_count;

                state <= WAIT_RESULT;
            end
            
            WAIT_RESULT: begin
                result_re <= 0;
                
                state <= CHECK_RESULT;
            end
            
            CHECK_RESULT: begin
                result_re <= 0;
                
                if (result_data != expected_result(result_count))
                    pass_flag <= 0;
                    
                if (result_count == N*N-1) begin
                    state <= FINISHED;
                end
                else begin
                    result_count <= result_count + 1;
                    state <= READ_RESULT;
                end
            end
            
            FINISHED: begin
                led_done <= 1;
                led_pass <= pass_flag;
            end
            
            default: begin
                state <= IDLE; 
            end
        endcase
    end
end

function automatic logic [C_WIDTH-1:0] expected_result(
    input logic [3:0] addr
);
    case (addr)
        4'd0: expected_result = 90;
        4'd1: expected_result = 100;
        4'd2: expected_result = 110;
        4'd3: expected_result = 120;
        
        4'd4: expected_result = 202;
        4'd5: expected_result = 228;
        4'd6: expected_result = 254;
        4'd7: expected_result = 280;
        
        4'd8: expected_result = 314;
        4'd9: expected_result = 356;
        4'd10: expected_result = 398;
        4'd11: expected_result = 440;
        
        4'd12: expected_result = 426;
        4'd13: expected_result = 484;
        4'd14: expected_result = 542;
        4'd15: expected_result = 600;
        
        default: expected_result = 0;
    endcase
endfunction
endmodule
