`timescale 1ns/1ps

module Fetch_Unit #(
    parameter N = 16, REGN = 512,
              ADDR = 32'h00000000 //Register Address
)(
    input logic CLK, RSTN,
    input logic [31:0] INSTRDATA,
    input logic [N-1:0][31:0] MAT_IN,
    input logic DONE,
    input logic DOUT_MUX,

    output logic [$clog2(REGN/2)-1:0] PC_INS,
    output logic [31:0] INSTR,
    output logic [N-1:0][31:0] RESULT,
    input logic [N-1:0][31:0] DATAOUT,

    output logic [N-1:0][N-1:0][31:0] MAT_OUT
);
    logic [$clog2(REGN/2)-1:0] PC_REG_INS;

    always_ff @(posedge CLK) begin
        if (RSTN)
            PC_REG_INS <= 8'd0;
        else
            PC_REG_INS <= (DONE) ? (PC_REG_INS + 8'd1) : PC_REG_INS;
    end

    always_ff @(posedge CLK) begin
        MAT_OUT <= {N{MAT_IN}}; 
    end

    assign INSTR = INSTRDATA;
    assign PC_INS = PC_REG_INS;
    assign RESULT = (DOUT_MUX) ? DATAOUT : 'dz;

endmodule