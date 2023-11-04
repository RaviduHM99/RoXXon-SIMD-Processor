module REGFILE_AB_tb ();
    timeunit 1ns/1ps;
    localparam N = 16, REGN = 512, B_START = 256;
    localparam CLK_PERIOD = 10;

    logic CLK=0, RSTN=0;
    logic [REGN-1:0][31:0] IN_DATA;
    logic [$clog2(N)-1:0] SEQ_A;
    logic [$clog2(N)-1:0] SEQ_B;
    logic MATAB_MUX;
    logic [N-1:0][31:0] MAT_IN;

    REGFILE_AB #(.N(N), .REGN(REGN), .B_START(B_START)) dut (.*);

    initial forever #(CLK_PERIOD/2) CLK <= ~CLK;

    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
        
        @(posedge CLK); //Reset Testing
        #1 RSTN <= 1;

        #(CLK_PERIOD*2) //MATRIX A Input data fetching
        RSTN <= 0;
        IN_DATA <= {REGN{32'd5}};
        SEQ_A <= 4'd0;
        SEQ_B <= 4'dz;
        MATAB_MUX <= 1'd1;
        #(CLK_PERIOD*2) //MATRIX B Input data fetching
        RSTN <= 0;
        IN_DATA <= {REGN{32'd3}};
        SEQ_A <= 4'dz;
        SEQ_B <= 4'd0;
        MATAB_MUX <= 1'd0;
        #(CLK_PERIOD*5)
        $finish();
    end

endmodule