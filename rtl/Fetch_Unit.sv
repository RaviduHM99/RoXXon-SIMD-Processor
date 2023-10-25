`timescale 1ns/1ps

module Fetch_Unit #(
    parameter N = 2, REGN = 512,
              ADDR = 32'h00000000 //Register Address
)(
    input logic CLK, RSTN,
    input logic [31:0] INSTRDATA,
    input logic [N-1:0][31:0] MAT_IN,
    input logic DONE,
    input logic DOUT_MUX,
    input logic INS_MUX,
    input logic MATD_MUX,

    output logic [$clog2(REGN) - 1:0] PC,
    output logic [N-1:0][31:0] MAT_OUT,
    output logic [31:0] INSTR,
    output logic [31:0] RESULT,
    input logic [31:0] DATAOUT
);
    reg [$clog2(REGN)-1:0] PC_REG;
    
    assign INSTR = (INS_MUX) ? INSTRDATA : 'dz;
    assign MAT_OUT = (MATD_MUX) ? MAT_IN : 'dz;
    assign PC = PC_REG;
    assign RESULT = (DOUT_MUX) ? DATAOUT : 'dz;

    always_ff @(posedge CLK) begin
        if (RSTN) PC_REG <= ADDR;
        else PC_REG <= (DONE) ? PC_REG + 'b1 : PC_REG;
    end

endmodule