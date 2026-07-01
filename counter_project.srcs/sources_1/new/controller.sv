`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2026 04:21:17 PM
// Design Name: 
// Module Name: controller
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


module controller(
    input logic clk,
    input logic rst,
    
    input logic external_start,
    input logic compute_done,
    
    output logic compute_start,
    output logic done 
    );
    
typedef enum logic [1:0] {
    IDLE,
    COMPUTE,
    DONE
} state_t;

state_t state, next_state;

always_ff @(posedge clk) begin
    if (rst)
        state <= IDLE;
    else
        state <= next_state;
end

always_comb begin
    next_state = state;
    
    case(state)
        IDLE: begin
            if (external_start)
                next_state = COMPUTE;
        end
        
        COMPUTE: begin
            if (compute_done)
                next_state = DONE;
        end
        
        DONE: begin
            next_state = IDLE;
        end
        
        default: begin
            next_state = IDLE;
        end    
        endcase
end

always_comb begin
    compute_start = 1'b0;
    done = 1'b0;
    
    case(state)
        COMPUTE: begin
            compute_start = 1'b1;
        end
        
        DONE: begin
            done = 1'b1;
        end
        
        default: begin
            compute_start = 1'b0;
            done = 1'b0;
        end
     endcase
end
endmodule
