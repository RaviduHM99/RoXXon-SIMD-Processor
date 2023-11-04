`timescale 1ns/1ps  
module Control_Unit #(
    parameter N = 16, REGN = 512, LogN = $clog2(N)
)(
    input logic CLK, RSTN,

    output logic MATAB_MUX, DONE, DOUT_MUX, //DONE_DATAB, //FETCH Unit
    //input logic [$clog2(REGN/2) - 1:0] PC_INS,
    output logic [LogN-1:0] SEQ_B,
    input logic [31:0] INSTR,

    output logic [N-1:0] MAC_CTRL, RST_MUL, INC_PC, MAT_MUX, WRITE_MAT, //16 PEs
    input logic [LogN-1:0] PC_Counter,

    //output logic MATAB_MUX, //REGFILE_AB
    output logic [LogN-1:0] SEQ_A,

    output logic [LogN-1:0] SEQ_DATC, //REGFILE_CR
    //output logic [$clog2(REGN/2)-1:0] SEQ_INS, // connect to PC_INS

    input logic ONSWT, //AXI GPIO logic should added here
    output logic OFFSWT
);
    enum  { IDLE, FETCHB, FETCHA, MATMUL, STORE } state, next_state;
    reg [LogN-1:0] ADDR_C;
    logic [N-1:0] MATB_PE;

    always_comb unique case (INSTR[2:0])
        3'd0: next_state = IDLE;
        3'd1: next_state = (ONSWT) ? FETCHB : IDLE;
        3'd2: next_state = (ONSWT) ? FETCHA : IDLE;
        3'd3: next_state = (ONSWT) ? MATMUL : IDLE;
        3'd4: next_state = (ONSWT) ? STORE : IDLE;
    endcase

    always_comb unique case (INSTR[6:3])
        4'd0: MATB_PE = 'b1000000000000000;
        4'd1: MATB_PE = 'b0100000000000000;
        4'd2: MATB_PE = 'b0010000000000000;
        4'd3: MATB_PE = 'b0001000000000000;
        4'd4: MATB_PE = 'b0000100000000000;
        4'd5: MATB_PE = 'b0000010000000000;
        4'd6: MATB_PE = 'b0000001000000000;
        4'd7: MATB_PE = 'b0000000100000000;
        4'd8: MATB_PE = 'b0000000010000000;
        4'd9: MATB_PE = 'b0000000001000000;
        4'd10: MATB_PE = 'b0000000000100000;
        4'd11: MATB_PE = 'b0000000000010000;
        4'd12: MATB_PE = 'b0000000000001000;
        4'd13: MATB_PE = 'b0000000000000100;
        4'd14: MATB_PE = 'b0000000000000010;
        4'd15: MATB_PE = 'b0000000000000001;
    endcase

    always_ff @( posedge CLK ) begin 
        if (RSTN) ADDR_C <= 'd0;
        else ADDR_C <= (state === FETCHA) ? INSTR[6:3] : ADDR_C;
    end

    always_ff @( posedge CLK ) begin
        if (RSTN) state <= IDLE;
        else
            unique case (state)
                IDLE : begin
                    MATAB_MUX <= 1'b1;
                    DONE <= (ONSWT) ? 1'b1 : 1'b0;
                    DOUT_MUX <= 1'b0;
                    //DONE_DATAB <= 1'b0;
                    SEQ_B <= 'dz;

                    MAC_CTRL <= 'b0000000000000000;
                    RST_MUL <= 'b1111111111111111;
                    INC_PC <= 'b0000000000000000;
                    MAT_MUX <= 'b0000000000000000;
                    WRITE_MAT <= 'b0000000000000000;

                    MATAB_MUX <= 1'b0;
                    SEQ_A <= 'dz;

                    SEQ_DATC <= ADDR_C;
                    //SEQ_INS <=

                    OFFSWT <= (INSTR[7] == 1'b1) ? 1'b1 : 1'b0;
                    state <= next_state;
                end

                FETCHB : begin
                    MATAB_MUX <= 1'b0;
                    DONE <= 1'b1; ////////////////////////////
                    DOUT_MUX <= 1'b0;
                    //DONE_DATAB <= 1'b1;
                    SEQ_B <= INSTR[6:3];

                    MAC_CTRL <= 'b0000000000000000;
                    RST_MUL <= 'b0000000000000000; 
                    INC_PC <= 'b0000000000000000;
                    MAT_MUX <= 'b0000000000000000;
                    WRITE_MAT <= MATB_PE; 

                    MATAB_MUX <= 1'b0;
                    SEQ_A <= 'dz;

                    SEQ_DATC <= ADDR_C;
                    //SEQ_INS <=

                    OFFSWT <= 1'b0;
                    state <= next_state;
                end

                FETCHA : begin
                    MATAB_MUX <= 1'b1;
                    DONE <= 1'b1; /////////////////////////
                    DOUT_MUX <= 1'b0;
                    //DONE_DATAB <= 1'b0;
                    SEQ_B <= 'dz;

                    MAC_CTRL <= 'b0000000000000000;
                    RST_MUL <= 'b0000000000000000;
                    INC_PC <= 'b0000000000000000;
                    MAT_MUX <= 'b1111111111111111;
                    WRITE_MAT <= 'b1111111111111111;

                    MATAB_MUX <= 1'b1;
                    SEQ_A <= ADDR_C;

                    SEQ_DATC <= ADDR_C;
                    //SEQ_INS <=

                    OFFSWT <= 1'b0;
                    state <= next_state;
                end

                MATMUL : begin
                    MATAB_MUX <= 1'b1;

                    DOUT_MUX <= 1'b0;
                    //DONE_DATAB <= 1'b0;
                    SEQ_B <= 'dz;

                    MAC_CTRL <= 'b1111111111111111;
                    RST_MUL <= 'b0000000000000000;
                    INC_PC <= 'b1111111111111111;
                    MAT_MUX <= 'b0000000000000000;
                    WRITE_MAT <= 'b0000000000000000;

                    MATAB_MUX <= 1'b0;
                    SEQ_A <= 'dz;

                    SEQ_DATC <= ADDR_C;
                    //SEQ_INS <=

                    OFFSWT <= 1'b0;
                    if (PC_Counter == 'd15) begin
                        DONE <= 1'b1;
                        state <= next_state;
                    end
                    else begin
                        state <= MATMUL;
                    end
                end

                STORE : begin
                    MATAB_MUX <= 1'b1;
                    DONE <= 1'b1;
                    DOUT_MUX <= 1'b1;
                    //DONE_DATAB <= 1'b0;
                    SEQ_B <= 'dz;

                    MAC_CTRL <= 'b0000000000000000;
                    RST_MUL <= 'b1111111111111111;
                    INC_PC <= 'b0000000000000000;
                    MAT_MUX <= 'b0000000000000000;
                    WRITE_MAT <= 'b0000000000000000;

                    MATAB_MUX <= 1'b0;
                    SEQ_A <= 'dz;

                    SEQ_DATC <= ADDR_C;
                    //SEQ_INS <=

                    OFFSWT <= 1'b0;
                    state <= next_state;
                end
            endcase
    end

endmodule