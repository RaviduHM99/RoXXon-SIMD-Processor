`timescale 1ns/1ps

module Fetch_Unit #(
    parameter N = 16, REGN = 512,
              ADDR = 32'h00000000 //Register Address
)(
    input logic CLK, RSTN,
    input logic [31:0] INSTRDATA,
    input logic [N-1:0][31:0] MAT_IN,
    input logic MATAB_MUX,
    input logic DONE,
    input logic DOUT_MUX,

    output logic [$clog2(REGN/2) - 1:0] PC_INS,
    output logic [31:0] INSTR,
    output logic [31:0] RESULT,
    input logic [31:0] DATAOUT,

    input logic DONE_DATAB,
    input logic [$clog2(N)-1:0] SEQ_B,
    output logic [N-1:0][N-1:0][31:0] MAT_OUT
);
    reg [$clog2(REGN/2)-1:0] PC_REG_INS;
    
    assign INSTR = INSTRDATA;
    assign PC_INS = PC_REG_INS;
    assign RESULT = (DOUT_MUX) ? DATAOUT : 'dz;

    always_ff @(posedge CLK) begin
        if (RSTN) PC_REG_INS <= ADDR;
        else PC_REG_INS <= (DONE) ? PC_REG_INS + 'd1 : PC_REG_INS;
    end

    /*reg [$clog2(N)-1:0] PC_REG_DATA;
    always_ff @(posedge CLK) begin
        if (RSTN) PC_REG_DATA <= 'd0;
        else PC_REG_DATA <= (DONE_DATAB) ? PC_REG_DATA + 'b1 : PC_REG_DATA;
    end*/

    always_ff @(posedge CLK) begin
        if (MATAB_MUX) MAT_OUT <= {N{MAT_IN}}; //MATAB_MUX=1 then MAT_A
        else begin
            MAT_OUT[SEQ_B] <= MAT_IN; //MATAB_MUX=0 then MAT_B
        end
    end

    //assign SEQ_B = PC_REG_DATA;
endmodule