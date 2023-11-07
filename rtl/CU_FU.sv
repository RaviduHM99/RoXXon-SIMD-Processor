`timescale 1ns/1ps

module CU_FU #(
    parameter N = 16, REGN = 512, LogN = $clog2(N), ADDR = 32'h00000000
)
(
    input logic CLK, RSTN,

    //16 PEs
    output logic [N-1:0] MAC_CTRL, RST_MUL, INC_PC, MAT_MUX, WRITE_MAT, 
    input logic [LogN-1:0] PC_Counter,

    //REGFILE_AB
    output logic MATAB_MUX, 
    output logic [LogN-1:0] SEQ_A,
    output logic [LogN-1:0] SEQ_B,

    //REGFILE_CR
    output logic [LogN-1:0] SEQ_DATC, 

    //AXI GPIO
    input logic ONSWT, 
    output logic OFFSWT,

    //Fetch Unit
    input logic [31:0] INSTRDATA,
    input logic [N-1:0][31:0] MAT_IN,

    output logic [$clog2(REGN/2)-1:0] PC_INS,
    output logic [N-1:0][31:0] RESULT,
    input logic [N-1:0][31:0] DATAOUT,

    output logic [N-1:0][N-1:0][31:0] MAT_OUT
);

    wire DONE, DOUT_MUX;
    wire [31:0] INSTR;

    Control_Unit #(.N(N), .REGN(REGN), .LogN(LogN)) dut_cu (.*);

    Fetch_Unit #(.N(N), .REGN(REGN), .ADDR(ADDR)) dut_fu (.*);
    
endmodule