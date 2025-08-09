module mux2x1_hot_encoded #(
    parameter DATA_WIDTH = 16
)(
    input  logic [1:0]             sel,
    input  logic [DATA_WIDTH-1:0]  in0,
    input  logic [DATA_WIDTH-1:0]  in1,
    output logic [DATA_WIDTH-1:0]  out
);

    always_comb begin
        case (sel)
            2'b01:   out = in0;    
            2'b10:   out = in1;    
            default: out = {DATA_WIDTH{1'b0}};
        endcase
    end

endmodule
