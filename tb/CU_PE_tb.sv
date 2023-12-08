module CU_PE_tb;
    timeunit 1ns/1ps;

    localparam CLK_PERIOD = 10;

    logic CLK=0, RSTN=0;

    logic [31:0] INSTR; // INST FETCH
    logic PC_INCR;
    logic INSTR_DONE; 

    //logic [1:0] DIMEN; // DATA FETCH LOAD
    logic ADDR_START;
    logic ADDR_RST;
    logic [3:0] ADDRESS;
    logic FETCH_DONE;
    logic [1:0] PE_SEL;
    logic PE_SEL_2x2;
    logic PE_SEL_4;

    logic WRADDR_START; // DATA FETCH STORE
    logic STORE_DONE;

    logic START_SIGNAL; //GPIO
    logic STOP_SIGNAL;

    logic [3:0][31:0] DATAIN;
    logic [3:0][31:0] DATAOUT;

    CU_PE_Wrapper dut (.*);

    initial forever begin
        #(CLK_PERIOD/2) CLK <= ~CLK;
    end

    initial begin
        $dumpfile("Instr_Fetch_tb.vcd"); $dumpvars;
        @(posedge CLK); 
        #1 RSTN <= 1'b1;
        INSTR <= 32'd0;
        FETCH_DONE <= 1'b0;
        STORE_DONE <= 1'b0;
        START_SIGNAL <= 1'b0;
        DATAIN[0] <= 32'dz;
        DATAIN[1] <= 32'dz;
        DATAIN[2] <= 32'dz; 
        DATAIN[3] <= 32'dz; 

        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR <= 32'd0;
        FETCH_DONE <= 1'b0;
        STORE_DONE <= 1'b0;
        START_SIGNAL <= 1'b0;
        DATAIN[0] <= 32'dz;
        DATAIN[1] <= 32'dz;
        DATAIN[2] <= 32'dz; 
        DATAIN[3] <= 32'dz; 

        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR <= 32'b010010100100010; 
        FETCH_DONE <= 1'b0;
        STORE_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        #(CLK_PERIOD*2) 
        DATAIN[0] <= 32'd23;
        DATAIN[1] <= 32'd23;
        DATAIN[2] <= 32'dz; 
        DATAIN[3] <= 32'dz; 
        #(CLK_PERIOD*2) 
        DATAIN[0] <= 32'd63;
        DATAIN[1] <= 32'd63;
        DATAIN[2] <= 32'dz; 
        DATAIN[3] <= 32'dz; 

        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR <= 32'b000010100100010;
        FETCH_DONE <= 1'b1;
        STORE_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR <= 32'b000010100100010;
        FETCH_DONE <= 1'b0;
        STORE_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR <= 32'b000010100100010;
        FETCH_DONE <= 1'b0;
        STORE_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        #(CLK_PERIOD) 
        DATAIN[0] <= 32'd0;
        DATAIN[1] <= 32'd0;
        DATAIN[2] <= 32'd56;
        DATAIN[3] <= 32'd56;
        #(CLK_PERIOD) 
        DATAIN[0] <= 32'd0;
        DATAIN[1] <= 32'd0;
        DATAIN[2] <= 32'd78; 
        DATAIN[3] <= 32'd78; 

        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR <= 32'b010010110000011;
        FETCH_DONE <= 1'b1;
        STORE_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        #(CLK_PERIOD) 
        DATAIN[0] <= 32'd0;
        DATAIN[1] <= 32'd56;
        DATAIN[2] <= 32'd0;
        DATAIN[3] <= 32'd56;
        #(CLK_PERIOD) 
        DATAIN[0] <= 32'd0;
        DATAIN[1] <= 32'd42;
        DATAIN[2] <= 32'd0;
        DATAIN[3] <= 32'd42;

        #(CLK_PERIOD*3)
        $finish();
    end
    
endmodule