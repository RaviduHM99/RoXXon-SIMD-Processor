module Fetch_Unit_tb ();
    timeunit 1ns/1ps;
    localparam N = 2;
    localparam ADDR = 32'h00000000;
    localparam REGN = 512;
    localparam CLK_PERIOD = 10;

    logic CLK=0, RSTN=0;
    logic [31:0] INSTRDATA;
    logic [N-1:0][31:0] MAT_IN;
    logic MATAB_MUX, DONE, DOUT_MUX;

    logic [$clog2(REGN) - 1:0] PC_INS;
    logic [31:0] INSTR;
    logic [31:0] RESULT;
    logic [31:0] DATAOUT;

    logic DONE_DATAB;
    logic [$clog2(N)-1:0]SEQ_B;
    logic [N-1:0][N-1:0][31:0] MAT_OUT;

    Fetch_Unit #(.N(N), .ADDR(ADDR)) dut (.*);

    initial forever #(CLK_PERIOD/2) CLK <= ~CLK;

    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
        
        @(posedge CLK); //Reset Testing
        #1 RSTN <= 1;

        #(CLK_PERIOD*2) //MATRIX B Input data fetching
        RSTN <= 0;
        INSTRDATA <= 32'dz;
        MAT_IN <= {32'd2, 32'd1};
        DATAOUT <= 32'dz;

        DOUT_MUX <= 0;
        DONE <= 0;
        MATAB_MUX <= 0;
        DONE_DATAB <= 1;

        #(CLK_PERIOD*2) //MATRIX A Input data fetching
        INSTRDATA <= 32'dz;
        MAT_IN <= {32'd4, 32'd5};
        DATAOUT <= 32'dz;

        DOUT_MUX <= 0;
        DONE <= 0;
        MATAB_MUX <= 1;
        DONE_DATAB <= 0;

        #(CLK_PERIOD*1)
        MAT_IN <= {32'd7, 32'd8};
        DONE_DATAB <= 0;

        #(CLK_PERIOD*2) //Instruction Fetching
        INSTRDATA <= 32'd5;
        MAT_IN <= {32'dz, 32'dz};
        DATAOUT <= 32'dz;

        DOUT_MUX <= 0;
        DONE <= 0;
        MATAB_MUX <= 1;
        DONE_DATAB <= 0;

        #(CLK_PERIOD*2) //Result Output & Next PC
        INSTRDATA <= 32'dz;
        MAT_IN <= {32'dz, 32'dz};
        DATAOUT <= 32'd45;

        DOUT_MUX <= 1;
        DONE <= 1;
        MATAB_MUX <= 1;
        DONE_DATAB <= 0;

        #(CLK_PERIOD*2) 

        $finish();
    end

endmodule