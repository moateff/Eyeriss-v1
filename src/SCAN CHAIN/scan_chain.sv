`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2025 09:58:24 PM
// Design Name: 
// Module Name: lp_configure_dff_Nbits
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


module scan_chain #(
    parameter H_WIDTH = 8,
    parameter R_WIDTH = 4,
    parameter E_WIDTH = 6,

    parameter C_WIDTH = 10,
    parameter M_WIDTH = 10,
    parameter N_WIDTH = 3,
    parameter U_WIDTH = 3,
    parameter V_WIDTH = 2, 
    
    parameter n_WIDTH = 3,
    parameter e_WIDTH = 8,
    parameter p_WIDTH = 5,
    parameter q_WIDTH = 3,
    parameter r_WIDTH = 2,
    parameter t_WIDTH = 3,

    parameter X_WIDTH = 1 
)(
    input  wire clk,
    input  wire reset,
    input  wire se,
    input  wire si,
    output wire so,

    // Mapping parameters (configurations)
    output  logic  [H_WIDTH - 1:0] H,
    output  logic  [R_WIDTH - 1:0] R,
    output  logic  [E_WIDTH - 1:0] E,

    output  logic  [C_WIDTH - 1:0] C,
    output  logic  [M_WIDTH - 1:0] M,
    output  logic  [N_WIDTH - 1:0] N,
    output  logic  [U_WIDTH - 1:0] U,
    output  logic  [V_WIDTH - 1:0] V,

    output  logic  [n_WIDTH - 1:0] n,
    output  logic  [e_WIDTH - 1:0] e,
    output  logic  [p_WIDTH - 1:0] p,
    output  logic  [q_WIDTH - 1:0] q,
    output  logic  [r_WIDTH - 1:0] r,
    output  logic  [t_WIDTH - 1:0] t,

    output  logic  [X_WIDTH - 1:0] X
    );

    logic [0:13] soi;

    scan_ff_Nbit #(.N(H_WIDTH)) H_reg (
        .clk(clk),
        .reset(reset),
        .se(se),
        .si(si),
        .q(H),
        .so(soi[0])
    );
   
   scan_ff_Nbit #(.N(R_WIDTH)) R_reg (
        .clk(clk),
        .reset(reset),
        .se(se),
        .si(soi[0]),
        .q(R),
        .so(soi[1])
    );
    
    scan_ff_Nbit #(.N(E_WIDTH)) E_reg (
        .clk(clk),
        .reset(reset),
        .se(se),
        .si(soi[1]),
        .q(E),
        .so(soi[2])
    );

    scan_ff_Nbit #(.N(C_WIDTH)) C_reg (
        .clk(clk),
        .reset(reset),
        .se(se),
        .si(soi[2]),
        .q(C),
        .so(soi[3])
    );

    scan_ff_Nbit #(.N(M_WIDTH)) M_reg (
        .clk(clk),
        .reset(reset),
        .se(se),
        .si(soi[3]),
        .q(M),
        .so(soi[4])
    );

    scan_ff_Nbit #(.N(N_WIDTH)) N_reg (
        .clk(clk),
        .reset(reset),
        .se(se),
        .si(soi[4]),
        .q(N),
        .so(soi[5])
    );

    scan_ff_Nbit #(.N(U_WIDTH)) U_reg (
        .clk(clk),
        .reset(reset),
        .se(se),
        .si(soi[5]),
        .q(U),
        .so(soi[6])
    );
    scan_ff_Nbit #(.N(V_WIDTH)) V_reg (
        .clk(clk),
        .reset(reset),
        .se(se),
        .si(soi[6]),
        .q(V),
        .so(soi[7])
    );

    scan_ff_Nbit #(.N(n_WIDTH)) n_reg (
        .clk(clk),
        .reset(reset),
        .se(se),
        .si(soi[7]),
        .q(n),
        .so(soi[8])
    );

    scan_ff_Nbit #(.N(e_WIDTH)) e_reg (
        .clk(clk),
        .reset(reset),
        .se(se),
        .si(soi[8]),
        .q(e),
        .so(soi[9])
    );

    scan_ff_Nbit #(.N(p_WIDTH)) p_reg (
        .clk(clk),
        .reset(reset),
        .se(se),
        .si(soi[9]),
        .q(p),
        .so(soi[10])
    );

    scan_ff_Nbit #(.N(q_WIDTH)) q_reg (
        .clk(clk),
        .reset(reset),
        .se(se),
        .si(soi[10]),
        .q(q),
        .so(soi[11])
    );

    scan_ff_Nbit #(.N(r_WIDTH)) r_reg (
        .clk(clk),
        .reset(reset),
        .se(se),
        .si(soi[11]),
        .q(r),
        .so(soi[12])
    );

    scan_ff_Nbit #(.N(t_WIDTH)) t_reg (
        .clk(clk),
        .reset(reset),
        .se(se),
        .si(soi[12]),
        .q(t),
        .so(soi[13])
    );

    scan_ff_Nbit #(.N(X_WIDTH)) X_reg (
        .clk(clk),
        .reset(reset),
        .se(se),
        .si(soi[13]),
        .q(X),
        .so(so)
    );
    
endmodule
