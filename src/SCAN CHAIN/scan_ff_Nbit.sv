module scan_ff_Nbit #(parameter N = 4)(
    input  wire clk,                // Clock
    input  wire reset,              // Asynchronous active-high reset
    input  wire se,                 // Scan enable
    input  wire si,                 // Scan input
    output wire [N-1 : 0] q,        // Output when scan disabled
    output wire so                  // Output when scan enabled
);
    
    wire [N : 0] soi;
    assign soi[N] = si;
    assign so = soi[0];
        
    genvar i;
    generate
    for (i = N-1 ; i >= 0 ; i--) begin : SCAN_CHAIN
        scan_ff scan_ff_inst (
            .clk(clk),          // Connect clock
            .reset(reset),      // Connect async reset
            .se(se),            // Scan enable
            .si(soi[i+1]),      // Scan input
            .q(q[i]),           // Functional mode output
            .so(soi[i])         // Scan output
        );
    end
    endgenerate
    
   
endmodule
