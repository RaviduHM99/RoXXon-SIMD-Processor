module Top_PL_tb;
    timeunit 1ns/1ps;
    localparam CLK_PERIOD = 10;
    localparam N =512;

    logic CLK=0, RSTN=0;

    logic [31:0] addrb; // BRAM Ports
    logic [31:0] dinb;
    logic [31:0] doutb;
    logic enb;
    logic [3:0] web;

    logic [31:0] INSTR_AXI;
    logic [$clog2(N)-1:0] PC_AXI;

    logic START_SIGNAL; //GPIO
    logic STOP_SIGNAL;

    Top_PL dut (.*);

    initial forever begin
        #(CLK_PERIOD/2) CLK <= ~CLK;
    end

    initial begin
        $dumpfile("INSTR_AXI_Fetch_tb.vcd"); $dumpvars;
        @(posedge CLK); 
        #1 RSTN <= 1'b1;
        INSTR_AXI <= 32'd0;
        doutb <= 32'd0;
        START_SIGNAL <= 1'b0;

        #(CLK_PERIOD) 
        RSTN <= 0; 
        INSTR_AXI <= 32'd0;
        doutb <= 32'd0;


//////////// 2x2 Matrix Multiplication //////////// 
        #(CLK_PERIOD)  //LOAD A row 1 
        RSTN <= 0; 
        INSTR_AXI <= 32'b010001100100010; 
        START_SIGNAL <= 1'b1;

        #(CLK_PERIOD*3) 
        doutb <= 32'd25;
        #(CLK_PERIOD) 
        doutb <= 32'd29;

        #(CLK_PERIOD) //LOAD A row 2 
        INSTR_AXI <= 32'b000011100100010; 

        #(CLK_PERIOD*3) 
        doutb <= 32'd47;
        #(CLK_PERIOD) 
        doutb <= 32'd12;

        #(CLK_PERIOD)  //LOAD B row 1 
        RSTN <= 0; 
        INSTR_AXI <= 32'b010101110100011; 
        START_SIGNAL <= 1'b1;

        #(CLK_PERIOD*3) 
        doutb <= 32'd51;
        #(CLK_PERIOD) 
        doutb <= 32'd63;

        #(CLK_PERIOD) //LOAD B row 2 
        INSTR_AXI <= 32'b000111110100011; 

        #(CLK_PERIOD*3) 
        doutb <= 32'd97;
        #(CLK_PERIOD) 
        doutb <= 32'd13;

        #(CLK_PERIOD)  //MULTACC
        INSTR_AXI <= 32'b000000000000100; 

        #(CLK_PERIOD*5) //STORE
        INSTR_AXI <= 32'b001001000000101; 

        #(CLK_PERIOD*6) //STOP
        INSTR_AXI <= 32'b000000000000110; 

        #(CLK_PERIOD*10)
        $finish();
    end
    
endmodule