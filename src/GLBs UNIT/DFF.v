`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/01/2025 11:30:57 PM
// Design Name: 
// Module Name: D_FF
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module flop
#(
    parameter DATA_WIDTH = 16
)(
    input                       clk,
    input      [DATA_WIDTH-1:0] d, 
    output reg [DATA_WIDTH-1:0] q
);

    always @(negedge clk) begin      
        q <= d;
    end

endmodule

