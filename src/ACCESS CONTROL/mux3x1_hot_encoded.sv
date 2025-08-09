module mux3x1_hot_encoded #(
    parameter DATA_WIDTH = 16
)(
    input  logic [2:0]              sel,
    input  logic [DATA_WIDTH-1:0]   in0,
    input  logic [DATA_WIDTH-1:0]   in1,
    input  logic [DATA_WIDTH-1:0]   in2,
    output logic [DATA_WIDTH-1:0]   out
);

    always_comb begin
        case (sel)
            3'b001:  out = in0; 
            3'b010:  out = in1; 
            3'b100:  out = in2;
            default: out = {DATA_WIDTH{1'b0}};
        endcase
    end

endmodule
