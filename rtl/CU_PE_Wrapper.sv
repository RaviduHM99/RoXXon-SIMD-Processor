`timescale 1ns/1ps

module CU_PE_Wrapper (
    input logic CLK, RSTN,

    input logic [31:0] INSTR, // INST FETCH
    output logic PC_INCR,
    output logic INSTR_DONE, 

    //output logic [1:0] DIMEN, // DATA FETCH LOAD
    output logic ADDR_START,
    output logic ADDR_RST,
    output logic [3:0] ADDRESS,
    input logic FETCH_DONE,
    output logic [1:0] PE_SEL,
    output logic PE_SEL_2x2,
    output logic PE_SEL_4,

    output logic WRADDR_START, // DATA FETCH STORE
    input logic STORE_DONE,

    input logic START_SIGNAL, //GPIO
    output logic STOP_SIGNAL,

    input logic [3:0][31:0] DATAIN,
    output logic [3:0][31:0] DATAOUT
);
    wire [3:0] RST_ADD; // PE
    wire [3:0] MAC_CTRL;
    wire [3:0] RST_ACC;
    wire [3:0] RST_PC;
    wire [3:0] MAT_MUX;
    wire [3:0] WRITE_MAT;
    wire [3:0] OUT_READY;
    wire [1:0] DIMEN;

    logic [3:0] MAC_DONE_PE; //AND All MAC DONE in top module
    logic MAC_DONE;

    localparam N = 16;

    assign MAC_DONE = MAC_DONE_PE[0] & MAC_DONE_PE[1] & MAC_DONE_PE[2] & MAC_DONE_PE[3];

    Control_Unit CU (.*);

    Processing_Element #(.N(N)) PE0 (
        .CLK(CLK),
        .RST_ADD(RST_ADD[0]),
        .DATAIN(DATAIN[0]),
        .MAC_CTRL(MAC_CTRL[0]),
        .RST_ACC(RST_ACC[0]),
        .RST_PC(RST_PC[0]),
        .MAT_MUX(MAT_MUX[0]),
        .WRITE_MAT(WRITE_MAT[0]),
        .DIMEN(DIMEN),
        .OUT_READY(OUT_READY[0]),
        .MAC_DONE(MAC_DONE_PE[0]),
        .DATAOUT(DATAOUT[0])
        );

    Processing_Element #(.N(N)) PE1 (
        .CLK(CLK),
        .RST_ADD(RST_ADD[1]),
        .DATAIN(DATAIN[1]),
        .MAC_CTRL(MAC_CTRL[1]),
        .RST_ACC(RST_ACC[1]),
        .RST_PC(RST_PC[1]),
        .MAT_MUX(MAT_MUX[1]),
        .WRITE_MAT(WRITE_MAT[1]),
        .DIMEN(DIMEN),
        .OUT_READY(OUT_READY[1]),
        .MAC_DONE(MAC_DONE_PE[1]),
        .DATAOUT(DATAOUT[1])
        );

    Processing_Element #(.N(N)) PE2 (
        .CLK(CLK),
        .RST_ADD(RST_ADD[2]),
        .DATAIN(DATAIN[2]),
        .MAC_CTRL(MAC_CTRL[2]),
        .RST_ACC(RST_ACC[2]),
        .RST_PC(RST_PC[2]),
        .MAT_MUX(MAT_MUX[2]),
        .WRITE_MAT(WRITE_MAT[2]),
        .DIMEN(DIMEN),
        .OUT_READY(OUT_READY[2]),
        .MAC_DONE(MAC_DONE_PE[2]),
        .DATAOUT(DATAOUT[2])
        );

    Processing_Element #(.N(N)) PE3 (
        .CLK(CLK),
        .RST_ADD(RST_ADD[3]),
        .DATAIN(DATAIN[3]),
        .MAC_CTRL(MAC_CTRL[3]),
        .RST_ACC(RST_ACC[3]),
        .RST_PC(RST_PC[3]),
        .MAT_MUX(MAT_MUX[3]),
        .WRITE_MAT(WRITE_MAT[3]),
        .DIMEN(DIMEN),
        .OUT_READY(OUT_READY[3]),
        .MAC_DONE(MAC_DONE_PE[3]),
        .DATAOUT(DATAOUT[3])
        );


    
endmodule