module psum_GLB #(parameter FIFO_WIDTH = 64, DATA_WIDTH = 16, DEPTH = 193600, ADDR = $clog2(DEPTH))
(
    input wire core_clk,
	input wire [DATA_WIDTH-1:0] wdata_a,                                      
	input wire we_a,
	input wire re_b,
	input wire [ADDR-1:0] addr_a,
	input wire [ADDR-1:0] addr_b,
	output reg [DATA_WIDTH-1:0] rdata_b
); 
 
    wire [ADDR-1:0] addr_b_r;
	wire [DATA_WIDTH-1:0] rdata_b00,rdata_b01,rdata_b10,rdata_b11;
	
	flop #(.DATA_WIDTH(ADDR)) dff (
        .clk(core_clk),
        .d(addr_b),
        .q(addr_b_r)
    );
        
	always @(*)
	begin
		case (addr_b_r[1:0])
			2'b00:
			begin
				rdata_b = rdata_b00;
			end
			2'b01:
			begin
				rdata_b = rdata_b01;
			end
			2'b10:
			begin
				rdata_b = rdata_b10;
			end
			2'b11:
			begin
				rdata_b = rdata_b11;
			end
		endcase
	end



	single_RAM  #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH/4)) U0_0
	(
    .core_clk(core_clk),
	.we(we_a & (~addr_a[1]) & (~addr_a[0])),
	.re(re_b & (~addr_b[1]) & (~addr_b[0])),                
	.waddr(addr_a[ADDR-1:2]), 
	.raddr(addr_b[ADDR-1:2]), 
    .wdata(wdata_a),                                                   
	.rdata(rdata_b00)
	); 
	
	
	single_RAM  #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH/4)) U0_1
	(
    .core_clk(core_clk),
	.we(we_a & (~addr_a[1]) & (addr_a[0])),
	.re(re_b & (~addr_b[1]) & (addr_b[0])),                
	.waddr(addr_a[ADDR-1:2]), 
	.raddr(addr_b[ADDR-1:2]), 
    .wdata(wdata_a),                                                   
	.rdata(rdata_b01)
	); 
	
	
	single_RAM  #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH/4)) U1_0
	(
    .core_clk(core_clk),
	.we(we_a & (addr_a[1]) & (~addr_a[0])),
	.re(re_b & (addr_b[1]) & (~addr_b[0])),                
	.waddr(addr_a[ADDR-1:2]), 
	.raddr(addr_b[ADDR-1:2]), 
    .wdata(wdata_a),                                                   
	.rdata(rdata_b10)
	); 
	
	single_RAM  #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH/4)) U1_1
	(
    .core_clk(core_clk),
	.we(we_a & (addr_a[1]) & (addr_a[0])),
	.re(re_b & (addr_b[1]) & (addr_b[0])),                
	.waddr(addr_a[ADDR-1:2]), 
	.raddr(addr_b[ADDR-1:2]), 
    .wdata(wdata_a),                                                   
	.rdata(rdata_b11)
	); 
	
endmodule
