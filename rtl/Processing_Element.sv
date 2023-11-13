`timescale 1ns/1ps

module Processing_Element #(
    parameter N = 16
)
(
    input logic CLK,
    input logic RSTN,

    inout logic MAT_DATA,
    input logic [1:0] INOUT_MUX,
    input logic [3:0] INDATA_MUX,
    input logic [3:0] OUTDATA_MUX,
    input logic WRTIE_EN,

    input logic ALUREG_MUX,
    input logic ALUACC_MUX,
    input logic OUTDATA_MUX,
    output logic DONE_OPS
);

    reg [31:0] REG_A [N-1:0];
    reg [31:0] REG_B [N-1:0];
    reg [31:0] REG_C [N-1:0];

    logic [31:0] REG_A_wire;
    logic [31:0] REG_B_wire;
    logic [31:0] REG_C_wire;
    logic [31:0] ALU_IN_wire;

    always_comb begin
        unique case (INOUT_MUX)
            2'd0 : REG_A_wire = MAT_DATA;
            2'd1 : REG_B_wire = MAT_DATA;
            2'd2 : REG_C_wire = MAT_DATA;
            default : REG_A_wire = MAT_DATA;
        endcase
    end

    assign REG_C_wire = REG_C[OUTDATA_MUX];
    assign REG_A[INOUT_MUX] = REG_A_wire;
    assign REG_B[INOUT_MUX] = REG_B_wire;

    assign ALU_IN_wire = (ALUACC_MUX) ? // add counter

    always @(posedge CLK) begin
        if (RSTN) begin
            
        end
        else begin
            
        end
    end

    
endmodule