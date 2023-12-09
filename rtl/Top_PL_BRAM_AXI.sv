`timescale 1ns/1ps

module Top_PL_BRAM_AXI #(
    parameter N = 512
)(
    input logic CLK, RSTN,
    
    input logic START_SIGNAL, //GPIO
    output logic STOP_SIGNAL
);

    wire [31:0] addrb; // BRAM Ports
    wire [31:0] dinb;
    wire [31:0] doutb;
    wire enb;
    wire [3:0] web;

    wire [31:0] INSTR_AXI;
    wire [$clog2(N)-1:0] PC_AXI;

    wire [3:0] RST_ADD; // PE
    wire [3:0] MAC_CTRL;
    wire [3:0] RST_ACC;
    wire [3:0] RST_PC;
    wire [3:0] MAT_MUX;
    wire [3:0] WRITE_MAT;
    wire [3:0] OUT_READY;
    wire [1:0] DIMEN;

    wire [31:0] PE_DIN_0;
    wire [31:0] PE_DIN_1;
    wire [31:0] PE_DIN_2;
    wire [31:0] PE_DIN_3;

    wire [31:0] PE_DOUT_0;
    wire [31:0] PE_DOUT_1;
    wire [31:0] PE_DOUT_2;
    wire [31:0] PE_DOUT_3;

    wire ADDR_START; // DATA FETCH LOAD
    wire ADDR_RST;
    wire [16:0] ADDRESS;
    wire FETCH_DONE;
    wire [1:0] PE_SEL;
    wire PE_SEL_2x2;
    wire PE_SEL_4;

    wire WRADDR_START; // DATA FETCH STORE
    wire STORE_DONE;

    wire [2:0] latency_counter;

    wire [31:0] INSTR; //INSTR Module
    wire PC_INCR;
    wire INSTR_DONE;

    logic [3:0] MAC_DONE_PE; //AND All MAC DONE in top module
    logic MAC_DONE;

    assign MAC_DONE = MAC_DONE_PE[0] & MAC_DONE_PE[1] & MAC_DONE_PE[2] & MAC_DONE_PE[3];

    Control_Unit CU (.*);
    Data_Fetch DF (.*);
    Instr_Fetch IF (.*);
    BRAM_RF BRF (.*);
    Instruction_RF IRF (.*);

    Processing_Element PE0 (
        .CLK(CLK),
        .latency_counter(latency_counter),
        .RST_ADD(RST_ADD[0]),
        .DATAIN(PE_DIN_0),
        .MAC_CTRL(MAC_CTRL[0]),
        .RST_ACC(RST_ACC[0]),
        .RST_PC(RST_PC[0]),
        .MAT_MUX(MAT_MUX[0]),
        .WRITE_MAT(WRITE_MAT[0]),
        .DIMEN(DIMEN),
        .OUT_READY(OUT_READY[0]),
        .MAC_DONE(MAC_DONE_PE[0]),
        .DATAOUT(PE_DOUT_0)
        );

    Processing_Element PE1 (
        .CLK(CLK),
        .latency_counter(latency_counter),
        .RST_ADD(RST_ADD[1]),
        .DATAIN(PE_DIN_1),
        .MAC_CTRL(MAC_CTRL[1]),
        .RST_ACC(RST_ACC[1]),
        .RST_PC(RST_PC[1]),
        .MAT_MUX(MAT_MUX[1]),
        .WRITE_MAT(WRITE_MAT[1]),
        .DIMEN(DIMEN),
        .OUT_READY(OUT_READY[1]),
        .MAC_DONE(MAC_DONE_PE[1]),
        .DATAOUT(PE_DOUT_1)
        );

    Processing_Element PE2 (
        .CLK(CLK),
        .latency_counter(latency_counter),
        .RST_ADD(RST_ADD[2]),
        .DATAIN(PE_DIN_2),
        .MAC_CTRL(MAC_CTRL[2]),
        .RST_ACC(RST_ACC[2]),
        .RST_PC(RST_PC[2]),
        .MAT_MUX(MAT_MUX[2]),
        .WRITE_MAT(WRITE_MAT[2]),
        .DIMEN(DIMEN),
        .OUT_READY(OUT_READY[2]),
        .MAC_DONE(MAC_DONE_PE[2]),
        .DATAOUT(PE_DOUT_2)
        );

    Processing_Element PE3 (
        .CLK(CLK),
        .latency_counter(latency_counter),
        .RST_ADD(RST_ADD[3]),
        .DATAIN(PE_DIN_3),
        .MAC_CTRL(MAC_CTRL[3]),
        .RST_ACC(RST_ACC[3]),
        .RST_PC(RST_PC[3]),
        .MAT_MUX(MAT_MUX[3]),
        .WRITE_MAT(WRITE_MAT[3]),
        .DIMEN(DIMEN),
        .OUT_READY(OUT_READY[3]),
        .MAC_DONE(MAC_DONE_PE[3]),
        .DATAOUT(PE_DOUT_3)
        );
    
endmodule