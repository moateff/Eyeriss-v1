module access_control_wrapper #(
    parameter ADDR_WIDTH = 20,
    parameter DATA_WIDTH = 16,
    parameter FIFO_WIDTH = 64
) (
    input  logic noc_enable,
    input  logic lrn_enable, 
    input  logic padding_enable,

    input  logic bias_sel,      // '1' if accumalate bias, '0' if accumalate ipsum            
    input  logic lrn_sel,       // '1' if output to be written to ifmap glb, '0' if output to be written to psum glb
    input  logic mode_sel,      // '1' if max, '0' if conv
    input  logic backward_sel,  // '1' if backward, '0' if forward

    //--------------------------------------------IFMAP GLB--------------------------------------------\\
    // port A (64 bits) 
    // write/read port
    output logic                  we_a_ifmap_glb,           // write enable  
    output logic [FIFO_WIDTH-1:0] wdata_a_ifmap_glb,        // write data

	output logic                  re_a_ifmap_glb,           // read enable                       
	input  logic [FIFO_WIDTH-1:0] rdata_a_ifmap_glb,        // read data 

    output logic [ADDR_WIDTH-1:0] addr_a_ifmap_glb,         // write/read address 

	// port B (16 bits)                                     
	// write/read port
    output logic                  we_b_ifmap_glb,           // write enable
    output logic [DATA_WIDTH-1:0] wdata_b_ifmap_glb,        // write data 

	output logic                  re_b_ifmap_glb,           // read enable  
    input  logic [DATA_WIDTH-1:0] rdata_b_ifmap_glb,        // read data           

    output logic [ADDR_WIDTH-1:0] addr_b_ifmap_glb,        // write/read address 

    //--------------------------------------------FILTER GLB--------------------------------------------\\
    // port A (64 bits)
    // write only port
    output logic                  we_a_filter_glb,          // write enable
    output logic [FIFO_WIDTH-1:0] wdata_a_filter_glb,       // write data      
    output logic [ADDR_WIDTH-1:0] waddr_a_filter_glb,       // write address   

    // port B (16 bits)                                
	// read only port
    output logic                  re_b_filter_glb,          // read enable  
    input  logic [DATA_WIDTH-1:0] rdata_b_filter_glb,       // read data  
    output logic [ADDR_WIDTH-1:0] raddr_b_filter_glb,       // read address  

    //--------------------------------------------BIAS GLB----------------------------------------------\\
    // port A (64 bits)
    // write only port
	output logic                  we_a_bias_glb,            // write enable
    output logic [FIFO_WIDTH-1:0] wdata_a_bias_glb,         // write data 
    output logic [ADDR_WIDTH-1:0] waddr_a_bias_glb,         // write address 

    // port B (16 bits)
    // read only port
	output logic                  re_b_bias_glb,            // read enable                        
    input  logic [DATA_WIDTH-1:0] rdata_b_bias_glb,         // read data  
 	output logic [ADDR_WIDTH-1:0] raddr_b_bias_glb,         // read address 

    //--------------------------------------------PSUM GLB----------------------------------------------\\
    // port A (16 bits)
    // write only port
	output logic                  we_a_psum_glb,            // write enable
    output logic [DATA_WIDTH-1:0] wdata_a_psum_glb,         // write data                        
	output logic [ADDR_WIDTH-1:0] waddr_a_psum_glb,         // write address       
	
	// port B (16 bits)
    // read only port
	output logic                  re_b_psum_glb,            // read enable            
    input  logic [DATA_WIDTH-1:0] rdata_b_psum_glb,         // read data 
    output logic [ADDR_WIDTH-1:0] raddr_b_psum_glb,         // read address    

    //-----------------------------------------------FIFO--------------------------------------------------\\
    //------------------------------------------WRITE (64 bits)--------------------------------------------\\
    input  logic                    we_from_fifo_to_ifmap_glb,          // write enable
    input  logic [FIFO_WIDTH - 1:0] wdata_from_fifo_to_ifmap_glb,       // write data 
    input  logic [ADDR_WIDTH - 1:0] waddr_from_fifo_to_ifmap_glb,       // write address

    input  logic                    we_from_fifo_to_filter_glb,         // write enable
    input  logic [FIFO_WIDTH - 1:0] wdata_from_fifo_to_filter_glb,      // write data 
    input  logic [ADDR_WIDTH - 1:0] waddr_from_fifo_to_filter_glb,      // write address

    input  logic                    we_from_fifo_to_bias_glb,           // write enable
    input  logic [FIFO_WIDTH - 1:0] wdata_from_fifo_to_bias_glb,        // write data 
    input  logic [ADDR_WIDTH - 1:0] waddr_from_fifo_to_bias_glb,        // write address

    //-----------------------------------------READ (64 bits)----------------------------------------------\\
    input  logic                    re_from_fifo_to_ifmap_glb,          // read enable
    output logic [FIFO_WIDTH - 1:0] rdata_from_ifmap_glb_to_fifo,       // read data     
    input  logic [ADDR_WIDTH - 1:0] raddr_from_fifo_to_ifmap_glb,       // read address

    //----------------------------------------------NOC----------------------------------------------------\\
    //-----------------------------------------WRITE (16 bits)---------------------------------------------\\
    input  logic                    opsum_we_from_noc_to_glb,           // write enable
    input  logic [DATA_WIDTH - 1:0] opsum_wdata_from_noc_to_glb,        // write data     
    input  logic [ADDR_WIDTH - 1:0] opsum_waddr_from_noc_to_glb,        // write address

    //-----------------------------------------READ (16 bits)----------------------------------------------\\
    input  logic                    ifmap_re_from_noc_to_glb,           // read enable
    output logic [DATA_WIDTH - 1:0] ifmap_rdata_from_glb_to_noc,        // read data     
    input  logic [ADDR_WIDTH - 1:0] ifmap_raddr_from_noc_to_glb,        // read address

    input  logic                    filter_re_from_noc_to_glb,          // read enable
    output logic [DATA_WIDTH - 1:0] filter_rdata_from_glb_to_noc,       // read data     
    input  logic [ADDR_WIDTH - 1:0] filter_raddr_from_noc_to_glb,       // read address

    input  logic                    ipsum_re_from_noc_to_glb,            // read enable
    output logic [DATA_WIDTH - 1:0] ipsum_rdata_from_glb_to_noc,         // read data     
    input  logic [ADDR_WIDTH - 1:0] bias_raddr_from_noc_to_glb,          // read address
    input  logic [ADDR_WIDTH - 1:0] ipsum_raddr_from_noc_to_glb,         // read address

    //----------------------------------------------LRN----------------------------------------------------\\
    //-----------------------------------------WRITE (16 bits)---------------------------------------------\\
    input  logic                    we_from_lrn_to_glb,                 // write enable
    input  logic [DATA_WIDTH - 1:0] wdata_from_lrn_to_glb,              // write data 
    input  logic [ADDR_WIDTH - 1:0] waddr_from_lrn_to_glb,              // write address
    
    //-----------------------------------------READ (16 bits)----------------------------------------------\\
    input  logic                    re_from_lrn_to_glb,                 // read enable 
    output logic [DATA_WIDTH - 1:0] rdata_from_glb_to_lrn,              // read data
    input  logic [ADDR_WIDTH - 1:0] raddr_from_lrn_to_glb,              // read address

    //------------------------------------------PADDING UNIT-----------------------------------------------\\
    //-----------------------------------------WRITE (16 bits)---------------------------------------------\\
    input  logic                    we_from_pad_to_glb,                 // write enable
    input  logic [DATA_WIDTH - 1:0] wdata_from_pad_to_glb,              // write data 
    input  logic [ADDR_WIDTH - 1:0] waddr_from_pad_to_glb               // write address
    
);

    //-----------------------------------------------FIFO--------------------------------------------------\\
    logic [ADDR_WIDTH-1:0] waddr_a_ifmap_glb;                   // write address                     
    logic [ADDR_WIDTH-1:0] raddr_a_ifmap_glb;                   // read address 

    mux2x1 #(.DATA_WIDTH(ADDR_WIDTH)) mux0 (
        .sel(backward_sel),
        .in0(waddr_a_ifmap_glb),
        .in1(raddr_a_ifmap_glb),
        .out(addr_a_ifmap_glb)
    );

    //----------------------------------------------NOC----------------------------------------------------\\
    //-----------------------------------------WRITE (16 bits)---------------------------------------------\\
    logic                    we_from_noc_to_ifmap_glb;           // write enable
    logic [DATA_WIDTH - 1:0] wdata_from_noc_to_ifmap_glb;        // write data     
    logic [ADDR_WIDTH - 1:0] waddr_from_noc_to_ifmap_glb;        // write address

    logic                    we_from_noc_to_psum_glb;            // write enable 
    logic [DATA_WIDTH - 1:0] wdata_from_noc_to_psum_glb;         // write data   
    logic [ADDR_WIDTH - 1:0] waddr_from_noc_to_psum_glb;         // write address

    demux1x2 #(.DATA_WIDTH(1 + DATA_WIDTH + ADDR_WIDTH)) demux0 (
        .sel({mode_sel}),
        .in({opsum_we_from_noc_to_glb, opsum_wdata_from_noc_to_glb, opsum_waddr_from_noc_to_glb}),
        .out0({we_from_noc_to_psum_glb, wdata_from_noc_to_psum_glb, waddr_from_noc_to_psum_glb}),
        .out1({we_from_noc_to_ifmap_glb, wdata_from_noc_to_ifmap_glb, waddr_from_noc_to_ifmap_glb})
    );

    //-----------------------------------------READ (16 bits)----------------------------------------------\\
    logic                    re_from_noc_to_ifmap_glb;          // read enable
    logic [DATA_WIDTH - 1:0] rdata_from_ifmap_glb_to_noc;       // read data     
    logic [ADDR_WIDTH - 1:0] raddr_from_noc_to_ifmap_glb;       // read address

    logic                    re_from_noc_to_filter_glb;          // read enable
    logic [DATA_WIDTH - 1:0] rdata_from_filter_glb_to_noc;       // read data     
    logic [ADDR_WIDTH - 1:0] raddr_from_noc_to_filter_glb;       // read address
    
    logic                    re_from_noc_to_psum_glb;            // read enable 
    logic [DATA_WIDTH - 1:0] rdata_from_psum_glb_to_noc;         // read data
    logic [ADDR_WIDTH - 1:0] raddr_from_noc_to_psum_glb;         // read address

    logic                    re_from_noc_to_bias_glb;            // read enable
    logic [DATA_WIDTH - 1:0] rdata_from_bias_glb_to_noc;         // read data     
    logic [ADDR_WIDTH - 1:0] raddr_from_noc_to_bias_glb;         // read address

    
    logic                    ipsum_re_from_noc_to_psum_glb;
    logic [ADDR_WIDTH - 1:0] ipsum_raddr_from_noc_to_psum_glb;

    logic                    ifmap_re_from_noc_to_psum_glb;
    logic [ADDR_WIDTH - 1:0] ifmap_raddr_from_noc_to_psum_glb;
    
    assign re_from_noc_to_filter_glb = filter_re_from_noc_to_glb;
    assign filter_rdata_from_glb_to_noc = rdata_from_filter_glb_to_noc;
    assign raddr_from_noc_to_filter_glb = filter_raddr_from_noc_to_glb;
    
    demux1x2 #(.DATA_WIDTH(1 + ADDR_WIDTH)) demux1 (
        .sel(mode_sel),
        .in({ifmap_re_from_noc_to_glb, ifmap_raddr_from_noc_to_glb}),
        .out0({re_from_noc_to_ifmap_glb, raddr_from_noc_to_ifmap_glb}),
        .out1({ifmap_re_from_noc_to_psum_glb, ifmap_raddr_from_noc_to_psum_glb})
    );

    mux2x1 #(.DATA_WIDTH(DATA_WIDTH)) mux1 (
        .sel(mode_sel),
        .in0(rdata_from_ifmap_glb_to_noc),
        .in1(rdata_from_psum_glb_to_noc),
        .out(ifmap_rdata_from_glb_to_noc)
    );

    demux1x2 #(.DATA_WIDTH(1)) demux2 (
        .sel(bias_sel),
        .in(ipsum_re_from_noc_to_glb),
        .out0(ipsum_re_from_noc_to_psum_glb),
        .out1(re_from_noc_to_bias_glb)
    );

    mux2x1 #(.DATA_WIDTH(DATA_WIDTH)) mux2 (
        .sel(bias_sel),
        .in0(rdata_from_psum_glb_to_noc),
        .in1(rdata_from_bias_glb_to_noc),
        .out(ipsum_rdata_from_glb_to_noc)
    );

    assign ipsum_raddr_from_noc_to_psum_glb = ipsum_raddr_from_noc_to_glb;
    assign raddr_from_noc_to_bias_glb = bias_raddr_from_noc_to_glb;

    mux2x1 #(.DATA_WIDTH(1 + ADDR_WIDTH)) mux3 (
        .sel(mode_sel),
        .in0({ipsum_re_from_noc_to_psum_glb, ipsum_raddr_from_noc_to_psum_glb}),
        .in1({ifmap_re_from_noc_to_psum_glb, ifmap_raddr_from_noc_to_psum_glb}),
        .out({re_from_noc_to_psum_glb, raddr_from_noc_to_psum_glb})
    );

    logic [ADDR_WIDTH-1:0] waddr_b_ifmap_glb;        // write address 
    logic [ADDR_WIDTH-1:0] raddr_b_ifmap_glb;        // read address 

    mux2x1 #(.DATA_WIDTH(ADDR_WIDTH)) mux4 (
        .sel(mode_sel),
        .in0(raddr_b_ifmap_glb),
        .in1(waddr_b_ifmap_glb),
        .out(addr_b_ifmap_glb)
    );

    //----------------------------------------------LRN----------------------------------------------------\\
    //-----------------------------------------WRITE (16 bits)---------------------------------------------\\
    logic                    we_from_lrn_to_ifmap_glb;           // write enable
    logic [DATA_WIDTH - 1:0] wdata_from_lrn_to_ifmap_glb;        // write data 
    logic [ADDR_WIDTH - 1:0] waddr_from_lrn_to_ifmap_glb;        // write address

    logic                    we_from_lrn_to_psum_glb;            // write enable 
    logic [DATA_WIDTH - 1:0] wdata_from_lrn_to_psum_glb;         // write data 
    logic [ADDR_WIDTH - 1:0] waddr_from_lrn_to_psum_glb;         // write address

    
    demux1x2 #(.DATA_WIDTH(1 + DATA_WIDTH + ADDR_WIDTH)) demux3 (
        .sel({lrn_sel}),
        .in({we_from_lrn_to_glb, wdata_from_lrn_to_glb, waddr_from_lrn_to_glb}),
        .out0({we_from_lrn_to_psum_glb, wdata_from_lrn_to_psum_glb, waddr_from_lrn_to_psum_glb}),
        .out1({we_from_lrn_to_ifmap_glb, wdata_from_lrn_to_ifmap_glb, waddr_from_lrn_to_ifmap_glb})
    );

    //-----------------------------------------READ (16 bits)----------------------------------------------\\
    logic                    re_from_lrn_to_psum_glb;            // read enable 
    logic [DATA_WIDTH - 1:0] rdata_from_psum_glb_to_lrn;         // read data
    logic [ADDR_WIDTH - 1:0] raddr_from_lrn_to_psum_glb;         // read address

    assign re_from_lrn_to_psum_glb = re_from_lrn_to_glb;
    assign rdata_from_glb_to_lrn = rdata_from_psum_glb_to_lrn;
    assign raddr_from_lrn_to_psum_glb = raddr_from_lrn_to_glb;
    
    //------------------------------------------PADDING UNIT-----------------------------------------------\\
    //-----------------------------------------WRITE (16 bits)---------------------------------------------\\
    logic                    we_from_pad_to_ifmap_glb;           // write enable
    logic [DATA_WIDTH - 1:0] wdata_from_pad_to_ifmap_glb;        // write data 
    logic [ADDR_WIDTH - 1:0] waddr_from_pad_to_ifmap_glb;        // write address

    assign we_from_pad_to_ifmap_glb = we_from_pad_to_glb;
    assign wdata_from_pad_to_ifmap_glb = wdata_from_pad_to_glb;
    assign waddr_from_pad_to_ifmap_glb = waddr_from_pad_to_glb;

    access_control #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_WIDTH(FIFO_WIDTH)
    ) access_control_inst (
    .noc_enable(noc_enable),
        .lrn_enable(lrn_enable),
        .padding_enable(padding_enable),

        .we_a_ifmap_glb(we_a_ifmap_glb),
        .wdata_a_ifmap_glb(wdata_a_ifmap_glb),
        .waddr_a_ifmap_glb(waddr_a_ifmap_glb),
        .re_a_ifmap_glb(re_a_ifmap_glb),
        .rdata_a_ifmap_glb(rdata_a_ifmap_glb),
        .raddr_a_ifmap_glb(raddr_a_ifmap_glb),

        .we_b_ifmap_glb(we_b_ifmap_glb),
        .wdata_b_ifmap_glb(wdata_b_ifmap_glb),
        .waddr_b_ifmap_glb(waddr_b_ifmap_glb),
        .re_b_ifmap_glb(re_b_ifmap_glb),
        .rdata_b_ifmap_glb(rdata_b_ifmap_glb),
        .raddr_b_ifmap_glb(raddr_b_ifmap_glb),

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

        .we_from_noc_to_ifmap_glb(we_from_noc_to_ifmap_glb),
        .wdata_from_noc_to_ifmap_glb(wdata_from_noc_to_ifmap_glb),
        .waddr_from_noc_to_ifmap_glb(waddr_from_noc_to_ifmap_glb),

        .we_from_lrn_to_ifmap_glb(we_from_lrn_to_ifmap_glb),
        .wdata_from_lrn_to_ifmap_glb(wdata_from_lrn_to_ifmap_glb),
        .waddr_from_lrn_to_ifmap_glb(waddr_from_lrn_to_ifmap_glb),

        .we_from_pad_to_ifmap_glb(we_from_pad_to_ifmap_glb),
        .wdata_from_pad_to_ifmap_glb(wdata_from_pad_to_ifmap_glb),
        .waddr_from_pad_to_ifmap_glb(waddr_from_pad_to_ifmap_glb),

        .re_from_fifo_to_ifmap_glb(re_from_fifo_to_ifmap_glb),
        .rdata_from_ifmap_glb_to_fifo(rdata_from_ifmap_glb_to_fifo),
        .raddr_from_fifo_to_ifmap_glb(raddr_from_fifo_to_ifmap_glb),

        .re_from_noc_to_ifmap_glb(re_from_noc_to_ifmap_glb),
        .rdata_from_ifmap_glb_to_noc(rdata_from_ifmap_glb_to_noc),
        .raddr_from_noc_to_ifmap_glb(raddr_from_noc_to_ifmap_glb),

        .we_from_fifo_to_filter_glb(we_from_fifo_to_filter_glb),
        .wdata_from_fifo_to_filter_glb(wdata_from_fifo_to_filter_glb),
        .waddr_from_fifo_to_filter_glb(waddr_from_fifo_to_filter_glb),

        .re_from_noc_to_filter_glb(re_from_noc_to_filter_glb),
        .rdata_from_filter_glb_to_noc(rdata_from_filter_glb_to_noc),
        .raddr_from_noc_to_filter_glb(raddr_from_noc_to_filter_glb),

        .we_from_fifo_to_bias_glb(we_from_fifo_to_bias_glb),
        .wdata_from_fifo_to_bias_glb(wdata_from_fifo_to_bias_glb),
        .waddr_from_fifo_to_bias_glb(waddr_from_fifo_to_bias_glb),

        .re_from_noc_to_bias_glb(re_from_noc_to_bias_glb),
        .rdata_from_bias_glb_to_noc(rdata_from_bias_glb_to_noc),
        .raddr_from_noc_to_bias_glb(raddr_from_noc_to_bias_glb),

        .we_from_noc_to_psum_glb(we_from_noc_to_psum_glb),
        .wdata_from_noc_to_psum_glb(wdata_from_noc_to_psum_glb),
        .waddr_from_noc_to_psum_glb(waddr_from_noc_to_psum_glb),

        .we_from_lrn_to_psum_glb(we_from_lrn_to_psum_glb),
        .wdata_from_lrn_to_psum_glb(wdata_from_lrn_to_psum_glb),
        .waddr_from_lrn_to_psum_glb(waddr_from_lrn_to_psum_glb),

        .re_from_noc_to_psum_glb(re_from_noc_to_psum_glb),
        .rdata_from_psum_glb_to_noc(rdata_from_psum_glb_to_noc),
        .raddr_from_noc_to_psum_glb(raddr_from_noc_to_psum_glb),

        .re_from_lrn_to_psum_glb(re_from_lrn_to_psum_glb),
        .rdata_from_psum_glb_to_lrn(rdata_from_psum_glb_to_lrn),
        .raddr_from_lrn_to_psum_glb(raddr_from_lrn_to_psum_glb)
    );

endmodule

