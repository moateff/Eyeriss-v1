`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2025 01:55:09 AM
// Design Name: 
// Module Name: From_GLB_To_GLB
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


module PE_Array_integerated_with_NoC #(
    parameter DATA_WIDTH_IFMAP     = 16, 
    parameter ROW_TAG_WIDTH_IFMAP  = 4,
    parameter COL_TAG_WIDTH_IFMAP  = 5,
    
    parameter DATA_WIDTH_FILTER    = 64, 
    parameter ROW_TAG_WIDTH_FILTER = 4,
    parameter COL_TAG_WIDTH_FILTER = 4,
    
    parameter DATA_WIDTH_PSUM      = 64, 
    parameter ROW_TAG_WIDTH_PSUM   = 4,
    parameter COL_TAG_WIDTH_PSUM   = 4,
    
    parameter NUM_OF_ROWS = 12,
    parameter NUM_OF_COLS = 14,

    parameter GIN_DATA_FIFO_DEPTH = 16,
    parameter GIN_TAGS_FIFO_DEPTH = 16,

    parameter GON_DATA_FIFO_DEPTH = 16,
    parameter GON_TAGS_FIFO_DEPTH = 16,
    
    parameter DATA_WIDTH = 16,
    
    parameter PE_IFMAP_FIFO_DEPTH  = 4,
    parameter PE_FILTER_FIFO_DEPTH = 8,
    parameter PE_PSUM_FIFO_DEPTH   = 8,
    
    parameter IFMAP_SPAD_DEPTH  = 12,
    parameter FILTER_SPAD_DEPTH = 224,
    parameter PSUM_SPAD_DEPTH   = 24,
    
    parameter H_WIDTH = 8,
    parameter W_WIDTH = 8,
    parameter D_WIDTH = 8,
    parameter R_WIDTH = 4,
    parameter S_WIDTH = 4,
    parameter E_WIDTH = 6,
    parameter F_WIDTH = 6,

    parameter C_WIDTH = 10,
    parameter M_WIDTH = 10,
    parameter N_WIDTH = 3,
    parameter U_WIDTH = 3,

    parameter n_WIDTH = 3,
    parameter e_WIDTH = 8,
    parameter p_WIDTH = 5,
    parameter q_WIDTH = 3,
    parameter r_WIDTH = 2,
    parameter t_WIDTH = 3,
    
    parameter X_WIDTH = 1, 

    parameter ADDR_WIDTH = 20,

    parameter COLLECTOR_FILTER_FIFO_DEPTH = 16,
    parameter COLLECTOR_PSUM_FIFO_DEPTH   = 16
)(
    //---------------------------------------Control Signals--------------------------------------------\\
    input  clk,
    input  link_clk,
    input  reset,
    //input  configure,
    input  start,
    output busy,
    output done,
    
    //----------------------------------------PE Control-------------------------------------------------\\
    //input  pe_enable [0:NUM_OF_ROWS - 1][0:NUM_OF_COLS - 1],
    //output pe_busy   [0:NUM_OF_ROWS - 1][0:NUM_OF_COLS - 1],

    //-------------------------------------Mapping Parameters---------------------------------------------\\
    input [H_WIDTH - 1:0] H,
    input [R_WIDTH - 1:0] R,
    input [E_WIDTH - 1:0] E,

    input [C_WIDTH - 1:0] C,
    input [M_WIDTH - 1:0] M,
    input [N_WIDTH - 1:0] N,
    input [U_WIDTH - 1:0] U,

    input [n_WIDTH - 1:0] n,
    input [e_WIDTH - 1:0] e,
    input [p_WIDTH - 1:0] p,
    input [q_WIDTH - 1:0] q,
    input [r_WIDTH - 1:0] r,
    input [t_WIDTH - 1:0] t,
    
    input [X_WIDTH - 1:0] X, 

    //-------------------------------------------IFMAP-----------------------------------------------------\\
    //input  [ROW_TAG_WIDTH_IFMAP - 1:0] ifmap_id_row [0:NUM_OF_ROWS-1],                
    //input  [COL_TAG_WIDTH_IFMAP - 1:0] ifmap_id_col [0:NUM_OF_ROWS-1][0:NUM_OF_COLS-1],
    output ifmap_re_from_glb,
    input  [N_WIDTH - 1:0] ifmap_base,
    input  [C_WIDTH - 1:0] ifmap_channel_base,
    input  [ADDR_WIDTH - 1:0] ifmap_base_addr,
    output [ADDR_WIDTH - 1:0] ifmap_glb_addr,
    input  [DATA_WIDTH - 1:0] ifmap_from_glb,
    
    //-------------------------------------------FILTER-----------------------------------------------------\\
    //input  [ROW_TAG_WIDTH_FILTER - 1:0] filter_id_row [0:NUM_OF_ROWS-1],                
    //input  [COL_TAG_WIDTH_FILTER - 1:0] filter_id_col [0:NUM_OF_ROWS-1][0:NUM_OF_COLS-1],
    output filter_re_from_glb,
    input  [M_WIDTH - 1:0] filter_base,
    input  [C_WIDTH - 1:0] filter_channel_base,
    input  [ADDR_WIDTH - 1:0] filter_base_addr,
    output [ADDR_WIDTH - 1:0] filter_glb_addr,
    input  [DATA_WIDTH - 1:0] filter_from_glb,
    
    //-------------------------------------------IPSUM-----------------------------------------------------\\
    //input  [ROW_TAG_WIDTH_PSUM - 1:0] ipsum_id_row [0:NUM_OF_ROWS-1],                
    //input  [COL_TAG_WIDTH_PSUM - 1:0] ipsum_id_col [0:NUM_OF_ROWS-1][0:NUM_OF_COLS-1],
    output ipsum_re_from_glb,
    input  [N_WIDTH - 1:0] ipsum_base,
    input  [M_WIDTH - 1:0] ipsum_channel_base,
    input  [ADDR_WIDTH - 1:0] ipsum_base_addr,
    input  [ADDR_WIDTH - 1:0] bias_base_addr,
    output [ADDR_WIDTH - 1:0] ipsum_glb_addr,
    output [ADDR_WIDTH - 1:0] bias_glb_addr,
    input  [DATA_WIDTH - 1:0] ipsum_from_glb,
    
    //-------------------------------------------OPSUM-----------------------------------------------------\\
    //input  [ROW_TAG_WIDTH_PSUM - 1:0] opsum_id_row [0:NUM_OF_ROWS-1],                
    //input  [COL_TAG_WIDTH_PSUM - 1:0] opsum_id_col [0:NUM_OF_ROWS-1][0:NUM_OF_COLS-1],
    output opsum_we_to_glb,
    input  [N_WIDTH - 1:0] opsum_base,
    input  [M_WIDTH - 1:0] opsum_channel_base,
    input  [ADDR_WIDTH - 1:0] opsum_base_addr,
    output [ADDR_WIDTH - 1:0] opsum_glb_addr,
    output [DATA_WIDTH - 1:0] opsum_to_glb,
    
    //---------------------------------------Local Network---------------------------------------------------\\
    //input sel_pe0_gin1 [0:NUM_OF_ROWS-1][0:NUM_OF_COLS-1],
    input  logic se, 
    input  logic si,
    output logic so
);

    //-------------------------------------------IFMAP-----------------------------------------------------\\    
    wire [ROW_TAG_WIDTH_IFMAP - 1:0] ifmap_row_tag;
    wire [COL_TAG_WIDTH_IFMAP - 1:0] ifmap_col_tag;
    wire push_ifmap_to_gin;
    wire [DATA_WIDTH_IFMAP - 1:0] ifmap_to_gin;
    wire ifmap_gin_fifo_full;
    wire ifmap_tags_wr_en;
    wire ifmap_tags_full;
    
    //-------------------------------------------FILTER-----------------------------------------------------\\
    wire [ROW_TAG_WIDTH_FILTER - 1:0] filter_row_tag;
    wire [COL_TAG_WIDTH_FILTER - 1:0] filter_col_tag;
    wire push_filter_to_gin;
    wire [DATA_WIDTH_FILTER - 1:0] filter_to_gin;
    wire filter_gin_fifo_full;
    wire filter_tags_wr_en;
    wire filter_tags_full;
    
    //-------------------------------------------IPSUM-----------------------------------------------------\\
    wire [ROW_TAG_WIDTH_PSUM - 1:0] ipsum_row_tag;
    wire [COL_TAG_WIDTH_PSUM - 1:0] ipsum_col_tag;
    wire push_ipsum_to_gin;
    wire [DATA_WIDTH_PSUM - 1:0] ipsum_to_gin;
    wire ipsum_gin_fifo_full;
    wire ipsum_tags_wr_en;
    wire ipsum_tags_full;
    
    //-------------------------------------------OPSUM-----------------------------------------------------\\
    wire [ROW_TAG_WIDTH_PSUM - 1:0] opsum_row_tag;
    wire [COL_TAG_WIDTH_PSUM - 1:0] opsum_col_tag;
    wire pop_opsum_from_gon;
    wire [DATA_WIDTH_PSUM - 1:0] opsum_from_gon;
    wire opsum_gon_fifo_empty;
    wire opsum_tags_wr_en;
    wire opsum_tags_full;
    
    
    PE_Array #(
        .DATA_WIDTH_IFMAP(DATA_WIDTH_IFMAP),
        .ROW_TAG_WIDTH_IFMAP(ROW_TAG_WIDTH_IFMAP),
        .COL_TAG_WIDTH_IFMAP(COL_TAG_WIDTH_IFMAP),

        .DATA_WIDTH_FILTER(DATA_WIDTH_FILTER),
        .ROW_TAG_WIDTH_FILTER(ROW_TAG_WIDTH_FILTER),
        .COL_TAG_WIDTH_FILTER(COL_TAG_WIDTH_FILTER),

        .DATA_WIDTH_PSUM(DATA_WIDTH_PSUM),
        .ROW_TAG_WIDTH_PSUM(ROW_TAG_WIDTH_PSUM),
        .COL_TAG_WIDTH_PSUM(COL_TAG_WIDTH_PSUM),

        .NUM_OF_ROWS(NUM_OF_ROWS),
        .NUM_OF_COLS(NUM_OF_COLS),

        .GIN_DATA_FIFO_DEPTH(GIN_DATA_FIFO_DEPTH),
        .GIN_TAGS_FIFO_DEPTH(GIN_TAGS_FIFO_DEPTH),
        .GON_DATA_FIFO_DEPTH(GON_DATA_FIFO_DEPTH),
        .GON_TAGS_FIFO_DEPTH(GON_TAGS_FIFO_DEPTH),

        .PE_IFMAP_FIFO_DEPTH(PE_IFMAP_FIFO_DEPTH),
        .PE_FILTER_FIFO_DEPTH(PE_FILTER_FIFO_DEPTH),
        .PE_PSUM_FIFO_DEPTH(PE_PSUM_FIFO_DEPTH),

        .U_WIDTH(U_WIDTH),
        .S_WIDTH(S_WIDTH),
        .F_WIDTH(F_WIDTH),
        .n_WIDTH(n_WIDTH),
        .p_WIDTH(p_WIDTH),
        .q_WIDTH(q_WIDTH),
        .X_WIDTH(X_WIDTH),

        .IFMAP_SPAD_DEPTH(IFMAP_SPAD_DEPTH),
        .FILTER_SPAD_DEPTH(FILTER_SPAD_DEPTH),
        .PSUM_SPAD_DEPTH(PSUM_SPAD_DEPTH),

        .DATA_WIDTH(DATA_WIDTH)
    ) pe_array_inst (
        .clk(clk),
        .link_clk(link_clk),
        .reset(reset),
        //.configure(configure),
        //.enable(pe_enable),
        //.busy(pe_busy),

        .U(U),
        .W(H),
        .S(R),
        .F(E),
        .n(n),
        .p(p),
        .q(q),
        .X(X),

        //.ifmap_id_row(ifmap_id_row),
        //.ifmap_id_col(ifmap_id_col),
        .ifmap_row_tag(ifmap_row_tag),
        .ifmap_col_tag(ifmap_col_tag),

        .push_ifmap_to_gin(push_ifmap_to_gin),
        .ifmap_to_gin(ifmap_to_gin),
        .ifmap_gin_fifo_full(ifmap_gin_fifo_full),

        .ifmap_tags_wr_en(ifmap_tags_wr_en),
        .ifmap_tags_full(ifmap_tags_full),

        //.filter_id_row(filter_id_row),
        //.filter_id_col(filter_id_col),
        .filter_row_tag(filter_row_tag),
        .filter_col_tag(filter_col_tag),

        .push_filter_to_gin(push_filter_to_gin),
        .filter_to_gin(filter_to_gin),
        .filter_gin_fifo_full(filter_gin_fifo_full),

        .filter_tags_wr_en(filter_tags_wr_en),
        .filter_tags_full(filter_tags_full),

        //.ipsum_id_row(ipsum_id_row),
        //.ipsum_id_col(ipsum_id_col),
        .ipsum_row_tag(ipsum_row_tag),
        .ipsum_col_tag(ipsum_col_tag),

        .push_ipsum_to_gin(push_ipsum_to_gin),
        .ipsum_to_gin(ipsum_to_gin),
        .ipsum_gin_fifo_full(ipsum_gin_fifo_full),

        .ipsum_tags_wr_en(ipsum_tags_wr_en),
        .ipsum_tags_full(ipsum_tags_full),

        //.opsum_id_row(opsum_id_row),
        //.opsum_id_col(opsum_id_col),
        .opsum_row_tag(opsum_row_tag),
        .opsum_col_tag(opsum_col_tag),

        .pop_opsum_from_gon(pop_opsum_from_gon),
        .opsum_from_gon(opsum_from_gon),
        .opsum_gon_fifo_empty(opsum_gon_fifo_empty),

        .opsum_tags_wr_en(opsum_tags_wr_en),
        .opsum_tags_full(opsum_tags_full),

        //.sel_pe0_gin1(sel_pe0_gin1),
        .se(se),
        .si(si),
        .so(so)
    );
    
    NoCs_TOP #(
        .H_WIDTH(H_WIDTH),
        .W_WIDTH(W_WIDTH),
        .D_WIDTH(D_WIDTH),
        .R_WIDTH(R_WIDTH),
        .S_WIDTH(S_WIDTH),
        .E_WIDTH(E_WIDTH),
        .F_WIDTH(F_WIDTH),
        .C_WIDTH(C_WIDTH),
        .M_WIDTH(M_WIDTH),
        .N_WIDTH(N_WIDTH),
        .U_WIDTH(U_WIDTH),
        .n_WIDTH(n_WIDTH),
        .e_WIDTH(e_WIDTH),
        .p_WIDTH(p_WIDTH),
        .q_WIDTH(q_WIDTH),
        .r_WIDTH(r_WIDTH),
        .t_WIDTH(t_WIDTH),
        .X_WIDTH(X_WIDTH),
        
        .ADDR_WIDTH(ADDR_WIDTH),
        
        .IFMAP_DATA_WIDTH(DATA_WIDTH_IFMAP),
                
        .FILTER_FIFO_IN_WIDTH(DATA_WIDTH),
        .FILTER_FIFO_OUT_WIDTH(DATA_WIDTH_FILTER),
        .FILTER_FIFO_DEPTH(COLLECTOR_FILTER_FIFO_DEPTH),
        
        .PSUM_FIFO_IN_WIDTH(DATA_WIDTH),
        .PSUM_FIFO_OUT_WIDTH(DATA_WIDTH_PSUM),
        .PSUM_FIFO_DEPTH(COLLECTOR_PSUM_FIFO_DEPTH),

        .ROW_TAG_WIDTH_IFMAP(ROW_TAG_WIDTH_IFMAP),
        .COL_TAG_WIDTH_IFMAP(COL_TAG_WIDTH_IFMAP),
        .ROW_TAG_WIDTH_FILTER(ROW_TAG_WIDTH_FILTER),
        .COL_TAG_WIDTH_FILTER(COL_TAG_WIDTH_FILTER),
        .ROW_TAG_WIDTH_PSUM(ROW_TAG_WIDTH_PSUM),
        .COL_TAG_WIDTH_PSUM(COL_TAG_WIDTH_PSUM)
    ) nocs_top_inst (
        .clk(clk),
        .reset(reset),
        //.configure(configure),
        .start(start),
        .busy(busy),
        .done(done),

        .H(H),
        .R(R),
        .E(E),
        .C(C),
        .M(M),
        .N(N),
        .U(U),
        .n(n),
        .e(e),
        .p(p),
        .q(q),
        .r(r),
        .t(t),
        .X(X),
        
        .ifmap_gin_fifo_full(ifmap_gin_fifo_full),
        .filter_gin_fifo_full(filter_gin_fifo_full),
        .ipsum_gin_fifo_full(ipsum_gin_fifo_full),
        .opsum_gon_fifo_empty(opsum_gon_fifo_empty),

        .ifmap_re_from_glb(ifmap_re_from_glb),
        .filter_re_from_glb(filter_re_from_glb),
        .ipsum_re_from_glb(ipsum_re_from_glb),
        .opsum_we_to_glb(opsum_we_to_glb),

        .ifmap_base(ifmap_base),
        .filter_base(filter_base),
        .ipsum_base(ipsum_base),
        .opsum_base(opsum_base),

        .ifmap_channel_base(ifmap_channel_base),
        .filter_channel_base(filter_channel_base),
        .ipsum_channel_base(ipsum_channel_base),
        .opsum_channel_base(opsum_channel_base),

        .ifmap_base_addr(ifmap_base_addr),
        .filter_base_addr(filter_base_addr),
        .ipsum_base_addr(ipsum_base_addr),
        .bias_base_addr(bias_base_addr),
        .opsum_base_addr(opsum_base_addr),

        .ifmap_glb_addr(ifmap_glb_addr),
        .filter_glb_addr(filter_glb_addr),
        .ipsum_glb_addr(ipsum_glb_addr),
        .bias_glb_addr(bias_glb_addr),
        .opsum_glb_addr(opsum_glb_addr),
        
        .ifmap_row_tag(ifmap_row_tag),
        .ifmap_col_tag(ifmap_col_tag),
        .filter_row_tag(filter_row_tag),
        .filter_col_tag(filter_col_tag),
        .ipsum_row_tag(ipsum_row_tag),
        .ipsum_col_tag(ipsum_col_tag),
        .opsum_row_tag(opsum_row_tag),
        .opsum_col_tag(opsum_col_tag),
    
        .ifmap_din(ifmap_from_glb),
        .filter_din(filter_from_glb),
        .ipsum_din(ipsum_from_glb),
        .opsum_din(opsum_from_gon),
    
        .ifmap_we_to_gin_fifo(push_ifmap_to_gin),
        .filter_we_to_gin_fifo(push_filter_to_gin),
        .ipsum_we_to_gin_fifo(push_ipsum_to_gin),
        .opsum_re_from_gon_fifo(pop_opsum_from_gon),
        
        .ifmap_tags_fifo_full(ifmap_tags_full),
        .filter_tags_fifo_full(filter_tags_full),
        .ipsum_tags_fifo_full(ipsum_tags_full),
        .opsum_tags_fifo_full(opsum_tags_full),
        
        .we_ifmap_tags(ifmap_tags_wr_en), 
        .we_filter_tags(filter_tags_wr_en),
        .we_ipsum_tags(ipsum_tags_wr_en),
        .we_opsum_tags(opsum_tags_wr_en), 
              
        .ifmap_dout(ifmap_to_gin),
        .filter_dout(filter_to_gin),
        .ipsum_dout(ipsum_to_gin),
        .opsum_dout(opsum_to_glb)
    );

endmodule
