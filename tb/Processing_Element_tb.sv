module Processing_Element_tb;
    timeunit 1ns/1ps;
    localparam N = 16;
    localparam CLK_PERIOD = 10;

    logic CLK=0, RSTN=0;
    logic [N-1:0][31:0] DATAIN;
    logic MAC_CTRL, RST_MUL, INC_PC, MAT_MUX, WRITE_MAT;
    logic [$clog2(N)-1:0]PC_Counter;
    logic [31:0] DATAOUT;

    Processing_Element #(.N(N)) dut (.*);

    initial forever begin
        #(CLK_PERIOD/2) CLK <= ~CLK;
    end

    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
        #(CLK_PERIOD*2)
        @(posedge CLK);
        #1 RSTN <= 1; RST_MUL <= 1;
        #(CLK_PERIOD)
        RSTN <= 0; RST_MUL <= 0;
        MAT_MUX <= 0;
        INC_PC <= 0;
        MAC_CTRL <= 0;
        WRITE_MAT <= 1;
        DATAIN <= {32'd1, 32'd2, 32'd3, 32'd4, 32'd5, 32'd6, 32'd7, 32'd8, 32'd9, 32'd10, 32'd11, 32'd12, 32'd13, 32'd14, 32'd15, 32'd16};
        #(CLK_PERIOD*1)
        MAT_MUX <= 1;
        INC_PC <= 0;
        MAC_CTRL <= 0;
        WRITE_MAT <= 1;
        DATAIN <= {32'd1, 32'd2, 32'd3, 32'd4, 32'd5, 32'd6, 32'd7, 32'd8, 32'd9, 32'd10, 32'd11, 32'd12, 32'd13, 32'd14, 32'd15, 32'd16};
        #(CLK_PERIOD*1)
        MAT_MUX <= 0;
        INC_PC <= 1;
        MAC_CTRL <= 1;
        WRITE_MAT <= 0;
        DATAIN <= 'dx;
        #(CLK_PERIOD*16)
        MAT_MUX <= 0;
        INC_PC <= 0;
        MAC_CTRL <= 0;
        WRITE_MAT <= 0;
        DATAIN <= 'dx;
        #(CLK_PERIOD*3)
        $finish();
    end
    
endmodule