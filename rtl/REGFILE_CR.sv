`timescale 1ns/1ps

module REGFILE_CR #(
    parameter N = 16, REGN = 512, B_START = 256
)(
    input logic CLK, RSTN,
    input logic [N-1:0][31:0] IN_DATA, //warning 
    input logic [REGN/2-1:0][31:0] IN_INS,
    input logic [$clog2(N)-1:0] SEQ_DATC,
    input logic [$clog2(REGN/2)-1:0] SEQ_INS,
    output logic [31:0] INS_OUT,
    output logic [N-1:0][31:0] MAT_IN
);
    reg [REGN-1:0][31:0] AXI_SLAVE_REG;
    logic [N-1:0][31:0] MATC_OUT;
    
    always_ff @( posedge CLK ) begin
        if (RSTN) AXI_SLAVE_REG <= {REGN{32'd0}};
        else begin
            unique case (SEQ_DATC) // this cant be params
                4'd0: AXI_SLAVE_REG[15:0] <= IN_DATA;
                4'd1: AXI_SLAVE_REG[31:16] <= IN_DATA;
                4'd2: AXI_SLAVE_REG[47:32] <= IN_DATA;
                4'd3: AXI_SLAVE_REG[63:48] <= IN_DATA;
                4'd4: AXI_SLAVE_REG[79:64] <= IN_DATA;
                4'd5: AXI_SLAVE_REG[95:80] <= IN_DATA;
                4'd6: AXI_SLAVE_REG[111:96] <= IN_DATA;
                4'd7: AXI_SLAVE_REG[127:112] <= IN_DATA;
                4'd8: AXI_SLAVE_REG[143:128] <= IN_DATA;
                4'd9: AXI_SLAVE_REG[159:144] <= IN_DATA;
                4'd10: AXI_SLAVE_REG[175:160] <= IN_DATA;
                4'd11: AXI_SLAVE_REG[191:176] <= IN_DATA;
                4'd12: AXI_SLAVE_REG[207:192] <= IN_DATA;
                4'd13: AXI_SLAVE_REG[223:208] <= IN_DATA;
                4'd14: AXI_SLAVE_REG[239:224] <= IN_DATA;
                4'd15: AXI_SLAVE_REG[255:240] <= IN_DATA;
            endcase
            AXI_SLAVE_REG[REGN-1:REGN/2] <= IN_INS;
        end
    end

    always_comb begin
        unique case (SEQ_DATC) // this cant be params
                4'd0: MATC_OUT = AXI_SLAVE_REG[15:0];
                4'd1: MATC_OUT = AXI_SLAVE_REG[31:16];
                4'd2: MATC_OUT = AXI_SLAVE_REG[47:32];
                4'd3: MATC_OUT = AXI_SLAVE_REG[63:48];
                4'd4: MATC_OUT = AXI_SLAVE_REG[79:64];
                4'd5: MATC_OUT = AXI_SLAVE_REG[95:80];
                4'd6: MATC_OUT = AXI_SLAVE_REG[111:96];
                4'd7: MATC_OUT = AXI_SLAVE_REG[127:112];
                4'd8: MATC_OUT = AXI_SLAVE_REG[143:128];
                4'd9: MATC_OUT = AXI_SLAVE_REG[159:144];
                4'd10: MATC_OUT = AXI_SLAVE_REG[175:160];
                4'd11: MATC_OUT = AXI_SLAVE_REG[191:176];
                4'd12: MATC_OUT = AXI_SLAVE_REG[207:192];
                4'd13: MATC_OUT = AXI_SLAVE_REG[223:208];
                4'd14: MATC_OUT = AXI_SLAVE_REG[239:224];
                4'd15: MATC_OUT = AXI_SLAVE_REG[255:240];
        endcase            
    end

    assign INS_OUT = AXI_SLAVE_REG[SEQ_INS + B_START];
    assign MAT_IN = MATC_OUT;
endmodule