`timescale 1ns/1ps

module Data_Fetch(
    input logic CLK,
    //input logic RSTN,

    output logic [12:0] addrb, // BRAM Ports
    output logic [31:0] dinb,
    input logic [31:0] doutb,
    output logic enb,
    output logic [3:0] web,

    input logic [1:0] DIMEN, // DATA FETCH LOAD
    input logic ADDR_START,
    input logic ADDR_RST,
    input logic [16:0] ADDRESS,
    output logic FETCH_DONE,
    input logic [1:0] PE_SEL,
    input logic PE_SEL_2x2,
    input logic PE_SEL_4,

    input logic WRADDR_START, // DATA FETCH STORE
    output logic STORE_DONE,

    output logic [2:0] latency_counter, // READ latency for PE

    output logic [31:0] PE_DIN_0,
    output logic [31:0] PE_DIN_1,
    output logic [31:0] PE_DIN_2,
    output logic [31:0] PE_DIN_3,

    input logic [31:0] PE_DOUT_0,
    input logic [31:0] PE_DOUT_1,
    input logic [31:0] PE_DOUT_2,
    input logic [31:0] PE_DOUT_3

);

    reg [2:0] latency_counter_DF;
    logic latency_rst;
    logic latency_incr;
    reg [31:0] ADDR;
    logic ADDR_INC;

    assign latency_rst = (latency_counter_DF == 3'd2) ? 1'b1 : 1'b0;
    assign latency_incr = (ADDR_INC) ? 1'b1 : 1'b0;

    always_ff @( posedge CLK ) begin 
        if (latency_rst | ADDR_RST) latency_counter_DF <= 'd0;
        else latency_counter_DF <= (latency_incr) ? latency_counter_DF + 1'd1 : latency_counter_DF;
    end 

    assign latency_counter = latency_counter_DF;

    always @(posedge CLK) begin
        if (ADDR_RST) ADDR <= 'b0;
        else ADDR <= (ADDR_INC & (latency_counter_DF == 3'd2 | WRADDR_START)) ? ADDR + 'b1 : ADDR; /////Clock Latency from BRAM
    end

    always_comb begin
        unique case (DIMEN)
            2'd0 : begin //2x2
                ADDR_INC = (ADDR_START) ? 1'b1 : 1'b0;
                FETCH_DONE = (ADDR == 32'd2 & ~WRADDR_START) ? 1'b1 : 1'b0;
            end
            2'd1 : begin //4x4
                ADDR_INC = (ADDR_START) ? 1'b1 : 1'b0;
                FETCH_DONE = (ADDR == 32'd4 & ~WRADDR_START) ? 1'b1 : 1'b0;
            end 
            2'd2 : begin //8x8
                ADDR_INC = (ADDR_START) ? 1'b1 : 1'b0;
                FETCH_DONE = (ADDR == 32'd8 & ~WRADDR_START) ? 1'b1 : 1'b0;
            end
            2'd3 : begin //16x16, 32x32, ....
                ADDR_INC = (ADDR_START) ? 1'b1 : 1'b0;
                FETCH_DONE = (ADDR == 32'd16 & ~WRADDR_START) ? 1'b1 : 1'b0;
            end 
        endcase

    end

    logic [31:0] DATA_PE_IN;
    logic [3:0][31:0] DATA_PE_OUT;

    logic [16:0] IN_ADDRESS;
    assign IN_ADDRESS = ADDRESS + ADDR;
    assign addrb = IN_ADDRESS[12:0];

    assign dinb = (WRADDR_START) ? DATA_PE_OUT[ADDR] : 32'd0;
    assign DATA_PE_IN = (ADDR_START) ? doutb : 32'd0; 
    assign enb = (ADDR_START | WRADDR_START) ? 1'b1 : 1'b0; 
    assign web = (WRADDR_START) ? 4'b1111 : 4'b0; ////// store check web datasheet ///////

    always_comb begin
        unique case (PE_SEL)
            2'd0: begin
                PE_DIN_0 = DATA_PE_IN;
                PE_DIN_1 = DATA_PE_IN;
                PE_DIN_2 = DATA_PE_IN;
                PE_DIN_3 = DATA_PE_IN;
            end
            2'd1: begin
                if (~PE_SEL_4 & ~PE_SEL_2x2) begin
                    PE_DIN_0 = DATA_PE_IN;
                    PE_DIN_1 = 32'd0;
                    PE_DIN_2 = 32'd0;
                    PE_DIN_3 = 32'd0;
                end
                else if  (~PE_SEL_4 & PE_SEL_2x2)  begin
                    PE_DIN_0 = 32'd0;
                    PE_DIN_1 = DATA_PE_IN;
                    PE_DIN_2 = 32'd0;
                    PE_DIN_3 = 32'd0;
                end
                else if  (PE_SEL_4 & ~PE_SEL_2x2)  begin
                    PE_DIN_0 = 32'd0;
                    PE_DIN_1 = 32'd0;
                    PE_DIN_2 = DATA_PE_IN;
                    PE_DIN_3 = 32'd0;
                end
                else begin
                    PE_DIN_0 = 32'd0;
                    PE_DIN_1 = 32'd0;
                    PE_DIN_2 = 32'd0;
                    PE_DIN_3 = DATA_PE_IN;
                end
            end
            2'd2: begin // 2x2 LOADA
                if (PE_SEL_2x2) begin
                    PE_DIN_0 = DATA_PE_IN;
                    PE_DIN_1 = DATA_PE_IN;
                    PE_DIN_2 = 32'd0;
                    PE_DIN_3 = 32'd0;
                end
                else begin
                    PE_DIN_0 = 32'd0;
                    PE_DIN_1 = 32'd0;
                    PE_DIN_2 = DATA_PE_IN;
                    PE_DIN_3 = DATA_PE_IN;
                end 
            end
            2'd3: begin  // 2x2 LOADB
                if (PE_SEL_2x2) begin
                    PE_DIN_0 = DATA_PE_IN;
                    PE_DIN_1 = 32'd0;
                    PE_DIN_2 = DATA_PE_IN;
                    PE_DIN_3 = 32'd0;
                end 
                else begin
                    PE_DIN_0 = 32'd0;
                    PE_DIN_1 = DATA_PE_IN;
                    PE_DIN_2 = 32'd0;
                    PE_DIN_3 = DATA_PE_IN;
                end
            end
        endcase
    end

    assign STORE_DONE = (ADDR == 32'd2 & WRADDR_START) ? 1'b1 : 1'b0;
    assign DATA_PE_OUT = {PE_DOUT_3, PE_DOUT_2, PE_DOUT_1, PE_DOUT_0};


endmodule