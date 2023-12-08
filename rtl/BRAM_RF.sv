`timescale 1ns/1ps

module BRAM_RF(
    input logic CLK,

    input logic [31:0] addrb, // BRAM Ports
    input logic [31:0] dinb,
    output logic [31:0] doutb,
    input logic enb,
    input logic [3:0] web

);

    reg [47:0][31:0] BRAM;

    initial begin
        BRAM[0] <= 32'd15;
        BRAM[1] <= 32'd20;
        BRAM[2] <= 32'd42;
        BRAM[3] <= 32'd65;
        BRAM[4] <= 32'd98;
        BRAM[5] <= 32'd56;
        BRAM[6] <= 32'd24;
        BRAM[7] <= 32'd78;
        BRAM[8] <= 32'd91;
        BRAM[9] <= 32'd97;
        BRAM[10] <= 32'd33;
        BRAM[11] <= 32'd62;
        BRAM[12] <= 32'd57;
        BRAM[13] <= 32'd23;
        BRAM[14] <= 32'd19;
        BRAM[15] <= 32'd7;

        BRAM[16] <= 32'd48;
        BRAM[17] <= 32'd35;
        BRAM[18] <= 32'd33;
        BRAM[19] <= 32'd49;
        BRAM[20] <= 32'd95;
        BRAM[21] <= 32'd24;
        BRAM[22] <= 32'd2;
        BRAM[23] <= 32'd67;
        BRAM[24] <= 32'd87;
        BRAM[25] <= 32'd18;
        BRAM[26] <= 32'd89;
        BRAM[27] <= 32'd77;
        BRAM[28] <= 32'd62;
        BRAM[29] <= 32'd29;
        BRAM[30] <= 32'd15;
        BRAM[31] <= 32'd1;

        BRAM[32] <= 32'd0;
        BRAM[33] <= 32'd0;
        BRAM[34] <= 32'd0;
        BRAM[35] <= 32'd0;
        BRAM[36] <= 32'd0;
        BRAM[37] <= 32'd0;
        BRAM[38] <= 32'd0;
        BRAM[39] <= 32'd0;
        BRAM[40] <= 32'd0;
        BRAM[41] <= 32'd0;
        BRAM[42] <= 32'd0;
        BRAM[43] <= 32'd0;
        BRAM[44] <= 32'd0;
        BRAM[45] <= 32'd0;
        BRAM[46] <= 32'd0;
        BRAM[47] <= 32'd0;
    end

    always_ff @( posedge CLK ) begin
        BRAM[addrb] <= (web == 3'b111) ? dinb : BRAM[addrb]; 
    end

    assign doutb = (enb) ? BRAM[addrb] : 32'd0;

endmodule