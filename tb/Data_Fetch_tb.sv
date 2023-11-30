module Fetch_Unit_tb ();
    timeunit 1ns/1ps;
    localparam N = 2;
    localparam CLK_PERIOD = 10;

    logic CLK=0, RSTN=0;

    Fetch_Unit #(.N(N), .ADDR(ADDR)) dut (.*);

    initial forever #(CLK_PERIOD/2) CLK <= ~CLK;

    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
        
        @(posedge CLK); //Reset Testing
        #1 RSTN <= 1;

        #(CLK_PERIOD*2) 

        $finish();
    end

endmodule