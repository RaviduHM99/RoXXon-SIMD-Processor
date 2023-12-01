`timescale 1ns/1ps

module Data_Fetch(
    input logic CLK,

    output logic [31:0] addrb, // BRAM Ports
    output logic [31:0] dinb,
    input logic [31:0] doutb,
    output logic enb,
    output logic [3:0] web,

    input logic [1:0] DIMEN, // DATA FETCH LOAD
    input logic ADDR_START,
    input logic ADDR_RST,
    input logic [3:0] ADDRESS,
    output logic FETCH_DONE,
    input logic [1:0] PE_SEL,
    input logic PE_SEL_2x2,
    input logic PE_SEL_4,

    input logic WRADDR_START, // DATA FETCH STORE
    output logic STORE_DONE,

    output logic [31:0] PE_DIN_0,
    output logic [31:0] PE_DIN_1,
    output logic [31:0] PE_DIN_2,
    output logic [31:0] PE_DIN_3,

    input logic [31:0] PE_DOUT_0,
    input logic [31:0] PE_DOUT_1,
    input logic [31:0] PE_DOUT_2,
    input logic [31:0] PE_DOUT_3

);
    reg [31:0] ADDR;
    logic ADDR_INC;
    always @(posedge CLK) begin
        if (ADDR_RST) ADDR <= 'b0;
        else ADDR <= (ADDR_INC) ? ADDR + 'b1 : ADDR; /////Clock Latency from BRAM
    end

    always_comb begin
        unique case (DIMEN)
            2'd0 : begin
                ADDR_INC = (ADDR_START) ? 1'b1 : 1'b0;
                FETCH_DONE = (ADDR == 4'd1) ? 1'b1 : 1'b0;
            end
            2'd1 : begin
                ADDR_INC = (ADDR_START) ? 1'b1 : 1'b0;
                FETCH_DONE = (ADDR == 4'd3) ? 1'b1 : 1'b0;
            end
            2'd2 : begin
                ADDR_INC = (ADDR_START) ? 1'b1 : 1'b0;
                FETCH_DONE = (ADDR == 4'd7) ? 1'b1 : 1'b0;
            end
            2'd3 : begin
                ADDR_INC = (ADDR_START) ? 1'b1 : 1'b0;
                FETCH_DONE = (ADDR == 4'd15) ? 1'b1 : 1'b0;
            end 
        endcase

    end

    logic [31:0] DATA_PE_IN;
    logic [31:0] DATA_PE_OUT;

    assign addrb = ADDRESS + ADDR;
    assign dinb = (WRADDR_START) ? DATA_PE_OUT : 32'd0;
    assign DATA_PE_IN = doutb; 
    assign enb = 1'b1; 
    assign web = (WRADDR_START) ? 3'b111 : 3'b0; // store check web datasheet

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
                    PE_DIN_1 = 32'dz;
                    PE_DIN_2 = 32'dz;
                    PE_DIN_3 = 32'dz;
                end
                else if  (~PE_SEL_4 & PE_SEL_2x2)  begin
                    PE_DIN_0 = 32'dz;
                    PE_DIN_1 = DATA_PE_IN;
                    PE_DIN_2 = 32'dz;
                    PE_DIN_3 = 32'dz;
                end
                else if  (PE_SEL_4 & ~PE_SEL_2x2)  begin
                    PE_DIN_0 = 32'dz;
                    PE_DIN_1 = 32'dz;
                    PE_DIN_2 = DATA_PE_IN;
                    PE_DIN_3 = 32'dz;
                end
                else begin
                    PE_DIN_0 = 32'dz;
                    PE_DIN_1 = 32'dz;
                    PE_DIN_2 = 32'dz;
                    PE_DIN_3 = DATA_PE_IN;
                end
            end
            2'd2: begin // 2x2 LOADA
                if (PE_SEL_2x2) begin
                    PE_DIN_0 = DATA_PE_IN;
                    PE_DIN_1 = DATA_PE_IN;
                    PE_DIN_2 = 32'dz;
                    PE_DIN_3 = 32'dz;
                end
                else begin
                    PE_DIN_0 = 32'dz;
                    PE_DIN_1 = 32'dz;
                    PE_DIN_2 = DATA_PE_IN;
                    PE_DIN_3 = DATA_PE_IN;
                end 
            end
            2'd3: begin  // 2x2 LOADB
                if (PE_SEL_2x2) begin
                    PE_DIN_0 = DATA_PE_IN;
                    PE_DIN_1 = 32'dz;
                    PE_DIN_2 = DATA_PE_IN;
                    PE_DIN_3 = 32'dz;
                end 
                else begin
                    PE_DIN_0 = 32'dz;
                    PE_DIN_1 = DATA_PE_IN;
                    PE_DIN_2 = 32'dz;
                    PE_DIN_3 = DATA_PE_IN;
                end
            end
        endcase
    end

    assign STORE_DONE = (ADDR == 4'd3) ? 1'b1 : 1'b0;

    always_comb begin
        unique case (PE_SEL) //This is a problem now need 4 instructions of STORE
            2'd0 : DATA_PE_OUT = PE_DOUT_0;
            2'd1 : DATA_PE_OUT = PE_DOUT_1;
            2'd2 : DATA_PE_OUT = PE_DOUT_2;
            2'd3 : DATA_PE_OUT = PE_DOUT_3;
        endcase
    end

endmodule