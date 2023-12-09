module Top_PL_BRAM_AXI_tb;
    timeunit 1ns/1ps;
    localparam CLK_PERIOD = 10;
    localparam N =512;

    logic CLK=0, RSTN=0;

    logic START_SIGNAL; //GPIO
    logic STOP_SIGNAL;

    Top_PL_BRAM_AXI dut (.*);

    initial forever begin
        #(CLK_PERIOD/2) CLK <= ~CLK;
    end

    initial begin
        $dumpfile("INSTR_AXI_Fetch_tb.vcd"); $dumpvars;
        @(posedge CLK); 
        #1 RSTN <= 1'b1;
        START_SIGNAL <= 1'b0;

        #(CLK_PERIOD) 
        RSTN <= 0;
        START_SIGNAL <= 1'b1; 

        #(CLK_PERIOD*250)
        $finish();
    end
    
endmodule