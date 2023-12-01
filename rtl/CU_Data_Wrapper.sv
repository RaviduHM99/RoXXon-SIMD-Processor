`timescale 1ns/1ps

module CU_Data_Wrapper (
    input logic CLK, RSTN,

    output logic [31:0] addrb, // BRAM Ports
    output logic [31:0] dinb,
    input logic [31:0] doutb,
    output logic enb,
    output logic [3:0] web,

    output logic [31:0] PE_DIN_0,
    output logic [31:0] PE_DIN_1,
    output logic [31:0] PE_DIN_2,
    output logic [31:0] PE_DIN_3,

    input logic [31:0] PE_DOUT_0,
    input logic [31:0] PE_DOUT_1,
    input logic [31:0] PE_DOUT_2,
    input logic [31:0] PE_DOUT_3,

    input logic [31:0] INSTR, // INST FETCH
    output logic PC_INCR,
    output logic INSTR_DONE, 

    output logic [3:0] RST_ADD, // PE
    output logic [3:0] MAC_CTRL,
    output logic [3:0] RST_ACC,
    output logic [3:0] RST_PC,
    output logic [3:0] MAT_MUX,
    output logic [3:0] WRITE_MAT,
    output logic [3:0] OUT_READY,
    input logic MAC_DONE, //AND All MAC DONE in top module

    input logic START_SIGNAL, //GPIO
    output logic STOP_SIGNAL
);

    wire [1:0] DIMEN; // DATA FETCH LOAD
    wire ADDR_START;
    wire ADDR_RST;
    wire [3:0] ADDRESS;
    wire FETCH_DONE;
    wire [1:0] PE_SEL;
    wire PE_SEL_2x2;
    wire PE_SEL_4;

    wire WRADDR_START; // DATA FETCH STORE
    wire STORE_DONE;

    Control_Unit CU (.*);
    Data_Fetch DF (.*);


    
endmodule