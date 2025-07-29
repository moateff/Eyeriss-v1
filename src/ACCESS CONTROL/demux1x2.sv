module demux1x2 #(
    parameter DATA_WIDTH = 16
)(
    input  logic sel,   
    input  logic [DATA_WIDTH-1:0] in,   
    output logic [DATA_WIDTH-1:0] out0,
    output logic [DATA_WIDTH-1:0] out1  
);

    always_comb begin
        out0 = {DATA_WIDTH{1'b0}};
        out1 = {DATA_WIDTH{1'b0}};
        if (sel == 1'b0) begin
            out0 = in;
        end else begin
            out1 = in;
        end
    end

endmodule
