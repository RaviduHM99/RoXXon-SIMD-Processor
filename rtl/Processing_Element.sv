`timescale 1ns/1ps

module Processing_Element #(
    parameter N = 16
)
(
    input logic CLK,
    input logic RSTN,

    input logic [N-1:0][31:0] DATAIN,
    input logic MAC_CTRL,
    input logic RST_MUL,
    input logic INC_PC,
    input logic MAT_MUX,
    input logic WRITE_MAT,

    output logic [$clog2(N)-1:0] PC_Counter,
    output logic [31:0] DATAOUT
);
    reg [N-1:0][31:0] MATA;
    reg [N-1:0][31:0] MATB;
    reg [31:0] ACC_DATA;
    reg [$clog2(N)-1:0] PC;

    initial begin
        PC <= 'd0;
        MATA <= 'd0;
        MATB <= 'd0;
    end

    always @(posedge CLK) begin
        if (RST_MUL) PC <= 'b0;
        else PC <= (INC_PC == 1) ? PC + 'b1 : PC;
    end

    always @(posedge CLK) begin
        if (RSTN) begin
            MATA <= 'd0;
            MATB <= 'd0;
        end
        else begin
            if (WRITE_MAT) begin
                MATA <= (MAT_MUX) ? DATAIN : MATA;
                MATB <= (MAT_MUX) ? MATB : DATAIN;
            end
            else begin
                MATA <= MATA;
                MATB <= MATB;
            end

        end
    end

    ///// MAC Module /////
    wire [31:0] MUL_DATA;

    assign MUL_DATA = (MAC_CTRL) ? MATA[PC]*MATB[PC] : 'd0;

    always_ff @(posedge CLK) begin
        if (RST_MUL) ACC_DATA <= 32'd0;
        else ACC_DATA <= (MAC_CTRL) ? ACC_DATA + MUL_DATA : ACC_DATA;
    end
    
    assign DATAOUT = ACC_DATA;
    assign PC_Counter = PC;
    
endmodule