module Processing_Element_tb;
    timeunit 1ns/1ps;
    localparam N = 16;
    localparam CLK_PERIOD = 10;

    logic CLK=0;

    logic RST_ADD;
    logic [31:0] DATAIN;
    logic MAC_CTRL;
    logic RST_ACC;
    logic RST_PC;
    logic INC_PC;
    logic MAT_MUX;
    logic WRITE_MAT;

    logic [$clog2(N)-1:0] PC_Counter;
    logic [31:0] DATAOUT;

    Processing_Element #(.N(N)) dut (.*);

    initial forever begin
        #(CLK_PERIOD/2) CLK <= ~CLK;
    end

    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
        @(posedge CLK); 
        #1 RST_PC <= 1'b1; RST_ADD <= 1'b1; RST_ACC <= 1'b1;
        #(CLK_PERIOD) 
        RST_PC <= 1'b0; RST_ADD <= 1'b0; RST_ACC <= 1'b0;
        MAC_CTRL <= 1'b0;
        WRITE_MAT <= 1'b0;
        INC_PC <= 1'b0;
///////// 2x2 Matrix /////////
        #(CLK_PERIOD) 
        WRITE_MAT <= 1'b1;
        DATAIN <= 32'd14;
        MAT_MUX <= 1'b0;
        #(CLK_PERIOD)
        WRITE_MAT <= 1'b1;
        DATAIN <= 32'd15;
        MAT_MUX <= 1'b0;
        RST_ADD <= 1'b1;

        #(CLK_PERIOD)
        WRITE_MAT <= 1'b1;
        DATAIN <= 32'd13;
        MAT_MUX <= 1'b1;
        RST_ADD <= 1'b0;
        #(CLK_PERIOD)
        WRITE_MAT <= 1'b1;
        DATAIN <= 32'd12;
        MAT_MUX <= 1'b1;
        RST_ADD <= 1'b1;
        #(CLK_PERIOD)

        WRITE_MAT <= 1'b0;
    	RST_ADD <= 1'b0;
        INC_PC <= 1'b1;
        MAC_CTRL <= 1'b1;
        #(CLK_PERIOD*3)
        INC_PC <= 1'b0;
        MAC_CTRL <= 1'b0;
        #(CLK_PERIOD*3)

        $finish();
    end
    
endmodule