module Top_PL_Wrapper(
    input CLK,
    input RSTN,

    input START_SIGNAL,
    output STOP_SIGNAL
);
    parameter N = 512;
    wire CLK;
    wire RSTN;
    wire START_SIGNAL;
    wire STOP_SIGNAL;

    Top_PL #(.N(N)) ver_wrapper (
        .CLK(CLK),
        .RSTN(RSTN),
        .START_SIGNAL(START_SIGNAL),
        .STOP_SIGNAL(STOP_SIGNAL)
    );
    
endmodule