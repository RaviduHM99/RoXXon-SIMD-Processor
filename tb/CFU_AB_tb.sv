module CU_FU_tb ();
    timeunit 1ns/1ps;
    localparam N = 16, ADDR = 32'h00000000, REGN = 512, LogN = $clog2(N), B_START = 256;
    localparam CLK_PERIOD = 10;

    logic CLK=0, RSTN=0;

    //Control Unit
    logic [N-1:0] MAC_CTRL, RST_MUL, INC_PC, MAT_MUX, WRITE_MAT;
    logic [LogN-1:0] PC_Counter;
    //logic [LogN-1:0] SEQ_A;
    //logic [LogN-1:0] SEQ_B;
    //logic MATAB_MUX;

    logic [LogN-1:0] SEQ_DATC; 

    logic ONSWT;
    logic OFFSWT;

    //Fetch Unit
    logic [31:0] INSTRDATA;
    //logic [N-1:0][31:0] MAT_IN;

    logic [$clog2(REGN/2)-1:0] PC_INS;
    logic [N-1:0][31:0] RESULT;
    logic [N-1:0][31:0] DATAOUT;

    logic [N-1:0][N-1:0][31:0] MAT_OUT;

    //AB Reg File
    logic [REGN-1:0][31:0] IN_DATA;
    //logic [$clog2(N)-1:0] SEQ_A;
    //logic [$clog2(N)-1:0] SEQ_B;
    //logic MATAB_MUX;
    //logic [N-1:0][31:0] MAT_IN;

    CFU_AB #(.N(N), .ADDR(ADDR), .REGN(REGN), .LogN(LogN), .B_START(B_START)) dut (.*);

    initial forever #(CLK_PERIOD/2) CLK <= ~CLK;

    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
        
        @(posedge CLK); //Reset Testing
        #1 RSTN <= 1;

        #(CLK_PERIOD*2) // MATB Col Transfer
        RSTN <= 0;
        IN_DATA <= {512{32'd23}};

        #(CLK_PERIOD*2) // MATB Col Transfer
        RSTN <= 0;
        INSTRDATA <= 32'b00001001;
        PC_Counter <= 'd0;
        IN_DATA <= {512{32'd23}};
        DATAOUT <= 'dz;
        ONSWT <= 1'd1; 

        #(CLK_PERIOD*2) // MATA Row Transfer
        INSTRDATA <= 32'b00001010;
        PC_Counter <= 'd0;
        IN_DATA <= {512{32'd23}};
        DATAOUT <= 'dz;
        ONSWT <= 1'd1;

        #(CLK_PERIOD*2) // MATMUL
        INSTRDATA <= 32'b00000011;
        PC_Counter <= 'd0;
        IN_DATA <= {512{32'd23}};
        DATAOUT <= 'dz;
        ONSWT <= 1'd1;
        #(CLK_PERIOD)

        #(CLK_PERIOD*2) // MATMUL Ending
        INSTRDATA <= 32'b00000011;
        PC_Counter <= 'd15;
        IN_DATA <= {512{32'd23}};
        DATAOUT <= 'dz;
        ONSWT <= 1'd1;

        #(CLK_PERIOD*2) //WriteBack
        INSTRDATA <= 32'b00000100;
        PC_Counter <= 'd0;
        IN_DATA <= {512{32'd23}};
        DATAOUT <= {32'd13, 32'd23, 32'd34, 32'd45, 32'd65, 32'd67, 32'd78, 32'd89, 32'd90, 32'd130, 32'd121, 32'd122, 32'd143, 32'd154, 32'd165, 32'd146};
        ONSWT <= 1'd1;

        #(CLK_PERIOD*2) //END
        INSTRDATA <= 32'b10000000;
        PC_Counter <= 'd0;
        IN_DATA <= {512{32'd23}};
        DATAOUT <= 'dz;
        ONSWT <= 1'd1; 

        #(CLK_PERIOD*2) 

        $finish();
    end

endmodule