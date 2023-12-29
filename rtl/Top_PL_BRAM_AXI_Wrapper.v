module Top_PL_BRAM_AXI_Wrapper(
    input CLK,
    input RSTN,

    input START_SIGNAL,
    output STOP_SIGNAL

    //output WBEN, uncomment if you are connecting to SoC
    //output WBADDR,
    //output WBVALUE
/*
    output addrb, // BRAM Ports
    output dinb,
    input doutb,
    output enb,
    output web*/
);
    parameter N = 512;
    wire CLK;
    wire RSTN;
    wire START_SIGNAL;
    wire STOP_SIGNAL;
/*
    wire [12:0] addrb; // BRAM Ports
    wire [31:0] dinb;
    wire [31:0] doutb;
    wire enb;
    wire [3:0] web;*/

    //wire WBEN;
    //wire [12:0] WBADDR;
    //wire [12:0] WBVALUE;

    Top_PL_BRAM_AXI #(.N(N)) ver_wrapper (
        .CLK(CLK),
        .RSTN(RSTN), //for active low reset put NOT gate here
        .START_SIGNAL(START_SIGNAL),
        .STOP_SIGNAL(STOP_SIGNAL)
        //.WBEN(WBEN),
        //.WBADDR(WBADDR),
        //.WBVALUE(WBVALUE)
        /*.addrb(addrb), // BRAM Ports
        .dinb(dinb),
        .doutb(doutb),
        .enb(enb),
        .web(web)*/
    );
    
endmodule