module mux2x1 #(
    parameter DATA_WIDTH = 16
)(
    input  logic                   sel,
    input  logic [DATA_WIDTH-1:0]  in0,
    input  logic [DATA_WIDTH-1:0]  in1,
    output logic [DATA_WIDTH-1:0]  out
);

    always_comb begin
        case (sel)
            1'b0:    out = in0;    
            1'b1:    out = in1;    
            default: out = {DATA_WIDTH{1'b0}};
        endcase
    end

endmodule