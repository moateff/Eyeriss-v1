(* keep_hierarchy = "yes" *)
module GLBs_UNIT #(parameter FIFO_WIDTH = 64, DATA_WIDTH = 16,
			  parameter DEPTH_ifmap = 64896, ADDR_ifmap = $clog2(DEPTH_ifmap),
			  parameter DEPTH_filter = 884736, ADDR_filter = $clog2(DEPTH_filter),
			  parameter DEPTH_psum = 193600, ADDR_psum = $clog2(DEPTH_psum),
			  parameter DEPTH_bias = 384, ADDR_bias = $clog2(DEPTH_bias))
(
	input wire clk,
	
	/******************************************IFMAP***********************************************/
	
	// port A                                         
	input  wire we_a_ifmap,                                     
	input  wire [ADDR_ifmap-1:0] addr_a_ifmap,
	input  wire [FIFO_WIDTH-1:0] wdata_a_ifmap,                        
	
	// port B
	input  wire re_b_ifmap,                                      
	input  wire [ADDR_ifmap-1:0] addr_b_ifmap,                       
	output wire [DATA_WIDTH-1:0] rdata_b_ifmap,                                          
	
	
	/******************************************FILTER***********************************************/
	
	// port A                                         
    input  wire we_a_filter,                                     
    input  wire [ADDR_filter-1:0] addr_a_filter,
    input  wire [FIFO_WIDTH-1:0]  wdata_a_filter,                        
    
    // port B
    input  wire re_b_filter,                                      
    input  wire [ADDR_filter-1:0] addr_b_filter,                       
    output wire [DATA_WIDTH-1:0]  rdata_b_filter, 
	
	
    /******************************************BIAS***********************************************/
    
    // port A                                         
    input  wire we_a_bias,                                     
    input  wire [ADDR_bias-1:0]  addr_a_bias,
    input  wire [FIFO_WIDTH-1:0] wdata_a_bias,                        
    
    // port B
    input  wire re_b_bias,                                      
    input  wire [ADDR_bias-1:0]  addr_b_bias,                       
    output wire [DATA_WIDTH-1:0] rdata_b_bias,
    
    
	/******************************************PSUM***********************************************/
	
	// port A 
	input  wire we_a_psum,                                   
	input  wire re_a_psum,                                   
	input  wire [ADDR_psum-1:0]  addr_a_psum,
    input  wire [DATA_WIDTH-1:0] wdata_a_psum,                                       
    output wire [FIFO_WIDTH-1:0] rdata_a_psum,                                       
	
	// port B
	input  wire re_b_psum,                                     
	input  wire [ADDR_psum-1:0]  addr_b_psum,            
	output wire [DATA_WIDTH-1:0] rdata_b_psum
);



	
	/**************************************************************************************************************************/
   /*****************************************************IFMAP****************************************************************/
  /**************************************************************************************************************************/
  
	ifmap_GLB #(.FIFO_WIDTH(FIFO_WIDTH), .DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH_ifmap), .ADDR(ADDR_ifmap)) U1_IFMAP
	(
    .clk(clk),
	
	// port A                                        
	.we_a(we_a_ifmap),                                      
	.re_a(1'b0),                                      
	.addr_a(addr_a_ifmap),
	.wdata_a(wdata_a_ifmap),                         
	.rdata_a(), 
	
	// port B                         
	.we_b(1'b0),                                      
	.re_b(re_b_ifmap),                                     
	.addr_b(addr_b_ifmap),
	.wdata_b(16'b0),
	.rdata_b(rdata_b_ifmap)
	); 
  
	
	
	/**************************************************************************************************************************/
   /*****************************************************FILTER***************************************************************/
  /**************************************************************************************************************************/


	filter_GLB #(.FIFO_WIDTH(FIFO_WIDTH), .DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH_filter), .ADDR(ADDR_filter)) U2_FILTER
	
	(
    .clk(clk),
    
    // port A                                        
    .we_a(we_a_filter),                                      
    .re_a(1'b0),                                      
    .addr_a(addr_a_filter),
    .wdata_a(wdata_a_filter),                         
    .rdata_a(), 
    
    // port B                         
    .we_b(1'b0),                                      
    .re_b(re_b_filter),                                     
    .addr_b(addr_b_filter),
    .wdata_b(16'b0),
    .rdata_b(rdata_b_filter)
	); 
	
        /**************************************************************************************************************************/
       /*****************************************************BIAS*****************************************************************/
      /**************************************************************************************************************************/
    
    
    bias_GLB #(.FIFO_WIDTH(FIFO_WIDTH), .DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH_bias), .ADDR(ADDR_bias)) U3_BIAS
    
    (
    .clk(clk),
    
    // port A                                        
    .we_a(we_a_bias),                                      
    .re_a(1'b0),                                      
    .addr_a(addr_a_bias),
    .wdata_a(wdata_a_bias),                         
    .rdata_a(), 
    
    // port B                         
    .we_b(1'b0),                                      
    .re_b(re_b_bias),                                     
    .addr_b(addr_b_bias),
    .wdata_b(16'b0),
    .rdata_b(rdata_b_bias)
    ); 
        
	/**************************************************************************************************************************/
   /*****************************************************PSUM*****************************************************************/
  /**************************************************************************************************************************/	
	
	
	psum_GLB #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH_psum), .ADDR(ADDR_psum)) U4_PSUM
	(
    .clk(clk),
    
    // port A                                        
    .we_a(we_a_psum),                                      
    .re_a(re_a_psum),                                      
    .addr_a(addr_a_psum),
    .wdata_a(wdata_a_psum),                         
    .rdata_a(rdata_a_psum), 
    
    // port B                         
    .we_b(1'b0),                                      
    .re_b(re_b_psum),                                     
    .addr_b(addr_b_psum),
    .wdata_b(16'b0),
    .rdata_b(rdata_b_psum)
	); 
  
endmodule
