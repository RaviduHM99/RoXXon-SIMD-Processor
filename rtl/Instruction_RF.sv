`timescale 1ns/1ps

module Instruction_RF #(
    parameter N = 512
)(
    input logic CLK,

    output logic [31:0] INSTR_AXI,
    input logic [$clog2(N)-1:0] PC_AXI

);

    reg [16:0][31:0] AXI_SLAVE_REG;

    initial begin
        AXI_SLAVE_REG[0] <= 32'b0001010001100000010;
        AXI_SLAVE_REG[1] <= 32'b0011000011100000010;
        AXI_SLAVE_REG[2] <= 32'b0101010101110000011;
        AXI_SLAVE_REG[3] <= 32'b0111000111110000011;
        AXI_SLAVE_REG[4] <= 32'b0000000000000000100;
        AXI_SLAVE_REG[5] <= 32'b1001001001000000101;
        AXI_SLAVE_REG[6] <= 32'b0000000000000000110;
        AXI_SLAVE_REG[7] <= 32'b0;
        AXI_SLAVE_REG[8] <= 32'b0;
        AXI_SLAVE_REG[9] <= 32'b0;
        AXI_SLAVE_REG[10] <= 32'b0;
        AXI_SLAVE_REG[11] <= 32'b0;
        AXI_SLAVE_REG[12] <= 32'b0;
        AXI_SLAVE_REG[13] <= 32'b0;
        AXI_SLAVE_REG[14] <= 32'b0;
        AXI_SLAVE_REG[15] <= 32'b0;
        AXI_SLAVE_REG[16] <= 32'b0;
    end


    assign INSTR_AXI = AXI_SLAVE_REG[PC_AXI];

endmodule