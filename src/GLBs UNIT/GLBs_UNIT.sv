(*keep_hierarchy = "yes"*)
module GLBs_UNIT #(parameter FIFO_WIDTH = 64, DATA_WIDTH = 16,
			  parameter DEPTH_ifmap = 64896, ADDR_ifmap = $clog2(DEPTH_ifmap),
			  parameter DEPTH_filter = 884736, ADDR_filter = $clog2(DEPTH_filter),
			  parameter DEPTH_psum = 193600, ADDR_psum = $clog2(DEPTH_psum),
			  parameter DEPTH_bias = 384, ADDR_bias = $clog2(DEPTH_bias))
(
	input wire core_clk,
	
	/******************************************IFMAP***********************************************/
	
	// port A 
	input wire [FIFO_WIDTH-1:0] wdata_a_ifmap,                                        
	input wire we_a_ifmap,                                     
	input wire re_a_ifmap,                                    
	input wire [ADDR_ifmap-1:0] addr_a_ifmap,                        
	output wire [FIFO_WIDTH-1:0] rdata_a_ifmap, 
	
	// port B
 	input wire [DATA_WIDTH-1:0] wdata_b_ifmap,                  
	input wire we_b_ifmap,                                      
	input wire re_b_ifmap,                                      
	input wire [ADDR_ifmap-1:0] addr_b_ifmap,                       
	output wire [DATA_WIDTH-1:0] rdata_b_ifmap,                                          
	
	
	/******************************************FILTER***********************************************/
	
	
	input wire [FIFO_WIDTH-1:0] wdata_f,                                        
	input wire we_f,
	input wire re_f,
	input wire [ADDR_filter-1:0] raddr_f,
	input wire [ADDR_filter-1:0] waddr_f,
	output wire [DATA_WIDTH-1:0] rdata_f,
	
	/******************************************PSUM***********************************************/
	
	
	// port A 
	input wire [DATA_WIDTH-1:0] wdata_a_psum,                            
	input wire we_a_psum,                                    
	input wire [ADDR_psum-1:0] addr_a_psum,           
	
	// port B
	input wire re_b_psum,                                     
	input wire [ADDR_psum-1:0] addr_b_psum,            
	output wire [DATA_WIDTH-1:0] rdata_b_psum,
	

	/******************************************BIAS***********************************************/
	
	input wire we_bias,
	input wire re_bias,
 	input wire [ADDR_bias-1:0] raddr_bias,
	input wire [ADDR_bias-1:0] waddr_bias,                   
	input wire [FIFO_WIDTH-1:0] wdata_bias,             
	output wire [DATA_WIDTH-1:0] rdata_bias
);



	
	/**************************************************************************************************************************/
   /*****************************************************IFMAP****************************************************************/
  /**************************************************************************************************************************/
  
	ifmap_GLB #(.FIFO_WIDTH(FIFO_WIDTH), .DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH_ifmap), .ADDR(ADDR_ifmap)) U1_IFMAP
	(
    .core_clk(core_clk),
	
	// port A 
	.wdata_a(wdata_a_ifmap),                                       
	.we_a(we_a_ifmap),                                      
	.re_a(re_a_ifmap),                                      
	.addr_a(addr_a_ifmap),                         
	.rdata_a(rdata_a_ifmap), 
	
	// port B
 	.wdata_b(wdata_b_ifmap),                         
	.we_b(we_b_ifmap),                                      
	.re_b(re_b_ifmap),                                     
	.addr_b(addr_b_ifmap),
	.rdata_b(rdata_b_ifmap)
	); 
  
	
	
	/**************************************************************************************************************************/
   /*****************************************************FILTER***************************************************************/
  /**************************************************************************************************************************/


	filter_GLB #(.FIFO_WIDTH(FIFO_WIDTH), .DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH_filter), .ADDR(ADDR_filter)) U2_FILTER
	
	(
	.core_clk(core_clk),
	.wdata(wdata_f),                                        
	.we(we_f),
	.re(re_f),
	.raddr(raddr_f),
	.waddr(waddr_f),
	.rdata(rdata_f)
	); 
	
        /**************************************************************************************************************************/
       /*****************************************************BIAS*****************************************************************/
      /**************************************************************************************************************************/
    
    
    bias_GLB #(.FIFO_WIDTH(FIFO_WIDTH), .DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH_bias), .ADDR(ADDR_bias)) U3_BIAS
    
    (
    .core_clk(core_clk),
    .wdata(wdata_bias),                                        
    .we(we_bias),
    .re(re_bias),
    .raddr(raddr_bias),
    .waddr(waddr_bias),
    .rdata(rdata_bias)
    ); 
        
	/**************************************************************************************************************************/
   /*****************************************************PSUM*****************************************************************/
  /**************************************************************************************************************************/	
	
	
	psum_GLB #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH_psum), .ADDR(ADDR_psum)) U4_PSUM
	(
    .core_clk(core_clk),
	
	// port A 
	.wdata_a(wdata_a_psum),                      
	.we_a(we_a_psum),                                   
	.addr_a(addr_a_psum),
	
	// port B
	.re_b(re_b_psum),                                     
	.addr_b(addr_b_psum),             
	.rdata_b(rdata_b_psum)
	); 
  
endmodule
