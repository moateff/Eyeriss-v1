module access_control #(
    parameter ADDR_WIDTH = 20,
    parameter DATA_WIDTH = 16,
    parameter FIFO_WIDTH = 64
) (
    input  logic noc_enable,
    input  logic lrn_enable, 
    input  logic padding_enable,

    //--------------------------------------------IFMAP GLB--------------------------------------------\\
    // port A (64 bits) 
    // write/read port
    output logic                  we_a_ifmap_glb,       // write enable  
    output logic [FIFO_WIDTH-1:0] wdata_a_ifmap_glb,    // write data
    output logic [ADDR_WIDTH-1:0] waddr_a_ifmap_glb,    // write address                     

	output logic                  re_a_ifmap_glb,       // read enable                       
	input  logic [FIFO_WIDTH-1:0] rdata_a_ifmap_glb,    // read data 
    output logic [ADDR_WIDTH-1:0] raddr_a_ifmap_glb,    // read address 

	// port B (16 bits)                                     
	// write/read port
    output logic                  we_b_ifmap_glb,       // write enable
    output logic [DATA_WIDTH-1:0] wdata_b_ifmap_glb,    // write data 
    output logic [ADDR_WIDTH-1:0] waddr_b_ifmap_glb,    // write address 

	output logic                  re_b_ifmap_glb,       // read enable  
    input  logic [DATA_WIDTH-1:0] rdata_b_ifmap_glb,    // read data           
    output logic [ADDR_WIDTH-1:0] raddr_b_ifmap_glb,    // read address 

    //--------------------------------------------FILTER GLB--------------------------------------------\\
    // port A (64 bits)
    // write only port
    output logic                  we_a_filter_glb,        // write enable
    output logic [FIFO_WIDTH-1:0] wdata_a_filter_glb,     // write data      
    output logic [ADDR_WIDTH-1:0] waddr_a_filter_glb,     // write address   

    // port B (16 bits)                                
	// read only port
    output logic                  re_b_filter_glb,        // read enable  
    input  logic [DATA_WIDTH-1:0] rdata_b_filter_glb,     // read data  
    output logic [ADDR_WIDTH-1:0] raddr_b_filter_glb,     // read address  

    //--------------------------------------------BIAS GLB----------------------------------------------\\
    // port A (64 bits)
    // write only port
	output logic                  we_a_bias_glb,           // write enable
    output logic [FIFO_WIDTH-1:0] wdata_a_bias_glb,        // write data 
    output logic [ADDR_WIDTH-1:0] waddr_a_bias_glb,        // write address 

    // port B (16 bits)
    // read only port
	output logic                  re_b_bias_glb,           // read enable                        
    input  logic [DATA_WIDTH-1:0] rdata_b_bias_glb,        // read data  
 	output logic [ADDR_WIDTH-1:0] raddr_b_bias_glb,        // read address 

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

    //-------------------------------------------IFMAP-----------------------------------------------------\\
    //-------------------------------------------WRITE-----------------------------------------------------\\
    // port A (64 bits)
    input  logic                    we_from_fifo_to_ifmap_glb,        // write enable
    input  logic [FIFO_WIDTH - 1:0] wdata_from_fifo_to_ifmap_glb,     // write data 
    input  logic [ADDR_WIDTH - 1:0] waddr_from_fifo_to_ifmap_glb,     // write address

    // port B (16 bits)
    // noc
    input  logic                    we_from_noc_to_ifmap_glb,       // write enable
    input  logic [DATA_WIDTH - 1:0] wdata_from_noc_to_ifmap_glb,    // write data     
    input  logic [ADDR_WIDTH - 1:0] waddr_from_noc_to_ifmap_glb,    // write address

    // lrn  
    input  logic                    we_from_lrn_to_ifmap_glb,       // write enable
    input  logic [DATA_WIDTH - 1:0] wdata_from_lrn_to_ifmap_glb,    // write data 
    input  logic [ADDR_WIDTH - 1:0] waddr_from_lrn_to_ifmap_glb,    // write address

    // padding unit
    input  logic                    we_from_pad_to_ifmap_glb,       // write enable
    input  logic [DATA_WIDTH - 1:0] wdata_from_pad_to_ifmap_glb,    // write data 
    input  logic [ADDR_WIDTH - 1:0] waddr_from_pad_to_ifmap_glb,    // write address
    
    //-------------------------------------------READ-----------------------------------------------------\\
    // port A (64 bits)
    input  logic                    re_from_fifo_to_ifmap_glb,         // read enable
    output logic [FIFO_WIDTH - 1:0] rdata_from_ifmap_glb_to_fifo,      // read data     
    input  logic [ADDR_WIDTH - 1:0] raddr_from_fifo_to_ifmap_glb,      // read address

    // port B (16 bits)
    input  logic                    re_from_noc_to_ifmap_glb,          // read enable
    output logic [DATA_WIDTH - 1:0] rdata_from_ifmap_glb_to_noc,       // read data     
    input  logic [ADDR_WIDTH - 1:0] raddr_from_noc_to_ifmap_glb,       // read address
             
    //-------------------------------------------FILTER----------------------------------------------------\\
    //-------------------------------------------WRITE-----------------------------------------------------\\
    // port A (64 bits)
    input  logic                    we_from_fifo_to_filter_glb,        // write enable
    input  logic [FIFO_WIDTH - 1:0] wdata_from_fifo_to_filter_glb,     // write data 
    input  logic [ADDR_WIDTH - 1:0] waddr_from_fifo_to_filter_glb,     // write address

    //-------------------------------------------READ------------------------------------------------------\\
    // port B (16 bits)
    input  logic                    re_from_noc_to_filter_glb,          // read enable
    output logic [DATA_WIDTH - 1:0] rdata_from_filter_glb_to_noc,       // read data     
    input  logic [ADDR_WIDTH - 1:0] raddr_from_noc_to_filter_glb,       // read address
    
    //-------------------------------------------BIAS------------------------------------------------------\\
    //-------------------------------------------WRITE-----------------------------------------------------\\
    // port A (64 bits)
    input  logic                    we_from_fifo_to_bias_glb,           // write enable
    input  logic [FIFO_WIDTH - 1:0] wdata_from_fifo_to_bias_glb,        // write data 
    input  logic [ADDR_WIDTH - 1:0] waddr_from_fifo_to_bias_glb,        // write address

    //-------------------------------------------READ------------------------------------------------------\\
    // port B (16 bits)
    input  logic                    re_from_noc_to_bias_glb,            // read enable
    output logic [DATA_WIDTH - 1:0] rdata_from_bias_glb_to_noc,         // read data     
    input  logic [ADDR_WIDTH - 1:0] raddr_from_noc_to_bias_glb,         // read address

    //-------------------------------------------PSUM-----------------------------------------------------\\
    //-------------------------------------------WRITE-----------------------------------------------------\\
    // port A (16 bits)
    // noc
    input  logic                    we_from_noc_to_psum_glb,            // write enable 
    input  logic [DATA_WIDTH - 1:0] wdata_from_noc_to_psum_glb,         // write data   
    input  logic [ADDR_WIDTH - 1:0] waddr_from_noc_to_psum_glb,         // write address

    // lrn
    input  logic                    we_from_lrn_to_psum_glb,            // write enable 
    input  logic [DATA_WIDTH - 1:0] wdata_from_lrn_to_psum_glb,         // write data 
    input  logic [ADDR_WIDTH - 1:0] waddr_from_lrn_to_psum_glb,         // write address

    //-------------------------------------------READ------------------------------------------------------\\
    // port B (16 bits)
    // noc
    input  logic                    re_from_noc_to_psum_glb,            // read enable 
    output logic [DATA_WIDTH - 1:0] rdata_from_psum_glb_to_noc,         // read data
    input  logic [ADDR_WIDTH - 1:0] raddr_from_noc_to_psum_glb,         // read address

    // lrn
    input  logic                    re_from_lrn_to_psum_glb,            // read enable 
    output logic [DATA_WIDTH - 1:0] rdata_from_psum_glb_to_lrn,         // read data
    input  logic [ADDR_WIDTH - 1:0] raddr_from_lrn_to_psum_glb          // read address

);

    //--------------------------------------------IFMAP GLB--------------------------------------------\\
    // port A (64 bits)
    // write port 
    assign we_a_ifmap_glb = we_from_fifo_to_ifmap_glb;           // write enable from fifo to glb
    assign wdata_a_ifmap_glb = wdata_from_fifo_to_ifmap_glb;     // write data from fifo to glb
    assign waddr_a_ifmap_glb = waddr_from_fifo_to_ifmap_glb;     // write address from fifo to glb

    // read port
    assign re_a_ifmap_glb = re_from_fifo_to_ifmap_glb;           // read enable from fifo to glb
    assign rdata_from_ifmap_glb_to_fifo = rdata_a_ifmap_glb;     // read data from glb to fifo
    assign raddr_a_ifmap_glb = raddr_from_fifo_to_ifmap_glb;     // read address from fifo to glb

    // port B (16 bits)
    // write port
    mux3x1_hot_encoded #(.DATA_WIDTH(DATA_WIDTH + 1 + ADDR_WIDTH)) mux0 (
        .sel({padding_enable, lrn_enable, noc_enable}),
        .in0({wdata_from_noc_to_ifmap_glb, we_from_noc_to_ifmap_glb, waddr_from_noc_to_ifmap_glb}),
        .in1({wdata_from_lrn_to_ifmap_glb, we_from_lrn_to_ifmap_glb, waddr_from_lrn_to_ifmap_glb}),
        .in2({wdata_from_pad_to_ifmap_glb, we_from_pad_to_ifmap_glb, waddr_from_pad_to_ifmap_glb}),
        .out({wdata_b_ifmap_glb, we_b_ifmap_glb, waddr_b_ifmap_glb})
    );

    // read port
    assign re_b_ifmap_glb = re_from_noc_to_ifmap_glb;               // read enable from noc to glb
    assign rdata_from_ifmap_glb_to_noc = rdata_b_ifmap_glb;         // read data from noc to glb
    assign raddr_b_ifmap_glb = raddr_from_noc_to_ifmap_glb;         // read address from noc to glb

    //--------------------------------------------FILTER GLB--------------------------------------------\\
    // port A (64 bits)
    // write port
    assign we_a_filter_glb = we_from_fifo_to_filter_glb;            // write enable from fifo to glb
    assign wdata_a_filter_glb = wdata_from_fifo_to_filter_glb;      // write data from fifo to glb   
    assign waddr_a_filter_glb = waddr_from_fifo_to_filter_glb;      // write address from fifo to glb     

    // port B (16 bits) 
    // read port                               
	assign re_b_filter_glb = re_from_noc_to_filter_glb;             // read enable from noc to glb
    assign rdata_from_filter_glb_to_noc = rdata_b_filter_glb;       // read data from glb to noc
    assign raddr_b_filter_glb = raddr_from_noc_to_filter_glb;       // read address from noc to glb
    
    //--------------------------------------------BIAS GLB----------------------------------------------\\
    // port A (64 bits)
    // write port
	assign we_a_bias_glb = we_from_fifo_to_bias_glb;                // write enable from fifo to glb 
    assign wdata_a_bias_glb = wdata_from_fifo_to_bias_glb;          // write data from fifo to glb  
    assign waddr_a_bias_glb = waddr_from_fifo_to_bias_glb;          // write address from fifo to glb  
    
    // port B (16 bits)
    // read port 
	assign re_b_bias_glb = re_from_noc_to_bias_glb;                 // read enable from noc to glb                      
    assign rdata_from_bias_glb_to_noc = rdata_b_bias_glb;           // read data from glb to noc    
    assign raddr_b_bias_glb = raddr_from_noc_to_bias_glb;           // read address from noc to glb   
    
    //--------------------------------------------PSUM GLB----------------------------------------------\\
    // port A (16 bits)
    // write port
    mux2x1_hot_encoded #(.DATA_WIDTH(DATA_WIDTH + 1 + ADDR_WIDTH)) mux1 (
        .sel({lrn_enable, noc_enable}),
        .in0({wdata_from_noc_to_psum_glb, we_from_noc_to_psum_glb, waddr_from_noc_to_psum_glb}),
        .in1({wdata_from_lrn_to_psum_glb, we_from_lrn_to_psum_glb, waddr_from_lrn_to_psum_glb}),
        .out({wdata_a_psum_glb, we_a_psum_glb, waddr_a_psum_glb})
    );

	// port B (16 bits)
    // read port
    mux2x1_hot_encoded #(.DATA_WIDTH(1 + ADDR_WIDTH)) mux2 (
        .sel({lrn_enable, noc_enable}),
        .in0({re_from_noc_to_psum_glb, raddr_from_noc_to_psum_glb}),
        .in1({re_from_lrn_to_psum_glb, raddr_from_lrn_to_psum_glb}),
        .out({re_b_psum_glb, raddr_b_psum_glb})
    );
    
    demux1x2_hot_encoded #(.DATA_WIDTH(DATA_WIDTH)) demux0 (
        .sel({lrn_enable, noc_enable}),
        .in0(rdata_b_psum_glb),
        .out0(rdata_from_psum_glb_to_noc),
        .out1(rdata_from_psum_glb_to_lrn)
    );

endmodule