module Instr_Fetch_tb;
    timeunit 1ns/1ps;
    localparam N = 256;
    localparam CLK_PERIOD = 10;

    logic CLK=0, RSTN=0;

    logic [31:0] INSTR;
    logic PC_INCR;
    logic INSTR_DONE; 

    logic [31:0] INSTR_AXI;
    logic [$clog2(N)-1:0] PC_AXI;

    Instr_Fetch #(.N(N)) dut (.*);

    initial forever begin
        #(CLK_PERIOD/2) CLK <= ~CLK;
    end

    initial begin
        $dumpfile("Instr_Fetch_tb.vcd"); $dumpvars;
        @(posedge CLK); 
        #1 RSTN <= 1'b1;
        PC_INCR <= 1'b0;
        INSTR_DONE <= 1'b0;

        #(CLK_PERIOD) 
        RSTN <= 0; 

        #(CLK_PERIOD)
        PC_INCR <= 1'b1;
        INSTR_DONE <= 1'b1;
        INSTR_AXI <= 32'd5;

        #(CLK_PERIOD*2)
        PC_INCR <= 1'b0;
        INSTR_DONE <= 1'b1;
        INSTR_AXI <= 32'd6;
        #(CLK_PERIOD*2)
        $finish();
    end
    
endmodule