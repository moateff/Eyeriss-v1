/* 
Hint:
-----
This is (not) the top module for the system 
we need to integrate the eyeriss module with top_controller
in top_alexnet.sv
-----------------------------------------------------------------------------------------------
Eyeriss module including these modules:
---------------------------------------
    1) Processing_Units >> Performing (Convolution, Norm, Maxpooling & Padding)
    2) GLBs_UNIT        >> Sharable Memory between processing unit & FIFO 
    3) INTERFACE_UNIT   >> Interfacing between on-chip memory (GLBs) & off-chip memory (SD card)
    4) ACCESS_UNIT      >> Controlling the accessing of sharable GLBs
------------------------------------------------------------------------------------------------
Expected Inputs:
----------------
 __ clocks, reset, configurations, enables and start signals for scheduling the layers 
    and also the data transfer management.

Expected Outputs:
-----------------
 __ flags (done & busy signals, enables reading from the SD card
            "signals from FIFO interface to DRAM" )

Any other signals >> should be internal signals to all connect the modules with each other
------------------------------------------------------------------------------------------------
Additional Notes:
-----------------
 __ Try to use meaningful naming convention for signals(avoid using letters)
 __ We need to take care of duplicated parameters 
*/

module eyeriss #(
    // parameters for processing units
    parameter CHUNK_DEPTH = 384, 
    
	parameter WIIA = 3,  
    parameter WIFA = 13,  
    parameter WIIB = 3,  
    parameter WIFB = 13,  
    parameter WOI  = 3, 
    parameter WOF  = 13,   
    
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

    parameter GIN_DATA_FIFO_DEPTH = 8,
    parameter GIN_TAGS_FIFO_DEPTH = 8,

    parameter GON_DATA_FIFO_DEPTH = 8,
    parameter GON_TAGS_FIFO_DEPTH = 8,
    
    parameter PE_IFMAP_FIFO_DEPTH  = 16,
    parameter PE_FILTER_FIFO_DEPTH = 16,
    parameter PE_PSUM_FIFO_DEPTH   = 16,
    
    parameter IFMAP_SPAD_DEPTH  = 12,
    parameter FILTER_SPAD_DEPTH = 224,
    parameter PSUM_SPAD_DEPTH   = 24,
    
    parameter H_WIDTH = 8,
    parameter W_WIDTH = 8,
    parameter R_WIDTH = 4,
    parameter S_WIDTH = 4,
    parameter E_WIDTH = 6,
    parameter F_WIDTH = 6,

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

    parameter X_WIDTH = 1, 

    parameter ROW_MAJOR  = 1,
    parameter ADDR_WIDTH = 20,
    parameter DATA_WIDTH = 16,


    // parameters for Interface unit 
    parameter FIFO_WIDTH = 64,
    parameter FIFO_DEPTH = 16,

    //parameters for GLB's 
    parameter IFMAP_GLB_DEPTH  = 154587,
    parameter FILTER_GLB_DEPTH = 884736,
    parameter PSUM_GLB_DEPTH   = 193600,
    parameter BIAS_GLB_DEPTH   = 384
) (
    // General Signals
    input  logic core_clk,
    input  logic link_clk,
    input  logic reset,

    //Signals for scan chain
    input  logic scan_enable, 
    input  logic scan_in,
    output logic scan_out,  

    // Control Signals
    input  logic enable_noc,                           
    input  logic enable_lrn,
    input  logic enable_pad,

    input  logic start_noc,                           
    input  logic start_lrn,
    input  logic start_pad,
        
    output logic done_noc,                           
    output logic done_lrn,    
    output logic done_pad,  

    // Signals for the access control unit
    input  logic bias_sel,                         
    input  logic lrn_sel,

    // Signals for the processing unit 
    input  logic  [N_WIDTH - 1:0] ifmap_base,       
    input  logic  [C_WIDTH - 1:0] ifmap_channel_base,  
    input  logic  [M_WIDTH - 1:0] filter_base,     
    input  logic  [C_WIDTH - 1:0] filter_channel_base, 
    input  logic  [N_WIDTH - 1:0] ipsum_base,           
    input  logic  [M_WIDTH - 1:0] ipsum_channel_base,   
    input  logic  [N_WIDTH - 1:0] opsum_base,         
    input  logic  [M_WIDTH - 1:0] opsum_channel_base,

    input  logic  [ADDR_WIDTH - 1:0] ifmap_base_addr,  
    input  logic  [ADDR_WIDTH - 1:0] filter_base_addr, 
    input  logic  [ADDR_WIDTH - 1:0] ipsum_base_addr,   
    input  logic  [ADDR_WIDTH - 1:0] bias_base_addr,  
    input  logic  [ADDR_WIDTH - 1:0] opsum_base_addr, 
    
    // Signals for the FIFO
    input  logic [ADDR_WIDTH - 1:0] words_num,
	input  logic [ADDR_WIDTH - 1:0] base_addr,

    input  logic                    start_forward,
    input  logic [1:0]              transfer_type,
    output logic                    re_from_dram,
    input  logic [FIFO_WIDTH - 1:0] rdata_from_dram,
    input  logic                    valid_from_dram,

    input  logic                    start_backward,
    output logic                    we_to_dram,
    output logic [FIFO_WIDTH - 1:0] wdata_to_dram,

    output logic                    forward_transfer_done,
    output logic                    backward_transfer_done,
    
    output logic  [H_WIDTH - 1:0] H,
    output logic  [R_WIDTH - 1:0] R,
    output logic  [E_WIDTH - 1:0] E,
    output logic  [C_WIDTH - 1:0] C,
    output logic  [M_WIDTH - 1:0] M,
    output logic  [N_WIDTH - 1:0] N,
    output logic  [U_WIDTH - 1:0] U,
    output logic  [V_WIDTH - 1:0] V,
    output logic  [n_WIDTH - 1:0] n,
    output logic  [e_WIDTH - 1:0] e,
    output logic  [p_WIDTH - 1:0] p,
    output logic  [q_WIDTH - 1:0] q,
    output logic  [r_WIDTH - 1:0] r,
    output logic  [t_WIDTH - 1:0] t,
    output logic  [X_WIDTH - 1:0] X
);

    //--------------------------------------- Signals Declaration---------------------------------------------------\\

    // Signals for  Mapping parameters (configurations)
    // Mapping parameters (configurations)
    // logic  [H_WIDTH - 1:0] H;
    // logic  [R_WIDTH - 1:0] R;
    // logic  [E_WIDTH - 1:0] E;
    // logic  [C_WIDTH - 1:0] C;
    // logic  [M_WIDTH - 1:0] M;
    // logic  [N_WIDTH - 1:0] N;
    // logic  [U_WIDTH - 1:0] U;
    // logic  [V_WIDTH - 1:0] V;
    // logic  [n_WIDTH - 1:0] n;
    // logic  [e_WIDTH - 1:0] e;
    // logic  [p_WIDTH - 1:0] p;
    // logic  [q_WIDTH - 1:0] q;
    // logic  [r_WIDTH - 1:0] r;
    // logic  [t_WIDTH - 1:0] t;
    // logic  [X_WIDTH - 1:0] X;
    logic  scan_w;

    // Signals for the processing unit
    
	// Signals for FIFO Interface
    logic                    we_from_fifo_to_ifmap_glb;
	logic [FIFO_WIDTH - 1:0] wdata_from_fifo_to_ifmap_glb;
    logic [ADDR_WIDTH - 1:0] waddr_from_fifo_to_ifmap_glb;

    logic                    we_from_fifo_to_filter_glb;
	logic [FIFO_WIDTH - 1:0] wdata_from_fifo_to_filter_glb;
	logic [ADDR_WIDTH - 1:0] waddr_from_fifo_to_filter_glb;

	logic                    we_from_fifo_to_bias_glb;
	logic [FIFO_WIDTH - 1:0] wdata_from_fifo_to_bias_glb;
	logic [ADDR_WIDTH - 1:0] waddr_from_fifo_to_bias_glb;

	logic                    re_from_fifo_to_ifmap_glb;
	logic [FIFO_WIDTH - 1:0] rdata_from_ifmap_glb_to_fifo;
	logic [ADDR_WIDTH - 1:0] raddr_from_fifo_to_ifmap_glb;

    // Signals for GLBs
    //--------------------------------------------IFMAP GLB--------------------------------------------\\  
	logic                  we_a_ifmap_glb;         
    logic [FIFO_WIDTH-1:0] wdata_a_ifmap_glb;       
	logic                  re_a_ifmap_glb;                              
	logic [FIFO_WIDTH-1:0] rdata_a_ifmap_glb;
    logic [ADDR_WIDTH-1:0] addr_a_ifmap_glb;  

    logic                  we_b_ifmap_glb;           
    logic [DATA_WIDTH-1:0] wdata_b_ifmap_glb;      
    logic                  re_b_ifmap_glb;          
    logic [DATA_WIDTH-1:0] rdata_b_ifmap_glb; 
    logic [ADDR_WIDTH-1:0] addr_b_ifmap_glb;         

    //--------------------------------------------FILTER GLB--------------------------------------------\\
    
	logic                  we_a_filter_glb;          
    logic [FIFO_WIDTH-1:0] wdata_a_filter_glb;          
    logic [ADDR_WIDTH-1:0] waddr_a_filter_glb;

    logic                  re_b_filter_glb;         
    logic [DATA_WIDTH-1:0] rdata_b_filter_glb;        
    logic [ADDR_WIDTH-1:0] raddr_b_filter_glb;       

    //--------------------------------------------BIAS GLB----------------------------------------------\\
	logic                  we_a_bias_glb;            
    logic [FIFO_WIDTH-1:0] wdata_a_bias_glb;       
    logic [ADDR_WIDTH-1:0] waddr_a_bias_glb;

	logic                  re_b_bias_glb;                                
    logic [DATA_WIDTH-1:0] rdata_b_bias_glb;          
 	logic [ADDR_WIDTH-1:0] raddr_b_bias_glb;          

    //--------------------------------------------PSUM GLB----------------------------------------------\\
	logic                  we_a_psum_glb;            
    logic [DATA_WIDTH-1:0] wdata_a_psum_glb;                              
	logic [ADDR_WIDTH-1:0] waddr_a_psum_glb;

	logic                  re_b_psum_glb;                    
    logic [DATA_WIDTH-1:0] rdata_b_psum_glb;         
    logic [ADDR_WIDTH-1:0] raddr_b_psum_glb;       

    // Signals for the access control unit
    // FIFO
    logic                  backward_sel;
    
    // Signals for processing units
    // PE array
    logic                  ifmap_re_from_noc_to_glb;
    logic [ADDR_WIDTH-1:0] ifmap_raddr_from_noc_to_glb;
    logic [DATA_WIDTH-1:0] ifmap_rdata_from_glb_to_noc;

    logic                  filter_re_from_noc_to_glb;
    logic [ADDR_WIDTH-1:0] filter_raddr_from_noc_to_glb;
    logic [DATA_WIDTH-1:0] filter_rdata_from_glb_to_noc;

    logic                  ipsum_re_from_noc_to_glb;
    logic [ADDR_WIDTH-1:0] ipsum_raddr_from_noc_to_glb;
    logic [ADDR_WIDTH-1:0] bias_raddr_from_noc_to_glb;
    logic [DATA_WIDTH-1:0] ipsum_rdata_from_glb_to_noc;

    logic                  opsum_we_from_noc_to_glb;
    logic [ADDR_WIDTH-1:0] opsum_waddr_from_noc_to_glb;
    logic [DATA_WIDTH-1:0] opsum_wdata_from_noc_to_glb;

    // LRN
    logic                  we_from_lrn_to_glb;
    logic [ADDR_WIDTH-1:0] waddr_from_lrn_to_glb;
    logic [DATA_WIDTH-1:0] wdata_from_lrn_to_glb;

    logic                  re_from_lrn_to_glb;
    logic [ADDR_WIDTH-1:0] raddr_from_lrn_to_glb;
    logic [DATA_WIDTH-1:0] rdata_from_glb_to_lrn;

    // Padding Unit
    logic                  we_from_pad_to_glb;
    logic [ADDR_WIDTH-1:0] waddr_from_pad_to_glb;
    logic [DATA_WIDTH-1:0] wdata_from_pad_to_glb;

    
    /*--------------------------------------- Shape mapping parameters for congig---------------------------------------------------\\
        the mapping parameters, cnn shape parameters, ids, enables and local network selectors is configured serially bit by 
        bit from the off chip part using scan in , scan enable and clk 
    --------------------------------------------------------------------------------------------------------------------------*/
    parameters_scan_chain #(
        .H_WIDTH(H_WIDTH),
        //.W_WIDTH(W_WIDTH),
        .R_WIDTH(R_WIDTH),
        //.S_WIDTH(S_WIDTH),
        .E_WIDTH(E_WIDTH),
        //.F_WIDTH(F_WIDTH),

        .C_WIDTH(C_WIDTH),
        .M_WIDTH(M_WIDTH),
        .N_WIDTH(N_WIDTH),
        .U_WIDTH(U_WIDTH),
        .V_WIDTH(V_WIDTH),

        .n_WIDTH(n_WIDTH),
        .e_WIDTH(e_WIDTH),
        .p_WIDTH(p_WIDTH),
        .q_WIDTH(q_WIDTH),
        .r_WIDTH(r_WIDTH),
        .t_WIDTH(t_WIDTH),

        .X_WIDTH(X_WIDTH)
    )PARAMETERS(
        .clk(link_clk),
        .reset(reset),
        
        .se(scan_enable),
        .si(scan_in),
        .so(scan_w),
        
        .H(H),
        .R(R),
        .E(E),
        .C(C),
        .M(M),
        .N(N),
        .U(U),
        .V(V),
        .n(n),
        .e(e),
        .p(p),
        .q(q),
        .r(r),
        .t(t),
        .X(X)
    );


    /*--------------------------------------- Processing Unit Instantiation---------------------------------------------------\\
        The processing unit is the main module of the eyeriss architecture. 
        It performs the convolution, normalization, maxpooling and padding operations.
    --------------------------------------------------------------------------------------------------------------------------*/
    Processing_Units #(
        .CHUNK_DEPTH(CHUNK_DEPTH),

        .WIIA(WIIA),
        .WIFA(WIFA),
        .WIIB(WIIB),
        .WIFB(WIFB),
        .WOI(WOI),
        .WOF(WOF),

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

        .IFMAP_SPAD_DEPTH(IFMAP_SPAD_DEPTH),
        .FILTER_SPAD_DEPTH(FILTER_SPAD_DEPTH),
        .PSUM_SPAD_DEPTH(PSUM_SPAD_DEPTH),

        .H_WIDTH(H_WIDTH),
        .W_WIDTH(W_WIDTH),
        .R_WIDTH(R_WIDTH),
        .S_WIDTH(S_WIDTH),
        .E_WIDTH(E_WIDTH),
        .F_WIDTH(F_WIDTH),

        .C_WIDTH(C_WIDTH),
        .M_WIDTH(M_WIDTH),
        .N_WIDTH(N_WIDTH),
        .U_WIDTH(U_WIDTH),
        .V_WIDTH(V_WIDTH),

        .n_WIDTH(n_WIDTH),
        .e_WIDTH(e_WIDTH),
        .p_WIDTH(p_WIDTH),
        .q_WIDTH(q_WIDTH),
        .r_WIDTH(r_WIDTH),
        .t_WIDTH(t_WIDTH),

        .X_WIDTH(X_WIDTH),

        .ROW_MAJOR(ROW_MAJOR),
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) PROCESSING (
        .core_clk(core_clk),
        .link_clk(link_clk),
        .reset(reset),
        //.configure(configure),

        // Mapping Params
        .H(H),
        .R(R),
        .E(E),
        .C(C),
        .M(M),
        .N(N),
        .U(U),
        .V(V),
        .n(n),
        .e(e),
        .p(p),
        .q(q),
        .r(r),
        .t(t),
        .X(X),

        // PE Array
        .start_noc(start_noc),
        .busy_noc(),
        .done_noc(done_noc),
        
        // IFMAP Interface
        .ifmap_base(ifmap_base),
        .ifmap_channel_base(ifmap_channel_base),
        .ifmap_base_addr(ifmap_base_addr),

        .ifmap_re_from_glb(ifmap_re_from_noc_to_glb),
        .ifmap_glb_addr(ifmap_raddr_from_noc_to_glb),
        .ifmap_from_glb(ifmap_rdata_from_glb_to_noc),

        // FILTER Interface
        .filter_base(filter_base),
        .filter_channel_base(filter_channel_base),
        .filter_base_addr(filter_base_addr),
        
        .filter_re_from_glb(filter_re_from_noc_to_glb),
        .filter_glb_addr(filter_raddr_from_noc_to_glb),
        .filter_from_glb(filter_rdata_from_glb_to_noc),

        // IPSUM Interface
        .ipsum_base(ipsum_base),
        .ipsum_channel_base(ipsum_channel_base),
        .ipsum_base_addr(ipsum_base_addr),
        .bias_base_addr(bias_base_addr),
                
        .ipsum_re_from_glb(ipsum_re_from_noc_to_glb),
        .ipsum_glb_addr(ipsum_raddr_from_noc_to_glb),
        .bias_glb_addr(bias_raddr_from_noc_to_glb),
        .ipsum_from_glb(ipsum_rdata_from_glb_to_noc),

        // OPSUM Interface
        .opsum_base(opsum_base),
        .opsum_channel_base(opsum_channel_base),
        .opsum_base_addr(opsum_base_addr),
                
        .opsum_we_to_glb(opsum_we_from_noc_to_glb),
        .opsum_glb_addr(opsum_waddr_from_noc_to_glb),
        .opsum_to_glb(opsum_wdata_from_noc_to_glb),

        // Scan Chain
        .se(scan_enable),
        .si(scan_w),
        .so(scan_out),

        // Normalization (LRN)
        .start_lrn(start_lrn),
        .enable_lrn(enable_lrn),
        .done_lrn(done_lrn),
        
        .re_from_lrn_to_glb(re_from_lrn_to_glb),
        .rdata_from_glb_to_lrn(rdata_from_glb_to_lrn),
        .raddr_from_lrn_to_glb(raddr_from_lrn_to_glb),
        
        .we_from_lrn_to_glb(we_from_lrn_to_glb),
        .wdata_from_lrn_to_glb(wdata_from_lrn_to_glb),
        .waddr_from_lrn_to_glb(waddr_from_lrn_to_glb),

        // Padding Unit
        .start_pad(start_pad),
        .enable_pad(enable_pad),
        .done_pad(done_pad),
        
        .we_from_pad_to_glb(we_from_pad_to_glb),
        .wdata_from_pad_to_glb(wdata_from_pad_to_glb),
        .waddr_from_pad_to_glb(waddr_from_pad_to_glb)
    );

    /*---------------------------------------  INTERFACE_UNIT  Instantiation---------------------------------------------------\\
        It is used to store the data that is being transferred between the processing unit and the GLB.
        Asynch to handle different clock domains (core_clk & link_clk).
    --------------------------------------------------------------------------------------------------------------------------*/
	INTERFACE_UNIT #(
        .FIFO_WIDTH(FIFO_WIDTH),      
        .GLB_WIDTH(DATA_WIDTH),       
        .DEPTH(FIFO_DEPTH),           
        .ADDR_WIDTH(ADDR_WIDTH)      
    ) INTF (
        .core_clk(core_clk),
        .link_clk(link_clk),
        .reset(reset),

        .words_num(words_num),
        .base_address(base_addr),
        .Direct_Back_Path(backward_sel),

        .start_forward(start_forward),
        .ifmap_filter_bias_transfer(transfer_type),
        .for_transfer_done(forward_transfer_done),
        
        .w_en_ifmap_GLB(we_from_fifo_to_ifmap_glb),
        .rdata_to_ifmap_GLB(wdata_from_fifo_to_ifmap_glb),
        .write_address_to_ifmap_GLB(waddr_from_fifo_to_ifmap_glb),    

        .w_en_filter_GLB(we_from_fifo_to_filter_glb),
        .rdata_to_filter_GLB(wdata_from_fifo_to_filter_glb),
        .write_address_to_filter_GLB(waddr_from_fifo_to_filter_glb),

        .w_en_bias_GLB(we_from_fifo_to_bias_glb),
        .rdata_to_bias_GLB(wdata_from_fifo_to_bias_glb),
        .write_address_to_bias_GLB(waddr_from_fifo_to_bias_glb),

        .start_backward(start_backward),
        .wdata_from_GLB(rdata_from_ifmap_glb_to_fifo),
        .raddr_from_GLB(raddr_from_fifo_to_ifmap_glb),
        .back_transfer_done(backward_transfer_done),

        .r_en_DRAM(re_from_dram),
        .valid_from_DRAM(valid_from_dram),
        .wdata_from_DRAM(rdata_from_dram),
		
        .w_en_DRAM(we_to_dram),
        .r_en_GLB(re_from_fifo_to_ifmap_glb),
        .rdata_to_DRAM(wdata_to_dram)
    );

    /*--------------------------------------- GLBs Instantiation---------------------------------------------------\\
        The GLB is the shared memory between the processing unit and the FIFO. 
        It is used to store the intermediate results of the processing unit and the data from the FIFO.
        The GLB is a multi-port memory that can be accessed by multiple processing units and FIFOs at the same time.
        The GLB is also used to store the weights and biases of the neural network.
        Consist of 4 buffers:
        ---------------------
        - ifmap buffer    (ifmap for all layers)
        - filter buffer (filter weights)
        - psum buffer   (ipsum and opsum)
        - bias buffer   (biases of filters)
    --------------------------------------------------------------------------------------------------------------------------*/    

    GLBs_UNIT #(
        .FIFO_WIDTH(FIFO_WIDTH), 
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH_ifmap(IFMAP_GLB_DEPTH),
        .DEPTH_filter(FILTER_GLB_DEPTH), 
        .DEPTH_psum(PSUM_GLB_DEPTH), 
        .DEPTH_bias(BIAS_GLB_DEPTH)	  
    ) GLB (
        .core_clk(core_clk),

        //--------------------------------------------IFMAP GLB--------------------------------------------\\
        // port A (64 bits)
        // write/read port 
        .wdata_a_ifmap(wdata_a_ifmap_glb),
        .we_a_ifmap(we_a_ifmap_glb),   
        .re_a_ifmap(re_a_ifmap_glb),   
        .addr_a_ifmap(addr_a_ifmap_glb), 
        .rdata_a_ifmap(rdata_a_ifmap_glb),
        
        // port B (16 bits) 
        // write/read port
        .wdata_b_ifmap(wdata_b_ifmap_glb),
        .we_b_ifmap(we_b_ifmap_glb),   
        .re_b_ifmap(re_b_ifmap_glb),
        .addr_b_ifmap(addr_b_ifmap_glb),
        .rdata_b_ifmap(rdata_b_ifmap_glb),

        //--------------------------------------------FILTER GLB--------------------------------------------\\
        // port A (64 bits)  
        // write only port                                     
        .we_f(we_a_filter_glb),
        .wdata_f(wdata_a_filter_glb), 
        .waddr_f(waddr_a_filter_glb),
        
        // port B (16 bits)
        // read only port
        .re_f(re_b_filter_glb),  
        .rdata_f(rdata_b_filter_glb),
        .raddr_f(raddr_b_filter_glb),
             
        //--------------------------------------------PSUM GLB----------------------------------------------\\
        // port A (16 bits)  
        // write only port                       
        .we_a_psum(we_a_psum_glb),
        .wdata_a_psum(wdata_a_psum_glb),   
        .addr_a_psum(waddr_a_psum_glb),           

        // port B (16 bits)
        // read only port
        .re_b_psum(re_b_psum_glb), 
        .rdata_b_psum(rdata_b_psum_glb),                                    
        .addr_b_psum(raddr_b_psum_glb),              

        //--------------------------------------------BIAS GLB----------------------------------------------\\
        // port A (64 bits)
        // write only port
        .we_bias(we_a_bias_glb),
        .wdata_bias(wdata_a_bias_glb),  
        .waddr_bias(waddr_a_bias_glb), 

        // port B (16 bits)
        // read only port
        .re_bias(re_b_bias_glb),                          
        .rdata_bias(rdata_b_bias_glb),
        .raddr_bias(raddr_b_bias_glb)
    );

    /*--------------------------------------- Access Control Instantiation---------------------------------------------------\\
        The access control unit is used to control the access of the processing unit and the FIFO to the GLB.
        It is used to prevent data hazards and ensure that the data is transferred correctly between the processing unit and the FIFO.
    --------------------------------------------------------------------------------------------------------------------------*/
    access_control_wrapper #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_WIDTH(FIFO_WIDTH)
    ) ACCESS_CONTROL (
        .noc_enable(enable_noc),
        .lrn_enable(enable_lrn), 
        .padding_enable(enable_pad),

        .bias_sel(bias_sel),
        .lrn_sel(lrn_sel),
        .mode_sel(X),
        .backward_sel(backward_sel),
        
        .we_a_ifmap_glb(we_a_ifmap_glb),
        .wdata_a_ifmap_glb(wdata_a_ifmap_glb),
        .re_a_ifmap_glb(re_a_ifmap_glb),
        .rdata_a_ifmap_glb(rdata_a_ifmap_glb),
        .addr_a_ifmap_glb(addr_a_ifmap_glb),

        .we_b_ifmap_glb(we_b_ifmap_glb),
        .wdata_b_ifmap_glb(wdata_b_ifmap_glb),
        .re_b_ifmap_glb(re_b_ifmap_glb),
        .rdata_b_ifmap_glb(rdata_b_ifmap_glb),
        .addr_b_ifmap_glb(addr_b_ifmap_glb),

        .we_a_filter_glb(we_a_filter_glb),
        .wdata_a_filter_glb(wdata_a_filter_glb),
        .waddr_a_filter_glb(waddr_a_filter_glb),
        .re_b_filter_glb(re_b_filter_glb),
        .rdata_b_filter_glb(rdata_b_filter_glb),
        .raddr_b_filter_glb(raddr_b_filter_glb),

        .we_a_bias_glb(we_a_bias_glb),
        .wdata_a_bias_glb(wdata_a_bias_glb),
        .waddr_a_bias_glb(waddr_a_bias_glb),
        .re_b_bias_glb(re_b_bias_glb),
        .rdata_b_bias_glb(rdata_b_bias_glb),
        .raddr_b_bias_glb(raddr_b_bias_glb),

        .we_a_psum_glb(we_a_psum_glb),
        .wdata_a_psum_glb(wdata_a_psum_glb),
        .waddr_a_psum_glb(waddr_a_psum_glb),
        .re_b_psum_glb(re_b_psum_glb),
        .rdata_b_psum_glb(rdata_b_psum_glb),
        .raddr_b_psum_glb(raddr_b_psum_glb),

        .we_from_fifo_to_ifmap_glb(we_from_fifo_to_ifmap_glb),
        .wdata_from_fifo_to_ifmap_glb(wdata_from_fifo_to_ifmap_glb),
        .waddr_from_fifo_to_ifmap_glb(waddr_from_fifo_to_ifmap_glb),

        .we_from_fifo_to_filter_glb(we_from_fifo_to_filter_glb),
        .wdata_from_fifo_to_filter_glb(wdata_from_fifo_to_filter_glb),
        .waddr_from_fifo_to_filter_glb(waddr_from_fifo_to_filter_glb),

        .we_from_fifo_to_bias_glb(we_from_fifo_to_bias_glb),
        .wdata_from_fifo_to_bias_glb(wdata_from_fifo_to_bias_glb),
        .waddr_from_fifo_to_bias_glb(waddr_from_fifo_to_bias_glb),

        .re_from_fifo_to_ifmap_glb(re_from_fifo_to_ifmap_glb),
        .rdata_from_ifmap_glb_to_fifo(rdata_from_ifmap_glb_to_fifo),
        .raddr_from_fifo_to_ifmap_glb(raddr_from_fifo_to_ifmap_glb),

        .opsum_we_from_noc_to_glb(opsum_we_from_noc_to_glb),
        .opsum_wdata_from_noc_to_glb(opsum_wdata_from_noc_to_glb),
        .opsum_waddr_from_noc_to_glb(opsum_waddr_from_noc_to_glb),

        .ifmap_re_from_noc_to_glb(ifmap_re_from_noc_to_glb),
        .ifmap_rdata_from_glb_to_noc(ifmap_rdata_from_glb_to_noc),
        .ifmap_raddr_from_noc_to_glb(ifmap_raddr_from_noc_to_glb),

        .filter_re_from_noc_to_glb(filter_re_from_noc_to_glb),
        .filter_rdata_from_glb_to_noc(filter_rdata_from_glb_to_noc),
        .filter_raddr_from_noc_to_glb(filter_raddr_from_noc_to_glb),

        .ipsum_re_from_noc_to_glb(ipsum_re_from_noc_to_glb),
        .ipsum_rdata_from_glb_to_noc(ipsum_rdata_from_glb_to_noc),
        .bias_raddr_from_noc_to_glb(bias_raddr_from_noc_to_glb),
        .ipsum_raddr_from_noc_to_glb(ipsum_raddr_from_noc_to_glb),

        .we_from_lrn_to_glb(we_from_lrn_to_glb),
        .wdata_from_lrn_to_glb(wdata_from_lrn_to_glb),
        .waddr_from_lrn_to_glb(waddr_from_lrn_to_glb),

        .re_from_lrn_to_glb(re_from_lrn_to_glb),
        .rdata_from_glb_to_lrn(rdata_from_glb_to_lrn),
        .raddr_from_lrn_to_glb(raddr_from_lrn_to_glb),

        .we_from_pad_to_glb(we_from_pad_to_glb),
        .wdata_from_pad_to_glb(wdata_from_pad_to_glb),
        .waddr_from_pad_to_glb(waddr_from_pad_to_glb)
    );

endmodule
