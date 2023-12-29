module Top_FPGA_tb;
    timeunit 1ns/1ps;
    localparam CLK_DIV_PERIOD = 8;
    localparam N =512;

    logic CLK_DIV=0, RSTN=0;
    logic RSTN_CLK;
    logic START_SIGNAL; //GPIO
    logic STOP_SIGNAL;

    /*
    logic WBEN;
    logic [12:0] WBADDR;
    logic [12:0] WBVALUE;*/

    Top_PL_BRAM_AXI_CLK dut (.*);

    initial forever begin
        #(CLK_DIV_PERIOD/2) CLK_DIV <= ~CLK_DIV;
    end

    initial begin
        $dumpfile("INSTR_AXI_Fetch_tb.vcd"); $dumpvars;

        @(posedge CLK_DIV); 
        #1 RSTN <= 1'b1;
        RSTN_CLK <= 1'b1;
        START_SIGNAL <= 1'b0;

        #(CLK_DIV_PERIOD) 
        RSTN_CLK <= 1'b0;
        START_SIGNAL <= 1'b0; 

        #(CLK_DIV_PERIOD*2) 
        RSTN <= 1'b0;
        START_SIGNAL <= 1'b1; 

        #(CLK_DIV_PERIOD*400)
        $finish();
    end
    
endmodule