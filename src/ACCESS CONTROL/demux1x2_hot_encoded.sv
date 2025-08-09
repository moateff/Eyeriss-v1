module demux1x2_hot_encoded #(
    parameter DATA_WIDTH = 16
)(
    input  logic [1:0] sel,                   
    input  logic [DATA_WIDTH-1:0] in0,       
    output logic [DATA_WIDTH-1:0] out0,   
    output logic [DATA_WIDTH-1:0] out1  
);

    always_comb begin
        out0 = '0;
        out1 = '0;

        case (sel)
            2'b01: out0 = in0;  
            2'b10: out1 = in0; 
            default: begin
                out0 = {DATA_WIDTH{1'b0}};
                out1 = {DATA_WIDTH{1'b0}};
            end
        endcase
    end

endmodule
