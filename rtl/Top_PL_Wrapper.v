module Top_PL_Wrapper(
    input CLK,
    input RSTN,

    output addrb, // BRAM Ports
    output dinb,
    input doutb,
    output enb,
    output web,

    input INSTR_AXI,
    output PC_AXI,

    input START_SIGNAL,
    output STOP_SIGNAL
);
    parameter N = 512;
    wire CLK;
    wire RSTN;
    wire START_SIGNAL;
    wire STOP_SIGNAL;

    wire [12:0] addrb; // BRAM Ports
    wire [31:0] dinb;
    wire [31:0] doutb;
    wire enb;
    wire [3:0] web;

    wire [31:0] INSTR_AXI;
    wire [$clog2(N)-1:0] PC_AXI;

    Top_PL #(.N(N)) ver_wrapper (
        .CLK(CLK),
        .RSTN(RSTN),

        .addrb(addrb), // BRAM Ports
        .dinb(dinb),
        .doutb(doutb),
        .enb(enb),
        .web(web),
    
        .INSTR_AXI(INSTR_AXI),
        .PC_AXI(PC_AXI),

        .START_SIGNAL(START_SIGNAL),
        .STOP_SIGNAL(STOP_SIGNAL)
    );
    
endmodule