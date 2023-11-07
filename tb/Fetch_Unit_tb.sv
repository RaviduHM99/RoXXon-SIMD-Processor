module Fetch_Unit_tb ();
    timeunit 1ns/1ps;
    localparam N = 16;
    localparam ADDR = 32'h00000000;
    localparam REGN = 512;
    localparam CLK_PERIOD = 10;

    logic CLK=0, RSTN=0;
    logic [31:0] INSTRDATA;
    logic [N-1:0][31:0] MAT_IN;
    logic DONE, DOUT_MUX; //MATAB_MUX, 

    logic [$clog2(REGN/2) - 1:0] PC_INS;
    logic [31:0] INSTR;
    logic [N-1][31:0] RESULT;
    logic [N-1][31:0] DATAOUT;

    //logic [$clog2(N)-1:0]SEQ_B;
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
        MAT_IN <= {32'd1, 32'd2, 32'd3, 32'd4, 32'd5, 32'd6, 32'd7, 32'd8, 32'd9, 32'd10, 32'd11, 32'd12, 32'd13, 32'd14, 32'd15, 32'd16}; //16
        DATAOUT <= 'dz;
        //SEQ_B <= 'd1;

        DOUT_MUX <= 0;
        DONE <= 1;
        //MATAB_MUX <= 0;

        #(CLK_PERIOD*2) //MATRIX A Input data fetching
        INSTRDATA <= 32'dz;
        MAT_IN <= {32'd13, 32'd23, 32'd34, 32'd45, 32'd65, 32'd67, 32'd78, 32'd89, 32'd90, 32'd130, 32'd121, 32'd122, 32'd143, 32'd154, 32'd165, 32'd146}; //16
        DATAOUT <= 'dz;
        //SEQ_B <= 'd0;

        DOUT_MUX <= 0;
        DONE <= 1;
        //MATAB_MUX <= 1;

        #(CLK_PERIOD*1)
        MAT_IN <= {32'd13, 32'd23, 32'd34, 32'd45, 32'd65, 32'd67, 32'd78, 32'd89, 32'd90, 32'd130, 32'd121, 32'd122, 32'd143, 32'd154, 32'd165, 32'd146}; //16

        #(CLK_PERIOD*2) //Instruction Fetching
        INSTRDATA <= 32'd5;
        MAT_IN <= 'dz;
        DATAOUT <= 'dz;
        //SEQ_B <= 'd0;

        DOUT_MUX <= 0;
        DONE <= 1;
        //MATAB_MUX <= 1;

        #(CLK_PERIOD*2) //Result Output & Next PC
        INSTRDATA <= 32'dz;
        MAT_IN <= 'dz;
        DATAOUT <= {32'd13, 32'd23, 32'd34, 32'd45, 32'd65, 32'd67, 32'd78, 32'd89, 32'd90, 32'd130, 32'd121, 32'd122, 32'd143, 32'd154, 32'd165, 32'd146};
        //SEQ_B <= 'd0;

        DOUT_MUX <= 1;
        DONE <= 1;
        //MATAB_MUX <= 1;

        #(CLK_PERIOD*2) 

        $finish();
    end

endmodule