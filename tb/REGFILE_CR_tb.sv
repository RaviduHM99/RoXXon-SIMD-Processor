module REGFILE_CR_tb ();
    timeunit 1ns/1ps;
    localparam N = 16, REGN = 512, B_START = 256;
    localparam CLK_PERIOD = 10;

    logic CLK=0, RSTN=0;
    logic [N-1:0][31:0] IN_DATA; //warning 
    logic [REGN/2-1:0][31:0] IN_INS;
    logic [$clog2(N)-1:0] SEQ_DATC;
    logic [$clog2(REGN/2)-1:0] SEQ_INS;
    logic [31:0] INS_OUT;
    logic [N-1:0][31:0] MAT_IN;

    REGFILE_CR #(.N(N), .REGN(REGN), .B_START(B_START)) dut (.*);

    initial forever #(CLK_PERIOD/2) CLK <= ~CLK;

    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
        
        @(posedge CLK); //Reset Testing
        #1 RSTN <= 1;

        #(CLK_PERIOD*2) //MATRIX A Input data fetching
        RSTN <= 0;
        IN_DATA <= {N{32'd5}};
        IN_INS <= {B_START{32'd8}};
        SEQ_DATC <= 4'd0;
        SEQ_INS <= 8'd0;
        #(CLK_PERIOD*2) //MATRIX B Input data fetching
        RSTN <= 0;
        IN_DATA <= {N{32'd9}};
        IN_INS <= {B_START{32'd5}};
        SEQ_DATC <= 4'd1;
        SEQ_INS <= 8'd1;
        #(CLK_PERIOD*5)
        $finish();
    end

endmodule