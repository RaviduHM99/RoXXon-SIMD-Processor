`timescale 1ns/1ps

module Control_Unit(
    input logic CLK, RSTN,

    input logic [31:0] INSTR, // INST FETCH
    output logic PC_INCR,
    output logic INSTR_DONE, 

    output logic [3:0] RST_ADD, // PE
    output logic [3:0] MAC_CTRL,
    output logic [3:0] RST_ACC,
    output logic [3:0] RST_PC,
    output logic [3:0] MAT_MUX,
    output logic [3:0] WRITE_MAT,
    output logic [3:0] OUT_READY,
    input logic MAC_DONE, //AND All MAC DONE in top module

    output logic [1:0] DIMEN, // DATA FETCH LOAD
    output logic ADDR_START,
    output logic ADDR_RST,
    output logic [3:0] ADDRESS,
    input logic FETCH_DONE,
    output logic [1:0] PE_SEL,
    output logic PE_SEL_2x2,
    output logic PE_SEL_4,

    output logic WRADDR_START, // DATA FETCH STORE
    input logic STORE_DONE,

    input logic START_SIGNAL, //GPIO
    output logic STOP_SIGNAL
);

enum logic [2:0] { IDLE, FETCH, LOADA, LOADB, MULTACC, STORE, STOP} STATE, NEXT_STATE;

logic [3:0] LOAD_COUNTA;

always_comb begin
    unique case (INSTR[2:0])
        3'd0 : NEXT_STATE = IDLE;
        3'd1 : NEXT_STATE = FETCH;
        3'd2 : NEXT_STATE = LOADA;
        3'd3 : NEXT_STATE = LOADB;    
        3'd4 : NEXT_STATE = MULTACC;
        3'd5 : NEXT_STATE = STORE;
        3'd6 : NEXT_STATE = STOP;
        3'd7 : NEXT_STATE = IDLE;  
    endcase
end


always_ff @( posedge CLK ) begin 
    if (RSTN) begin
        STATE <= IDLE;
        MAC_CTRL <= 4'b0000;
        PC_INCR <= 1'b0;
        RST_ACC <= 4'b1111;
        RST_PC <= 4'b1111;
        ADDR_START <= 1'b0; 
        ADDR_RST <= 1'b1;
        PE_SEL <= 2'b00;
        WRADDR_START <= 1'b0;
        INSTR_DONE <= 1'b0;
        STOP_SIGNAL <= 1'b0;
        DIMEN <= 2'b00;
        MAT_MUX <= 1'b0;
        WRITE_MAT <= 1'b0;
        RST_ADD <= 1'b1;
        OUT_READY <= 1'b0;
        ADDRESS <= 4'd0;
        PE_SEL_2x2 <= 1'b0;
        PE_SEL_4 <= 1'b0;
    end
    else begin

        MAC_CTRL <= 4'b0000;
        PC_INCR <= 1'b0;
        RST_ACC <= 4'b0000;
        RST_PC <= 4'b0000;
        ADDR_START <= 1'b0; 
        ADDR_RST <= 1'b0;
        PE_SEL <= 2'b00;
        WRADDR_START <= 1'b0;
        INSTR_DONE <= 1'b0;
        STOP_SIGNAL <= 1'b0;
        DIMEN <= 2'b00;
        MAT_MUX <= 1'b0;
        WRITE_MAT <= 1'b0;
        RST_ADD <= 1'b0;
        OUT_READY <= 1'b0;
        ADDRESS <= 4'd0;
        PE_SEL_2x2 <= 1'b0;
        PE_SEL_4 <= 1'b0;
        
        unique case (STATE)
            IDLE:begin
                STATE <= (START_SIGNAL) ? FETCH : IDLE;
                INSTR_DONE <= 1'b1;
            end

            FETCH: begin
                STATE <= NEXT_STATE;
                DIMEN <= INSTR[4:3];
                PC_INCR <= 1'b1;

                RST_ACC <= (INSTR[5]) ? 4'b1111 : 4'b0000;
                RST_PC <= (INSTR[5]) ? 4'b1111 : 4'b0000;
            end

            LOADA: begin
                WRITE_MAT <= 1'b1;
                MAT_MUX <= 1'b1;
                RST_ADD <= (FETCH_DONE) ? 1'b1 : 1'b0;
                
                DIMEN <= INSTR[4:3];
                ADDR_START <= (FETCH_DONE) ? 1'b0 : 1'b1;
                ADDR_RST <= (FETCH_DONE) ? 1'b1 : 1'b0;
                ADDRESS <= INSTR[12:9];
                PE_SEL <= INSTR[8:7];
                PE_SEL_2x2 <= INSTR[13];

                STATE <= (FETCH_DONE) ? FETCH : LOADA;
                INSTR_DONE <= (FETCH_DONE) ? 1'b1 : 1'b0;

            end

            LOADB: begin
                WRITE_MAT <= 1'b1;
                MAT_MUX <= 1'b0;
                RST_ADD <= (FETCH_DONE) ? 1'b1 : 1'b0;
                
                DIMEN <= INSTR[4:3];
                ADDR_START <= (FETCH_DONE) ? 1'b0 : 1'b1;
                ADDR_RST <= (FETCH_DONE) ? 1'b1 : 1'b0;
                ADDRESS <= INSTR[12:9];
                PE_SEL <= INSTR[8:7];
                PE_SEL_2x2 <= INSTR[13];
                PE_SEL_4 <= INSTR[14];

                STATE <= (FETCH_DONE) ? FETCH : LOADB;
                INSTR_DONE <= (FETCH_DONE) ? 1'b1 : 1'b0;
            end

            MULTACC: begin
                MAC_CTRL <= (MAC_DONE) ? 4'b1111 : 4'b0000;
                DIMEN <= INSTR[4:3];

                STATE <= (MAC_DONE) ? FETCH : MULTACC;
                INSTR_DONE <= (MAC_DONE) ? 1'b1 : 1'b0;
            end

            STORE: begin
                DIMEN <= INSTR[4:3];
                OUT_READY <= 4'b1111;
                
                ADDR_START <= (STORE_DONE) ? 1'b0 : 1'b1;
                ADDR_RST <= (STORE_DONE) ? 1'b1 : 1'b0;
                ADDRESS <= INSTR[12:9];
                WRADDR_START <= 1'b1;

                STATE <= (STORE_DONE) ? FETCH : STORE;
                INSTR_DONE <= (STORE_DONE) ? 1'b1 : 1'b0;
            end

            STOP: begin
                STOP_SIGNAL <= 1'b1;
                STATE <= STOP;
            end

        endcase
    end
end
    
endmodule