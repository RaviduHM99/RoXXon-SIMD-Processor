module ProcessingElement ( 
    input logic CLK,
    input logic RST,
    input logic [31:0] A,
    input logic [31:0] B,
    input logic MAC_CTRL,
    output logic [31:0] ACC_DATA
);

wire [31:0] MUL_DATA;

initial begin
    ACC_DATA = 32'd0;
end

assign MUL_DATA = (MAC_CTRL) ? A*B : 'd0;

always_ff @(posedge CLK) begin
    if (RST) ACC_DATA <= 32'd0;
    else ACC_DATA <= (MAC_CTRL) ? ACC_DATA + MUL_DATA : ACC_DATA;
end

endmodule