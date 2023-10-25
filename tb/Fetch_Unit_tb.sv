module Fetch_Unit_tb ();
    timeunit 1ns/1ps;
    localparam N = 2;
    localparam ADDR = 32'h00000000;
    localparam REGN = 512;
    localparam CLK_PERIOD = 10;

    logic CLK=0, RSTN=0;
    logic [31:0] INSTRDATA;
    logic [N-1:0][31:0] MAT_IN;
    logic DONE, INS_MUX, MATD_MUX, DOUT_MUX;

    logic [$clog2(REGN) - 1:0] PC;
    logic [N-1:0][31:0] MAT_OUT;
    logic [31:0] INSTR;
    logic [31:0] DATAOUT, RESULT;

    Fetch_Unit #(.N(N), .ADDR(ADDR)) dut (.*);

    initial forever #(CLK_PERIOD/2) CLK <= ~CLK;

    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
        
        @(posedge CLK); //Reset Testing
        #1 RSTN <= 1;

        #(CLK_PERIOD*2) //MATRIX Input data fetching
        RSTN <= 0;
        MAT_IN <= {32'd3, 32'd4};
        MATD_MUX <= 1;
        INSTRDATA <= 32'dz;
        INS_MUX <= 0;
        DONE <= 0;
        DOUT_MUX <= 0;
        DATAOUT <= 32'dz;

        #(CLK_PERIOD*2) //Instruction Fetching
        MAT_IN <= {32'dz, 32'dz};
        MATD_MUX <= 0;
        INSTRDATA <= 32'd5;
        INS_MUX <= 1;
        DONE <= 0;
        DOUT_MUX <= 0;
        DATAOUT <= 32'dz;

        #(CLK_PERIOD*2) //Result Output & Next PC
        MAT_IN <= {32'dz, 32'dz};
        MATD_MUX <= 0;
        INSTRDATA <= 32'dz;
        INS_MUX <= 0;
        DONE <= 1;
        DOUT_MUX <= 1;
        DATAOUT <= 32'd5;

        #(CLK_PERIOD*2) 

        $finish();
    end

endmodule