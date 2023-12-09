module CU_Data_tb;
    timeunit 1ns/1ps;

    localparam CLK_PERIOD = 10;

    logic CLK=0, RSTN=0;

    logic [31:0] addrb;
    logic [31:0] dinb;
    logic [31:0] doutb;//
    logic enb;
    logic [3:0] web;

    logic [31:0] PE_DIN_0;
    logic [31:0] PE_DIN_1;
    logic [31:0] PE_DIN_2;
    logic [31:0] PE_DIN_3;

    logic [31:0] PE_DOUT_0;//
    logic [31:0] PE_DOUT_1;
    logic [31:0] PE_DOUT_2;
    logic [31:0] PE_DOUT_3;

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

    logic START_SIGNAL; //GPIO
    logic STOP_SIGNAL;

    CU_Data_Wrapper dut (.*);

    initial forever begin
        #(CLK_PERIOD/2) CLK <= ~CLK;
    end

    initial begin
        $dumpfile("Instr_Fetch_tb.vcd"); $dumpvars;
        @(posedge CLK); 
        #1 RSTN <= 1'b1;
        INSTR <= 32'd0;
        MAC_DONE <= 1'b0;
        START_SIGNAL <= 1'b0;

        doutb <= 32'dz;
        PE_DOUT_0 <= 32'dz;
        PE_DOUT_1 <= 32'dz;
        PE_DOUT_2 <= 32'dz;
        PE_DOUT_3 <= 32'dz;

        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR <= 32'd0;
        MAC_DONE <= 1'b0;
        START_SIGNAL <= 1'b0;

        doutb <= 32'd34;

        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR <= 32'b01010100100010; 
        MAC_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        doutb <= 32'd34;
        #(CLK_PERIOD)
        doutb <= 32'd45;
        
        #(CLK_PERIOD*3) 
        RSTN <= 0; 
        INSTR <= 32'b00100100000010;
        MAC_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        doutb <= 32'd67;
        #(CLK_PERIOD)
        doutb <= 32'd79;

        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR <= 32'b00100100000010;
        MAC_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        doutb <= 32'd57;
        #(CLK_PERIOD)
        doutb <= 32'd32;

        #(CLK_PERIOD*2) 
        RSTN <= 0; 
        INSTR <= 32'b01110110000011;
        MAC_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        doutb <= 32'd24;

        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR <= 32'b01110110000011;
        MAC_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;
        
        doutb <= 32'd84;
        #(CLK_PERIOD)
        doutb <= 32'd39;

        #(CLK_PERIOD*2) 
        RSTN <= 0; 
        INSTR <= 32'b00101110000011;
        MAC_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        doutb <= 32'd24;

        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR <= 32'b00101110000011;
        MAC_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        doutb <= 32'd56;

        #(CLK_PERIOD*2)  
        RSTN <= 0; 
        INSTR <= 32'b00000000000100;
        MAC_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        doutb <= 32'dz;

        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR <= 32'b00000000000100;
        MAC_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        PE_DOUT_0 <= 32'd33;
        PE_DOUT_1 <= 32'd34;
        PE_DOUT_2 <= 32'd35;
        PE_DOUT_3 <= 32'd36;

        #(CLK_PERIOD*2)
        RSTN <= 0; 
        INSTR <= 32'b00011000000101;
        MAC_DONE <= 1'b1;
        START_SIGNAL <= 1'b1;
        
        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR <= 32'b00011000000101;
        MAC_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        #(CLK_PERIOD*4)

        RSTN <= 0; 
        INSTR <= 32'b00000000000110;
        MAC_DONE <= 1'b0;
        START_SIGNAL <= 1'b1;

        #(CLK_PERIOD*10)
        $finish();
    end
    
endmodule