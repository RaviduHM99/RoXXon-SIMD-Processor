`timescale 1ns/1ps

module BRAM_RF(
    input logic CLK,

    (*KEEP = "true"*)
    input logic [12:0] addrb, // BRAM Ports
    (*KEEP = "true"*)
    input logic [31:0] dinb,
    (*KEEP = "true"*)
    output logic [31:0] doutb,
    input logic enb,
    input logic [3:0] web

);
    
/*
    // Function to read matrix from file and store in registers
    localparam N = 48;
    function void read_matrix(string filename1, string filename2, reg [N-1:0][31:0] BRAM, int ROWS, int COLS);
        int file1, file2;
        string line1, line2;
        int row, col, indx;

        file1 = $fopen(filename1, "r");
        if (file1 == 0) begin
            $fatal("Error opening file %s", filename1);
        end

        file2 = $fopen(filename2, "r");
        if (file2 == 0) begin
            $fatal("Error opening file %s", filename2);
        end

        indx = 1;

        for (row = 0; row < ROWS; row = row + 1) begin
            $fgets(line1, file1);
            $fscanf(line1, "%0d %0d %0d %0d", BRAM[indx], BRAM[indx+1], BRAM[indx+2], BRAM[indx+3]);
            indx = indx + 4;
        end

        for (row = 0; row < ROWS; row = row + 1) begin
            $fgets(line2, file2);
            $fscanf(line2, "%0d %0d %0d %0d", BRAM[indx], BRAM[indx+1], BRAM[indx+2], BRAM[indx+3]);
            indx = indx + 4;
        end

        $fclose(file1);
        $fclose(file2);
    endfunction*/

/*
    ////////////////////////////////////////////////////////////////////////
    //////////////////// 8x8 Matrix Multiplication Data ////////////////////
    ////////////////////////////////////////////////////////////////////////
    localparam N = 48;
    reg [N-1:0][31:0] BRAM;

    initial begin 
 
    end*/

    ////////////////////////////////////////////////////////////////////////
    //////////////////// 4x4 Matrix Multiplication Data ////////////////////
    ////////////////////////////////////////////////////////////////////////
    localparam N = 50;
(*mark_debug = "true"*)   reg [N-1:0][31:0] BRAM;

    initial begin 
        BRAM[0] <= 32'd777;

        // Read matrices from files
        // read_matrix("C:/Academic_Projects/ADS_Projects/SoC_Project/py/MatrixA_data.txt", "C:/Academic_Projects/ADS_Projects/SoC_Project/py/MatrixB_tr_data.txt", BRAM, 4, 4);
   
    ///// Matrix A not Transposed for Multiplication ///////    
        BRAM[1] <= 32'd15;
        BRAM[2] <= 32'd20;
        BRAM[3] <= 32'd42;
        BRAM[4] <= 32'd65;
        BRAM[5] <= 32'd98;
        BRAM[6] <= 32'd56;
        BRAM[7] <= 32'd24;
        BRAM[8] <= 32'd78;
        BRAM[9] <= 32'd91;
        BRAM[10] <= 32'd97;
        BRAM[11] <= 32'd33;
        BRAM[12] <= 32'd62;
        BRAM[13] <= 32'd57;
        BRAM[14] <= 32'd23;
        BRAM[15] <= 32'd19;
        BRAM[16] <= 32'd7;
/*
    ///// Matrix A Transposed for Addition/Subtraction ///////  
        BRAM[1] <= 32'd15;
        BRAM[2] <= 32'd98;
        BRAM[3] <= 32'd91;
        BRAM[4] <= 32'd57;
        BRAM[5] <= 32'd20;
        BRAM[6] <= 32'd56;
        BRAM[7] <= 32'd97;
        BRAM[8] <= 32'd23;
        BRAM[9] <= 32'd42;
        BRAM[10] <= 32'd24;
        BRAM[11] <= 32'd33;
        BRAM[12] <= 32'd19;
        BRAM[13] <= 32'd65;
        BRAM[14] <= 32'd78;
        BRAM[15] <= 32'd62;
        BRAM[16] <= 32'd7;*/

    ///// Matrix B Transposed for Multiplication/Addition/Subtraction ///////  
        BRAM[17] <= 32'd48;
        BRAM[18] <= 32'd35;
        BRAM[19] <= 32'd33;
        BRAM[20] <= 32'd49;
        BRAM[21] <= 32'd95;
        BRAM[22] <= 32'd24;
        BRAM[23] <= 32'd2;
        BRAM[24] <= 32'd67;
        BRAM[25] <= 32'd87;
        BRAM[26] <= 32'd18;
        BRAM[27] <= 32'd89;
        BRAM[28] <= 32'd77;
        BRAM[29] <= 32'd62;
        BRAM[30] <= 32'd29;
        BRAM[31] <= 32'd15;
        BRAM[32] <= 32'd1;

    ///// Matrix C - Result ///////  
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
        BRAM[48] <= 32'd0;

        BRAM[49] <= 32'd777;
    end
/*
    ////////////////////////////////////////////////////////////////////////
    //////////////////// 2x2 Matrix Multiplication Data ////////////////////
    ////////////////////////////////////////////////////////////////////////
    localparam N = 13;
    reg [N-1:0][31:0] BRAM;

    initial begin
        BRAM[0] <= 32'd777;

        BRAM[1] <= 32'd2;
        BRAM[2] <= 32'd3;
        BRAM[3] <= 32'd4;
        BRAM[4] <= 32'd5;
        BRAM[5] <= 32'd6;
        BRAM[6] <= 32'd7;
        BRAM[7] <= 32'd8;
        BRAM[8] <= 32'd9;
        BRAM[9] <= 32'd99;
        BRAM[10] <= 32'd199;
        BRAM[11] <= 32'd299;
        BRAM[12] <= 32'd399;

        BRAM[13] <= 32'd777;
    end 
    
*/
    logic [31:0] delay_01_BRAM;

    always_ff @( posedge CLK ) begin
        delay_01_BRAM <= (enb) ? BRAM[addrb] : 32'd199; 
    end

    logic [31:0] delay_02_BRAM;

    always_ff @( posedge CLK ) begin
        delay_02_BRAM <= (enb) ? delay_01_BRAM : 32'd299; 
    end

    always_ff @( posedge CLK ) begin
        BRAM[addrb] <= (web == 4'b1111) ? dinb : BRAM[addrb]; 
    end

    assign doutb = (enb) ? delay_02_BRAM : 32'd399;

endmodule