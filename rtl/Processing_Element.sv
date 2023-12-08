`timescale 1ns/1ps

module Processing_Element #(
    parameter N = 16
)
(
    input logic CLK,

    input logic RST_ADD,
    input logic [31:0] DATAIN,

    input logic MAC_CTRL,
    input logic RST_ACC,
    input logic RST_PC,

    input logic MAT_MUX,
    input logic WRITE_MAT,
    input logic [1:0] DIMEN,
    input logic OUT_READY,

    output logic MAC_DONE,
    output logic [31:0] DATAOUT
);

    reg [N-1:0][31:0] MATA;
    reg [N-1:0][31:0] MATB;
    reg [31:0] ACC_DATA;
    reg [$clog2(N)-1:0] PC;
    reg [$clog2(N)-1:0] ADDR;

    initial begin
        MATA[0] <= 'd0; MATA[1] <= 'd0; MATA[2] <= 'd0; MATA[3] <= 'd0; MATA[4] <= 'd0; MATA[5] <= 'd0; MATA[6] <= 'd0; MATA[7] <= 'd0; MATA[8] <= 'd0; MATA[9] <= 'd0; MATA[10] <= 'd0; MATA[11] <= 'd0; MATA[12] <= 'd0; MATA[13] <= 'd0; MATA[14] <= 'd0; MATA[15] <= 'd0;
        MATB[0] <= 'd0; MATB[1] <= 'd0; MATB[2] <= 'd0; MATB[3] <= 'd0; MATB[4] <= 'd0; MATB[5] <= 'd0; MATB[6] <= 'd0; MATB[7] <= 'd0; MATB[8] <= 'd0; MATB[9] <= 'd0; MATB[10] <= 'd0; MATB[11] <= 'd0; MATB[12] <= 'd0; MATB[13] <= 'd0; MATB[14] <= 'd0; MATB[15] <= 'd0;
    end

    logic INC_PC;
    always @(posedge CLK) begin
        if (RST_PC) PC <= 'b0;
        else PC <= (INC_PC) ? PC + 'b1 : PC;
    end

    always_ff @( posedge CLK ) begin 
        if (RST_ADD) ADDR <= 'd0;
        else ADDR <= (WRITE_MAT & ~WRITE_DONE) ? ADDR + 1'd1 : ADDR;
    end

    always @(posedge CLK) begin
        if (WRITE_MAT & ~WRITE_DONE) begin
            MATA[ADDR] <= (MAT_MUX) ? DATAIN : MATA[ADDR];
            MATB[ADDR] <= (MAT_MUX) ? MATB[ADDR] : DATAIN;
        end
        else begin
            MATA[ADDR] <= MATA[ADDR];
            MATB[ADDR] <= MATB[ADDR];
        end
    end
  
    ///// MAC Module /////
    wire [31:0] MUL_DATA;

    assign MUL_DATA = (MAC_CTRL) ? MATA[PC]*MATB[PC] : 'd0;

    always_ff @(posedge CLK) begin
        if (RST_ACC) ACC_DATA <= 32'd0;
        else ACC_DATA <= (MAC_CTRL) ? ACC_DATA + MUL_DATA : ACC_DATA;
    end
    
    assign DATAOUT = (OUT_READY) ? ACC_DATA : 32'dz;

    logic WRITE_DONE;
    always_comb begin
        unique case (DIMEN)
            2'd0 : begin
                INC_PC = (MAC_CTRL) ? 1'b1 : 1'b0;
                MAC_DONE = (PC == 4'd1) ? 1'b1 : 1'b0;
                WRITE_DONE = (ADDR == 4'd2) ? 1'b1 : 1'b0;
            end
            2'd1 : begin
                INC_PC = (MAC_CTRL) ? 1'b1 : 1'b0;
                MAC_DONE = (PC == 4'd3) ? 1'b1 : 1'b0;
                WRITE_DONE = (ADDR == 4'd4) ? 1'b1 : 1'b0;
            end
            2'd2 : begin
                INC_PC = (MAC_CTRL) ? 1'b1 : 1'b0;
                MAC_DONE = (PC == 4'd7) ? 1'b1 : 1'b0;
                WRITE_DONE = (ADDR == 4'd8) ? 1'b1 : 1'b0;
            end
            2'd3 : begin
                INC_PC = (MAC_CTRL) ? 1'b1 : 1'b0;
                MAC_DONE = (PC == 4'd15) ? 1'b1 : 1'b0;
                WRITE_DONE = (ADDR == 4'd16) ? 1'b1 : 1'b0;
            end      
        endcase
    end
    
endmodule