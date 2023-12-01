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

    logic MAT_MUX;
    logic WRITE_MAT;
    logic [1:0] DIMEN;
    logic OUT_READY;

    logic MAC_DONE;
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
        MAT_MUX <= 1'b0;
        WRITE_MAT <= 1'b0;
        MAT_MUX <= 1'b0;
        DIMEN <= 2'b00;
        OUT_READY <= 1'b0;
        DATAIN <= 32'dz;

///////// 2x2 Matrix /////////
        #(CLK_PERIOD) 
        DATAIN <= 32'd45;
        MAC_CTRL <= 1'b0;
        MAT_MUX <= 1'b1;
        WRITE_MAT <= 1'b1;
        DIMEN <= 2'b00;
        OUT_READY <= 1'b0;

        #(CLK_PERIOD) //RESET ADDR then LOAD B
        DATAIN <= 32'd34;
        MAC_CTRL <= 1'b0;
        WRITE_MAT <= 1'b1;
        MAT_MUX <= 1'b1;
        DIMEN <= 2'b00;
        OUT_READY <= 1'b0;
        RST_ADD <= 1'b1;

        #(CLK_PERIOD)
        DATAIN <= 32'd65;
        MAC_CTRL <= 1'b0;
        WRITE_MAT <= 1'b1;
        MAT_MUX <= 1'b0;
        DIMEN <= 2'b00;
        OUT_READY <= 1'b0;
        RST_ADD <= 1'b0;

        #(CLK_PERIOD)
        DATAIN <= 32'd79;
        MAC_CTRL <= 1'b0;
        WRITE_MAT <= 1'b1;
        MAT_MUX <= 1'b0;
        DIMEN <= 2'b00;
        OUT_READY <= 1'b0;

        #(CLK_PERIOD*1) //MULTACC
        DATAIN <= 32'dz;
        MAC_CTRL <= 1'b1;
        WRITE_MAT <= 1'b0;
        MAT_MUX <= 1'b0;
        DIMEN <= 2'b00;
        OUT_READY <= 1'b0;

        #(CLK_PERIOD*3) //DATAOUT
        DATAIN <= 32'dz;
        MAC_CTRL <= 1'b0;
        WRITE_MAT <= 1'b0;
        MAT_MUX <= 1'b0;
        DIMEN <= 2'b00;
        OUT_READY <= 1'b1;
        #(CLK_PERIOD*2)
        $finish();
    end
    
endmodule