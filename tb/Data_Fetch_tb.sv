module Data_Fetch_tb ();
    timeunit 1ns/1ps;
    localparam CLK_PERIOD = 10;

    logic CLK=0;

    logic [31:0] addrb;
    logic [31:0] dinb;
    logic [31:0] doutb;
    logic enb;
    logic [3:0] web;

    logic [1:0] DIMEN;
    logic ADDR_START;
    logic ADDR_RST;
    logic [3:0] ADDRESS;
    logic FETCH_DONE;
    logic [1:0] PE_SEL;
    logic PE_SEL_2x2;
    logic PE_SEL_4;

    logic WRADDR_START;
    logic STORE_DONE;

    logic [31:0] PE_DIN_0;
    logic [31:0] PE_DIN_1;
    logic [31:0] PE_DIN_2;
    logic [31:0] PE_DIN_3;

    logic [31:0] PE_DOUT_0;
    logic [31:0] PE_DOUT_1;
    logic [31:0] PE_DOUT_2;
    logic [31:0] PE_DOUT_3;

    Data_Fetch dut (.*);

    initial forever #(CLK_PERIOD/2) CLK <= ~CLK;

    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
        
        @(posedge CLK); //Reset Testing
        #1
        ADDR_START <= 1'b0; 
        ADDR_RST <= 1'b1;
        PE_SEL <= 2'b00;
        DIMEN <= 2'b00;
        ADDRESS <= 4'd0;
        PE_SEL_2x2 <= 1'b0;
        PE_SEL_4 <= 1'b0;
        WRADDR_START <= 1'b0;
        #(CLK_PERIOD*1) 
        ADDR_START <= 1'b0; 
        ADDR_RST <= 1'b0;
        PE_SEL <= 2'b00;
        DIMEN <= 2'b00;
        ADDRESS <= 4'd0;
        PE_SEL_2x2 <= 1'b0;
        PE_SEL_4 <= 1'b0;
        WRADDR_START <= 1'b0;

        #(CLK_PERIOD*1) //LOAD //2x2
        ADDR_START <= 1'b1; 
        ADDR_RST <= 1'b0;
        PE_SEL <= 2'b00;
        DIMEN <= 2'b00;
        ADDRESS <= 4'd0;
        PE_SEL_2x2 <= 1'b0;
        PE_SEL_4 <= 1'b0;
        WRADDR_START <= 1'b0;
        doutb <= 32'd345;
        #(CLK_PERIOD*1)
        ADDR_RST <= 1'b1;

        #(CLK_PERIOD*1) //4x4
        ADDR_START <= 1'b1; 
        ADDR_RST <= 1'b0;
        PE_SEL <= 2'b01;
        DIMEN <= 2'b01;
        ADDRESS <= 4'd0;
        PE_SEL_2x2 <= 1'b0;
        PE_SEL_4 <= 1'b0;
        WRADDR_START <= 1'b0;
        doutb <= 32'd435;
        #(CLK_PERIOD*1) 
        ADDR_START <= 1'b1; 
        ADDR_RST <= 1'b0;
        PE_SEL <= 2'b01;
        DIMEN <= 2'b01;
        ADDRESS <= 4'd0;
        PE_SEL_2x2 <= 1'b1;
        PE_SEL_4 <= 1'b0;
        WRADDR_START <= 1'b0;
        doutb <= 32'd555;
        #(CLK_PERIOD*1) 
        ADDR_START <= 1'b1; 
        ADDR_RST <= 1'b0;
        PE_SEL <= 2'b01;
        DIMEN <= 2'b01;
        ADDRESS <= 4'd0;
        PE_SEL_2x2 <= 1'b0;
        PE_SEL_4 <= 1'b1;
        WRADDR_START <= 1'b0;
        doutb <= 32'd675;
        #(CLK_PERIOD*1) 
        ADDR_START <= 1'b1; 
        ADDR_RST <= 1'b1;
        PE_SEL <= 2'b01;
        DIMEN <= 2'b01;
        ADDRESS <= 4'd0;
        PE_SEL_2x2 <= 1'b1;
        PE_SEL_4 <= 1'b1;
        WRADDR_START <= 1'b0;
        doutb <= 32'd7575;

        #(CLK_PERIOD*1) //8x8
        ADDR_START <= 1'b1; 
        ADDR_RST <= 1'b0;
        PE_SEL <= 2'b10;
        DIMEN <= 2'b10;
        ADDRESS <= 4'd0;
        PE_SEL_2x2 <= 1'b1;
        PE_SEL_4 <= 1'b1;
        WRADDR_START <= 1'b0;
        doutb <= 32'd6875;
        #(CLK_PERIOD*1)
        ADDR_START <= 1'b1; 
        ADDR_RST <= 1'b0;
        PE_SEL <= 2'b10;
        DIMEN <= 2'b10;
        ADDRESS <= 4'd0;
        PE_SEL_2x2 <= 1'b0;
        PE_SEL_4 <= 1'b1;
        WRADDR_START <= 1'b0;
        doutb <= 32'd9675;
        #(CLK_PERIOD*1)
        ADDR_START <= 1'b1; 
        ADDR_RST <= 1'b0;
        PE_SEL <= 2'b11;
        DIMEN <= 2'b11;
        ADDRESS <= 4'd0;
        PE_SEL_2x2 <= 1'b1;
        PE_SEL_4 <= 1'b1;
        WRADDR_START <= 1'b0;
        doutb <= 32'd4675;
        #(CLK_PERIOD*1)
        ADDR_START <= 1'b1; 
        ADDR_RST <= 1'b0;
        PE_SEL <= 2'b11;
        DIMEN <= 2'b11;
        ADDRESS <= 4'd0;
        PE_SEL_2x2 <= 1'b0;
        PE_SEL_4 <= 1'b1;
        WRADDR_START <= 1'b0;
        doutb <= 32'd4675;
        #(CLK_PERIOD*1)

        #(CLK_PERIOD*1) //STORE
        ADDR_START <= 1'b1; 
        ADDR_RST <= 1'b0;
        PE_SEL <= 2'b00;
        DIMEN <= 2'b00;
        ADDRESS <= 4'd0;
        PE_SEL_2x2 <= 1'b0;
        PE_SEL_4 <= 1'b0;
        WRADDR_START <= 1'b1;
        doutb <= 32'dz;
        PE_DOUT_0 <= 32'd45;
        PE_DOUT_1 <= 32'd46;
        PE_DOUT_2 <= 32'd47;
        PE_DOUT_3 <= 32'd48;
        #(CLK_PERIOD*1) 
        ADDR_START <= 1'b1; 
        ADDR_RST <= 1'b0;
        PE_SEL <= 2'b01;
        DIMEN <= 2'b00;
        ADDRESS <= 4'd0;
        PE_SEL_2x2 <= 1'b0;
        PE_SEL_4 <= 1'b0;
        WRADDR_START <= 1'b1;
        doutb <= 32'dz;
        PE_DOUT_0 <= 32'd45;
        PE_DOUT_1 <= 32'd46;
        PE_DOUT_2 <= 32'd47;
        PE_DOUT_3 <= 32'd48;
        #(CLK_PERIOD*1) 
        ADDR_START <= 1'b1; 
        ADDR_RST <= 1'b0;
        PE_SEL <= 2'b10;
        DIMEN <= 2'b00;
        ADDRESS <= 4'd0;
        PE_SEL_2x2 <= 1'b0;
        PE_SEL_4 <= 1'b0;
        WRADDR_START <= 1'b1;
        doutb <= 32'dz;
        PE_DOUT_0 <= 32'd45;
        PE_DOUT_1 <= 32'd46;
        PE_DOUT_2 <= 32'd47;
        PE_DOUT_3 <= 32'd48;
        #(CLK_PERIOD*1) 
        ADDR_START <= 1'b1; 
        ADDR_RST <= 1'b0;
        PE_SEL <= 2'b11;
        DIMEN <= 2'b00;
        ADDRESS <= 4'd0;
        PE_SEL_2x2 <= 1'b0;
        PE_SEL_4 <= 1'b0;
        WRADDR_START <= 1'b1;
        doutb <= 32'dz;
        PE_DOUT_0 <= 32'd45;
        PE_DOUT_1 <= 32'd46;
        PE_DOUT_2 <= 32'd47;
        PE_DOUT_3 <= 32'd48;
        #(CLK_PERIOD*2)
        $finish();
    end

endmodule