module Scheduler #(
    parameter C_WIDTH = 10,
    parameter M_WIDTH = 10,
    parameter N_WIDTH = 3,
    
    parameter n_WIDTH = 3,
    parameter p_WIDTH = 5,
    parameter q_WIDTH = 3,
    parameter r_WIDTH = 2,
    parameter t_WIDTH = 3
) (
    input  logic clk,
    input  logic reset,    
    input  logic start,  
    
    output logic pass_start,
    input  logic pass_ready,
    input  logic pass_done,
    
    output logic busy,
    output logic done,
    output logic bias_sel,
    
    input  logic [C_WIDTH - 1:0] C,
    input  logic [M_WIDTH - 1:0] M,
    input  logic [N_WIDTH - 1:0] N,

    input  logic [n_WIDTH - 1:0] n,
    input  logic [p_WIDTH - 1:0] p,
    input  logic [q_WIDTH - 1:0] q, 
    input  logic [r_WIDTH - 1:0] r,
    input  logic [t_WIDTH - 1:0] t,

    output logic [M_WIDTH - 1:0] filter_ids         [0:1], 
    output logic [C_WIDTH - 1:0] filter_channel_ids [0:1],
    
    output logic [N_WIDTH - 1:0] ifmap_ids         [0:1], 
    output logic [C_WIDTH - 1:0] ifmap_channel_ids [0:1], 
    
    output logic [N_WIDTH - 1:0] psum_ids         [0:1], 
    output logic [M_WIDTH - 1:0] psum_channel_ids [0:1]  
);

    typedef enum logic [2:0] {IDLE, CHECK, LOOPING, START_NOC, AWAIT, PASS_DONE, DONE} state_type;
    state_type state_nxt, state_crnt;
    
    logic [M_WIDTH - 1:0] M_nxt, M_crnt;
    logic [N_WIDTH - 1:0] N_nxt, N_crnt; 
    logic [C_WIDTH - 1:0] C_nxt, C_crnt; 

    logic [C_WIDTH - 1:0] channel_ids [0:1];
    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state_crnt <= IDLE;
            N_crnt <= 0;
            C_crnt <= 0;
            M_crnt <= 0;
        end else begin
            state_crnt <= state_nxt;
            N_crnt <= N_nxt;
            C_crnt <= C_nxt;
            M_crnt <= M_nxt;
        end
    end
    
    always_comb begin
        pass_start = 'b0;
        busy = 'b0;
        done = 'b0;
        
        M_nxt = M_crnt;
        C_nxt = C_crnt;
        N_nxt = N_crnt;
        state_nxt = state_crnt;
        case(state_crnt)
            IDLE:
            begin
                if (start) begin 
                    state_nxt = CHECK; 
                end
            end
            CHECK:
            begin            
                if (pass_ready) begin
                    state_nxt = START_NOC; 
                end
            end
            LOOPING:
            begin
                state_nxt = CHECK;
                if ((M_crnt + (p * t)) >= M) begin 
                    if ((C_crnt + (q * r)) >= C) begin 
                        if ((N_crnt + n) >= N) begin 
                            state_nxt = DONE; 
                            C_nxt = 0;
                            M_nxt = 0;
                            N_nxt = 0;            
                        end else begin
                            N_nxt = N_crnt + n;
                            C_nxt = 0;
                            M_nxt = 0;
                        end
                    end else begin
                        C_nxt = C_crnt + (q * r);
                        M_nxt = 0;
                    end
                end else begin
                    M_nxt = M_crnt + (p * t); 
                end
            end
            START_NOC:
            begin
                state_nxt = AWAIT;
                pass_start = 'b1;
            end
            AWAIT:
            begin
                if (pass_done) begin 
                    state_nxt = LOOPING; 
                end
                busy = 'b1;
            end
            DONE:
            begin
                state_nxt = IDLE;
                done = 'b1;
            end
        endcase
    end
    
    always_comb begin
        if ((state_crnt == IDLE) || (state_crnt == DONE)) begin
            filter_ids = '{0, 0};
            channel_ids = '{0, 0};
            ifmap_ids = '{0, 0};
            
            bias_sel = 1'b0;
        end else begin
            filter_ids = '{M_crnt, M_crnt + p * t - 1};
            channel_ids = '{C_crnt, C_crnt + q * r - 1};
            ifmap_ids = '{N_crnt, N_crnt + n - 1};
            
            bias_sel = (channel_ids[0] == 0);
        end
    end

    assign filter_channel_ids = channel_ids;
    assign ifmap_channel_ids = channel_ids;
    
    assign psum_ids = ifmap_ids;
    assign psum_channel_ids = filter_ids;
    
endmodule