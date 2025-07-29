`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2025 03:38:30 AM
// Design Name: 
// Module Name: Pass_Controller
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


module Pass_Controller (
    input clk,
    input reset,
    input start,
    
    output reg start_nocs,
    input      nocs_done,

    output reg busy,
    output reg done
);
    
    typedef enum {IDLE, START_NOCS, PROCESSING, DONE} state_type;
    state_type state_nxt, state_crnt;
    
    always_ff @(negedge clk or posedge reset) begin
        if (reset) begin
            state_crnt <= IDLE;
        end else begin
            state_crnt <= state_nxt;
        end
    end
    
    always_comb begin
        // Default assignments
        start_nocs = 1'b0;
        busy = 1'b0;
        done = 1'b0;
        state_nxt = state_crnt;
        
        case(state_crnt)
            IDLE:
            begin
                if (start) begin
                    state_nxt = START_NOCS;
                end 
            end
            START_NOCS:
            begin
                start_nocs = 1'b1;
                state_nxt = PROCESSING;
            end
            PROCESSING:
            begin
                busy = 1'b1;
                if (nocs_done) begin
                    state_nxt = DONE;
                end
            end
            DONE:
            begin
                done = 1'b1;
                state_nxt = IDLE;
            end
            default: state_nxt = IDLE;
        endcase
    end
    
endmodule
