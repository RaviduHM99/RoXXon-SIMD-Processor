module Control_Unit_tb;
    timeunit 1ns/1ps;
    localparam N = 256;
    localparam CLK_PERIOD = 10;

    logic CLK=0, RSTN=0;

    logic [31:0] INSTR; // INST FETCH
    logic PC_INCR;
    logic INSTR_DONE; 

    logic [3:0] RST_ADD; // PE
    logic [3:0] MAC_CTRL;
    logic [3:0] RST_ACC;
    logic [3:0] RST_PC;
    logic [3:0] MAT_MUX;
    logic [3:0] WRITE_MAT;
    logic [3:0] OUT_READY;
    logic MAC_DONE;

    logic [1:0] DIMEN; // DATA FETCH LOAD
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

    Control_Unit dut (.*);

    initial forever begin
        #(CLK_PERIOD/2) CLK <= ~CLK;
    end

    initial begin
        $dumpfile("Instr_Fetch_tb.vcd"); $dumpvars;
        @(posedge CLK); 
        #1 RSTN <= 1'b1;
        INSTR <= 32'd0;
        MAC_DONE <= 1'b0;
        FETCH_DONE <= 1'b0;
        STORE_DONE <= 1'b0;
        START_SIGNAL <= 1'b0;

        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR <= 32'd0;
        MAC_DONE <= 1'b0;
        FETCH_DONE <= 1'b0;
        STORE_DONE <= 1'b0;
        START_SIGNAL <= 1'b0;

        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR <= 32'b01010100100010; 
        MAC_DONE <= 1'b0;
        FETCH_DONE <= 1'b0;
        STORE_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR <= 32'b01010100100010;
        MAC_DONE <= 1'b0;
        FETCH_DONE <= 1'b1;
        STORE_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR <= 32'b01100110000011;
        MAC_DONE <= 1'b0;
        FETCH_DONE <= 1'b0;
        STORE_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR <= 32'b01100110000011;
        MAC_DONE <= 1'b0;
        FETCH_DONE <= 1'b1;
        STORE_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR <= 32'b00000000000100;
        MAC_DONE <= 1'b0;
        FETCH_DONE <= 1'b0;
        STORE_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR <= 32'b00000000000100;
        MAC_DONE <= 1'b1;
        FETCH_DONE <= 1'b0;
        STORE_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR <= 32'b00011000000101;
        MAC_DONE <= 1'b0;
        FETCH_DONE <= 1'b0;
        STORE_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        #(CLK_PERIOD*3)
        RSTN <= 0; 
        INSTR <= 32'b00011000000101;
        MAC_DONE <= 1'b0;
        FETCH_DONE <= 1'b0;
        STORE_DONE <= 1'b1;
        START_SIGNAL <= 1'b1;
        
        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR <= 32'b00000000000110;
        MAC_DONE <= 1'b0;
        FETCH_DONE <= 1'b0;
        STORE_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        #(CLK_PERIOD*2)
        $finish();
    end
    
endmodule