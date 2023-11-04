module ProcessingElement ( 
    input logic CLK,
    input logic RST,
    input logic [7:0][31:0]data,
    input logic  A,
    input logic  B,
    input logic CTRL,
    output logic [1:0][31:0] ACC_DATA 
);

reg [7:0][31:0] MUL_DATA;
logic [1:0][31:0] INT1 ;
logic [1:0][31:0] INT2 ;

always_ff @(posedge CLK) begin
    if (RST) MUL_DATA <= {8{32'd0}};
    else MUL_DATA <=  data;
end

always_comb begin
    unique case (A)
        1'd0: INT1 = MUL_DATA[1:0];
        1'd1: INT1 = MUL_DATA[3:2];
    endcase

    unique case (B)
        1'd0: INT2 = MUL_DATA[5:4];
        1'd1: INT2 = MUL_DATA[7:6];
    endcase
end 

assign ACC_DATA = (CTRL) ? INT1 : INT2; 
endmodule