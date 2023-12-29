`timescale 1ns/1ps

module Instr_Fetch #(
    parameter N = 512
)(
    input logic CLK, RSTN,

    output logic [31:0] INSTR, 
    input logic PC_INCR,
    input logic INSTR_DONE, 

    input logic [31:0] INSTR_AXI,
    output logic [$clog2(N)-1:0] PC_AXI
);
    (*KEEP = "true"*)
(*mark_debug = "true"*)   reg [$clog2(N)-1:0] PC;

    always_ff @(posedge CLK) begin
        if (RSTN) PC <= 'd0;
        else PC <= (PC_INCR) ? PC + 'd1 : PC;
    end

    always_ff @(posedge CLK) begin
        if (RSTN) INSTR <= 32'd0;
        else INSTR <= (INSTR_DONE) ? INSTR_AXI : INSTR;
    end

    assign PC_AXI = PC;

endmodule