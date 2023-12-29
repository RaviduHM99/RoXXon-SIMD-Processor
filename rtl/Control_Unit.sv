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

    //
    output logic ADD_CTRL,
    output logic ADD_INC,
    output logic ADD_RST, 
    output logic ADD_STORE,
    output logic [3:0] STORE_ADDRESS, 
    input logic ADD_DONE, //AND All ADD DONE in top module//

    output logic [1:0] DIMEN, // DATA FETCH LOAD
    output logic ADDR_START,
    output logic ADDR_RST,
    output logic [16:0] ADDRESS,
    input logic FETCH_DONE,
    output logic [1:0] PE_SEL,
    output logic PE_SEL_2x2,
    output logic PE_SEL_4,

    output logic WRADDR_START, // DATA FETCH STORE
    input logic STORE_DONE,

    //output logic WBEN,
    //output logic [12:0] WBADDR,
    //output logic [12:0] WBVALUE,

    input logic START_SIGNAL, //GPIO
    output logic STOP_SIGNAL
);

(*KEEP = "true"*)
(*mark_debug = "true"*)        enum logic [2:0] { IDLE, FETCH, LOADA, LOADB, MULTACC, STORE, STOP, ADDSUB} STATE, NEXT_STATE;

always_comb begin
    unique case (INSTR[2:0])
        3'd0 : NEXT_STATE = IDLE;
        3'd1 : NEXT_STATE = FETCH;
        3'd2 : NEXT_STATE = LOADA;
        3'd3 : NEXT_STATE = LOADB;    
        3'd4 : NEXT_STATE = MULTACC;
        3'd5 : NEXT_STATE = STORE;
        3'd6 : NEXT_STATE = STOP;
        //
        3'd7 : NEXT_STATE = ADDSUB;  
    endcase
end

assign INSTR_DONE = ((STATE == IDLE & START_SIGNAL) | FETCH_DONE | MAC_DONE | STORE_DONE | ADD_DONE) ? 1'b1 : 1'b0;

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
        STOP_SIGNAL <= 1'b0;
        DIMEN <= 2'b00;
        MAT_MUX <= 4'b0000;
        WRITE_MAT <= 4'b0000;
        RST_ADD <= 4'b1111;
        OUT_READY <= 4'b0000;
        ADDRESS <= 17'd0;
        PE_SEL_2x2 <= 1'b0;
        PE_SEL_4 <= 1'b0;
        /*WBEN <= 1'b0;
        WBADDR <= 13'd0;
        WBVALUE <= 13'd0;*/
//
        ADD_STORE <= 1'b0;
        STORE_ADDRESS <= 4'd0; 
        ADD_CTRL <= 1'b0;
        ADD_INC <= 1'b0;
        ADD_RST <= 1'b1;
//
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
        STOP_SIGNAL <= 1'b0;
        DIMEN <= 2'b00;
        MAT_MUX <= 4'b0000;
        WRITE_MAT <= 4'b0000;
        RST_ADD <= 4'b0000;
        OUT_READY <= 4'b0000;
        ADDRESS <= ADDRESS;
        PE_SEL_2x2 <= 1'b0;
        PE_SEL_4 <= 1'b0;
        /*WBEN <= 1'b0;
        WBADDR <= 13'd0;
        WBVALUE <= 13'd0;*/
//
        ADD_STORE <= 1'b0;
        STORE_ADDRESS <= 4'd0; 
        ADD_CTRL <= 1'b0;
        ADD_INC <= 1'b0;
        ADD_RST <= 1'b0;
//
        unique case (STATE)
            IDLE:begin
                STATE <= (START_SIGNAL) ? FETCH : IDLE;
            end

            FETCH: begin
                STATE <= NEXT_STATE;
                DIMEN <= INSTR[4:3];
                PC_INCR <= 1'b1;
                
                PE_SEL_2x2 <= PE_SEL_2x2; 
                PE_SEL_4 <= PE_SEL_4; 

                RST_ACC <= (INSTR[5]) ? 4'b1111 : 4'b0000; /// 4x4, 8x8, ..... in LOAD instructions
            end

            LOADA: begin
                
                if (INSTR[8:7] == 2'd0) WRITE_MAT <= 4'b1111;
                else if (INSTR[8:7] == 2'd2) WRITE_MAT <= (INSTR[13]) ? 4'b0011 : 4'b1100;
                else if (INSTR[8:7] == 2'd1)begin
                    if (~PE_SEL_4 & ~PE_SEL_2x2) WRITE_MAT <= 4'b0001;
                    else if  (~PE_SEL_4 & PE_SEL_2x2) WRITE_MAT <= 4'b0010;
                    else if  (PE_SEL_4 & ~PE_SEL_2x2) WRITE_MAT <= 4'b0100;
                    else WRITE_MAT <= 4'b1000;
                end
                else WRITE_MAT <= (INSTR[13]) ? 4'b0101 : 4'b1010;

                MAT_MUX <= 4'b1111;
                RST_ADD <= (FETCH_DONE) ? 4'b1111 : 4'b0000;
                
                DIMEN <= INSTR[4:3];
                ADDR_START <= (FETCH_DONE) ? 1'b0 : 1'b1;
                ADDR_RST <= (FETCH_DONE) ? 1'b1 : 1'b0;
                ADDRESS <= INSTR[31:15];
                PE_SEL <= INSTR[8:7];
                PE_SEL_2x2 <= INSTR[13];
                PE_SEL_4 <= INSTR[14];

                STATE <= (FETCH_DONE) ? FETCH : LOADA;
            end

            LOADB: begin 

                if (INSTR[8:7] == 2'd1)begin
                    if (~PE_SEL_4 & ~PE_SEL_2x2) WRITE_MAT <= 4'b0001;
                    else if  (~PE_SEL_4 & PE_SEL_2x2) WRITE_MAT <= 4'b0010;
                    else if  (PE_SEL_4 & ~PE_SEL_2x2) WRITE_MAT <= 4'b0100;
                    else WRITE_MAT <= 4'b1000;
                end
                else if (INSTR[8:7] == 2'd3) WRITE_MAT <= (INSTR[13]) ? 4'b0101 : 4'b1010;
                else if (INSTR[8:7] == 2'd0) WRITE_MAT <= 4'b1111;
                else WRITE_MAT <= (INSTR[13]) ? 4'b0011 : 4'b1100;

                MAT_MUX <= 4'b0000;
                RST_ADD <= (FETCH_DONE) ? 4'b1111 : 4'b0000;
                
                DIMEN <= INSTR[4:3];
                ADDR_START <= (FETCH_DONE) ? 1'b0 : 1'b1;
                ADDR_RST <= (FETCH_DONE) ? 1'b1 : 1'b0;
                ADDRESS <= INSTR[31:15];
                PE_SEL <= INSTR[8:7];
                PE_SEL_2x2 <= INSTR[13];
                PE_SEL_4 <= INSTR[14];

                STATE <= (FETCH_DONE) ? FETCH : LOADB;
            end

            MULTACC: begin
                MAC_CTRL <= (MAC_DONE) ? 4'b0000 : 4'b1111;
                DIMEN <= INSTR[4:3];

                STATE <= (MAC_DONE) ? FETCH : MULTACC;
                RST_PC <= (MAC_DONE) ? 4'b1111 : 4'b0000;
            end

            STORE: begin
                DIMEN <= INSTR[4:3];
                OUT_READY <= 4'b1111;
                
                ADDR_START <= (STORE_DONE) ? 1'b0 : 1'b1;
                ADDR_RST <= (STORE_DONE) ? 1'b1 : 1'b0;
                ADDRESS <= INSTR[31:15];
                WRADDR_START <= 1'b1;

                STATE <= (STORE_DONE) ? FETCH : STORE;

                //
                ADD_STORE <= (INSTR[6]) ? 1'b1 : 1'b0;
                STORE_ADDRESS <= INSTR[12:9]; 
                //
            end

            //
            ADDSUB: begin
                ADD_CTRL <= INSTR[7];
                ADD_INC <= (ADD_DONE) ? 1'b0 : 1'b1;
                DIMEN <= INSTR[4:3];

                STATE <= (ADD_DONE) ? FETCH : ADDSUB;
                ADD_RST <= (ADD_DONE) ? 1'b1 : 1'b0;
            end
            //

            STOP: begin
                STOP_SIGNAL <= 1'b1;
                STATE <= STOP; //add two stop instructions
                //WBEN <= 1'b1;
                //WBADDR <= INSTR[27:15];
                //WBVALUE <= {INSTR[31:28], INSTR[14:6]};
            end

        endcase
    end
end
    
endmodule