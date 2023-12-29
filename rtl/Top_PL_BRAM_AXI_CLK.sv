module Top_PL_BRAM_AXI_CLK(
    input logic CLK_DIV,
    input logic RSTN,
    input logic RSTN_CLK,
(*mark_debug = "true"*)    input logic START_SIGNAL,
(*mark_debug = "true"*)    output logic STOP_SIGNAL
);
    wire CLK;
    CLK_Divider CD (
        .clk_in(CLK_DIV),
        .rst(RSTN_CLK),
        .clk_out(CLK)
    );

    Top_PL_BRAM_AXI MAIN (.*);
endmodule