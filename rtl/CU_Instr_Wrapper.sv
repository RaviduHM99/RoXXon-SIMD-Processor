`timescale 1ns/1ps

module CU_Instr_Wrapper #(
    parameter N = 512
) (
    input logic CLK, RSTN,

    input logic [31:0] INSTR_AXI,
    output logic [$clog2(N)-1:0] PC_AXI,

    output logic [3:0] RST_ADD, // PE
    output logic [3:0] MAC_CTRL,
    output logic [3:0] RST_ACC,
    output logic [3:0] RST_PC,
    output logic [3:0] MAT_MUX,
    output logic [3:0] WRITE_MAT,
    output logic [3:0] OUT_READY,
    input logic MAC_DONE, //AND All MAC DONE in top module

    output logic [1:0] DIMEN, // DATA FETCH LOAD
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
    output logic STOP_SIGNAL
);

    wire [31:0] INSTR;
    wire PC_INCR;
    wire INSTR_DONE;

    Control_Unit CU (.*);
    Instr_Fetch #(.N(N)) IF (.*);

    
endmodule