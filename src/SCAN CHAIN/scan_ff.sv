module scan_ff(
    input  wire clk,      // Clock
    input  wire reset,    // Asynchronous active-high reset
    input  wire se,       // Scan enable
    input  wire si,       // Scan input
    output wire q,        // Output when scan disabled
    output wire so        // Output when scan enabled
);

    reg Dout;

    // Sequential logic with asynchronous reset
    always @(negedge clk or posedge reset) begin
        if (reset)
            Dout <= 1'b0;
        else if (se)
            Dout <= si;
    end

    // Output logic
    and and_gate (q,~se,Dout);
    assign so = Dout;

endmodule
