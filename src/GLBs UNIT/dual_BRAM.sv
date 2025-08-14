module dual_BRAM #(parameter DATA_WIDTH = 16, DEPTH = 4, ADDR = $clog2(DEPTH))
(
    input wire clk,
		
	//port A
	
	input wire we_a,
	input wire re_a,
	input wire [ADDR-1:0] addr_a,
	input wire [DATA_WIDTH-1:0] wdata_a,
	output reg [DATA_WIDTH-1:0] rdata_a,
	
    //port B
	
	input wire we_b,
	input wire re_b,
	input wire [ADDR-1:0] addr_b,
	input wire [DATA_WIDTH-1:0] wdata_b,
	output reg [DATA_WIDTH-1:0] rdata_b

); 


	(* ram_style = "block" *) reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
	
	// PORT A
	
	always @(negedge clk)
	begin
			if (we_a)
				mem[addr_a] <= wdata_a;
				
			if (re_a)
				rdata_a <= mem[addr_a];
	end
	
	// PORT B
	
	always @(negedge clk)
	begin
			if (we_b)
				mem[addr_b] <= wdata_b;
			
			if (re_b)
				rdata_b <= mem[addr_b];	
	end
	
	
endmodule
