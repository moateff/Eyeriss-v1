module filter_GLB #(parameter FIFO_WIDTH = 64, DATA_WIDTH = 16, DEPTH = 884736, ADDR = $clog2(DEPTH))
(
    input wire core_clk,
	input wire [FIFO_WIDTH-1:0] wdata,                                         
	input wire we,
	input wire re,
	input wire [ADDR-1:0] raddr,
	input wire [ADDR-1:0] waddr,
	output reg [DATA_WIDTH-1:0] rdata
); 
 
    wire [ADDR-1:0] raddr_r;
	wire [DATA_WIDTH-1:0] rdata00,rdata01,rdata10,rdata11;
	
	flop #(.DATA_WIDTH(ADDR)) dff (
        .clk(core_clk),
        .d(raddr),
        .q(raddr_r)
    );
        
	always @(*)
	begin
		case (raddr_r[1:0])
			2'b00:
			begin
				rdata = rdata00;
			end
			2'b01:
			begin
				rdata = rdata01;
			end
			2'b10:
			begin
				rdata = rdata10;
			end
			2'b11:
			begin
				rdata = rdata11;
			end
		endcase
	end



	single_RAM  #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH/4)) U0_0
	(
    .core_clk(core_clk),
	.we(we),
	.re(re & (~raddr[1]) & (~raddr[0])),                
	.waddr(waddr[ADDR-1:2]), 
	.raddr(raddr[ADDR-1:2]), 
    .wdata(wdata[15:0]),                                                   
	.rdata(rdata00)
	); 
	
	
	single_RAM  #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH/4)) U0_1
	(
    .core_clk(core_clk),
	.we(we),
	.re(re & (~raddr[1]) & (raddr[0])),                
	.waddr(waddr[ADDR-1:2]), 
	.raddr(raddr[ADDR-1:2]), 
    .wdata(wdata[31:16]),                                                   
	.rdata(rdata01)
	); 
	
	
	single_RAM  #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH/4)) U1_0
	(
    .core_clk(core_clk),
	.we(we),
	.re(re & (raddr[1]) & (~raddr[0])),                
	.waddr(waddr[ADDR-1:2]), 
	.raddr(raddr[ADDR-1:2]), 
    .wdata(wdata[47:32]),                                                   
	.rdata(rdata10)
	); 
	
	single_RAM  #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH/4)) U1_1
	(
    .core_clk(core_clk),
	.we(we),
	.re(re & (raddr[1]) & (raddr[0])),                
	.waddr(waddr[ADDR-1:2]), 
	.raddr(raddr[ADDR-1:2]), 
    .wdata(wdata[63:48]),                                                   
	.rdata(rdata11)
	); 
	
endmodule
