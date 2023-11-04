`timescale 1ns/1ps

module REGFILE_AB #(
    parameter N = 16, REGN = 512, B_START = 256
)(
    input logic CLK, RSTN,
    input logic [REGN-1:0][31:0] IN_DATA, //warning 
    input logic [$clog2(N)-1:0] SEQ_A,
    input logic [$clog2(N)-1:0] SEQ_B,
    input logic MATAB_MUX,
    output logic [N-1:0][31:0] MAT_IN
);
    reg [REGN-1:0][31:0] AXI_SLAVE_REG;
    logic [N-1:0][31:0] MAT_INA;
    logic [N-1:0][31:0] MAT_INB;

    always_ff @( posedge CLK ) begin
        if (RSTN) AXI_SLAVE_REG <= {REGN{32'd0}};
        else AXI_SLAVE_REG <= IN_DATA;
    end

    always_comb begin
        unique case (SEQ_A) // this cant be params
                4'd0: MAT_INA = AXI_SLAVE_REG[15:0];
                4'd1: MAT_INA = AXI_SLAVE_REG[31:16];
                4'd2: MAT_INA = AXI_SLAVE_REG[47:32];
                4'd3: MAT_INA = AXI_SLAVE_REG[63:48];
                4'd4: MAT_INA = AXI_SLAVE_REG[79:64];
                4'd5: MAT_INA = AXI_SLAVE_REG[95:80];
                4'd6: MAT_INA = AXI_SLAVE_REG[111:96];
                4'd7: MAT_INA = AXI_SLAVE_REG[127:112];
                4'd8: MAT_INA = AXI_SLAVE_REG[143:128];
                4'd9: MAT_INA = AXI_SLAVE_REG[159:144];
                4'd10: MAT_INA = AXI_SLAVE_REG[175:160];
                4'd11: MAT_INA = AXI_SLAVE_REG[191:176];
                4'd12: MAT_INA = AXI_SLAVE_REG[207:192];
                4'd13: MAT_INA = AXI_SLAVE_REG[223:208];
                4'd14: MAT_INA = AXI_SLAVE_REG[239:224];
                4'd15: MAT_INA = AXI_SLAVE_REG[255:240];
                default: MAT_INA = 'dz;
        endcase
        unique case (SEQ_B) // this cant be params
                4'd0: MAT_INB = AXI_SLAVE_REG[15+B_START:0+B_START];
                4'd1: MAT_INB = AXI_SLAVE_REG[31+B_START:16+B_START];
                4'd2: MAT_INB = AXI_SLAVE_REG[47+B_START:32+B_START];
                4'd3: MAT_INB = AXI_SLAVE_REG[63+B_START:48+B_START];
                4'd4: MAT_INB = AXI_SLAVE_REG[79+B_START:64+B_START];
                4'd5: MAT_INB = AXI_SLAVE_REG[95+B_START:80+B_START];
                4'd6: MAT_INB = AXI_SLAVE_REG[111+B_START:96+B_START];
                4'd7: MAT_INB = AXI_SLAVE_REG[127+B_START:112+B_START];
                4'd8: MAT_INB = AXI_SLAVE_REG[143+B_START:128+B_START];
                4'd9: MAT_INB = AXI_SLAVE_REG[159+B_START:144+B_START];
                4'd10: MAT_INB = AXI_SLAVE_REG[175+B_START:160+B_START];
                4'd11: MAT_INB = AXI_SLAVE_REG[191+B_START:176+B_START];
                4'd12: MAT_INB = AXI_SLAVE_REG[207+B_START:192+B_START];
                4'd13: MAT_INB = AXI_SLAVE_REG[223+B_START:208+B_START];
                4'd14: MAT_INB = AXI_SLAVE_REG[239+B_START:224+B_START];
                4'd15: MAT_INB = AXI_SLAVE_REG[255+B_START:240+B_START];
                default: MAT_INA = 'dz;
        endcase            
    end

    assign MAT_IN = (MATAB_MUX) ? MAT_INA : MAT_INB;
endmodule