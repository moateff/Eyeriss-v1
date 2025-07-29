module RST_SYNC 
(
	input wire  clk, reset,
	output wire SYNC_RST
);

	reg sync;
	
	always @(negedge clk, posedge reset)
	begin
		if (reset)
		begin
			sync <= 'b0;
		end
		
		else
		begin
			sync <= {sync,1'b1};
		end
	end
	
	assign SYNC_RST = !sync;
	
endmodule 