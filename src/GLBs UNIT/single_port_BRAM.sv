module single_RAM #(parameter DATA_WIDTH = 16, DEPTH = 4, ADDR = $clog2(DEPTH))
(
    input wire core_clk,
	input wire we,
	input wire re,
	input wire [ADDR-1:0] raddr,
	input wire [ADDR-1:0] waddr,
	input wire [DATA_WIDTH-1:0] wdata,
	output reg [DATA_WIDTH-1:0] rdata

); 


	(* ram_style = "block" *) reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
	
	always @(negedge core_clk)
	begin
			if (we)
				mem[waddr] <= wdata;
				
			if (re)
				rdata <= mem[raddr];
	end	
	
endmodule
