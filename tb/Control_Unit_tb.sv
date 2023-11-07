module Control_Unit_tb ();
    timeunit 1ns/1ps;
    localparam N = 16, REGN = 512, LogN = $clog2(N);
    localparam CLK_PERIOD = 10;

    logic CLK=0, RSTN=0;
    
    logic DONE, DOUT_MUX, MATAB_MUX; 
    logic [LogN-1:0] SEQ_B;
    logic [31:0] INSTR;
    logic [N-1:0] MAC_CTRL, RST_MUL, INC_PC, MAT_MUX, WRITE_MAT; 
    logic [LogN-1:0] PC_Counter;

    logic [LogN-1:0] SEQ_A;

    logic [LogN-1:0] SEQ_DATC; 

    logic ONSWT;
    logic OFFSWT;

    Control_Unit #(.N(N), .REGN(REGN), .LogN(LogN)) dut (.*);

    initial forever #(CLK_PERIOD/2) CLK <= ~CLK;

    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
        
        @(posedge CLK); //Reset Testing
        #1 RSTN <= 1;

        #(CLK_PERIOD*2) //
        RSTN <= 0;
        INSTR <= 32'b00000000;
        PC_Counter <= 'd0;
        ONSWT <= 1'd1;

        #(CLK_PERIOD*1) //
        INSTR <= 32'b00000001;
        PC_Counter <= 'd0;
        ONSWT <= 1'd1;

        #(CLK_PERIOD*1) // 
        INSTR <= 32'b00001001;
        PC_Counter <= 'd0;
        ONSWT <= 1'd1;

        #(CLK_PERIOD*1) //
        INSTR <= 32'b00000010;
        PC_Counter <= 'd0;
        ONSWT <= 1'd1;

        #(CLK_PERIOD*1) //
        INSTR <= 32'b00001010;
        PC_Counter <= 'd0;
        ONSWT <= 1'd1;

        #(CLK_PERIOD*1) //
        INSTR <= 32'b00000011;
        PC_Counter <= 'd0;
        ONSWT <= 1'd1;

        #(CLK_PERIOD*2)

        #(CLK_PERIOD*1) //
        INSTR <= 32'b00000011;
        PC_Counter <= 'd15;
        ONSWT <= 1'd1;

        #(CLK_PERIOD*1) // Check MatC address
        INSTR <= 32'b00000100;
        PC_Counter <= 'd0;
        ONSWT <= 1'd1;

        #(CLK_PERIOD*1) // Switched OFF Loop in a IDLE
        INSTR <= 32'b10000000;
        PC_Counter <= 'd0;
        ONSWT <= 1'd1;

        #(CLK_PERIOD*5)
        $finish();
    end

endmodule