`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2023 12:17:15 AM
// Design Name: 
// Module Name: clk_divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module CLK_Divider
#(parameter
    integer DIV = 2
)(
    input wire clk_in,
    input wire rst,
    output reg clk_out
);

    localparam integer TC = (DIV / 2) - 1; // Terminal count
    integer count; // 32 bits

    wire terminate = (count == TC); // --> Reset counter, trigger clk_out edge

    always @( posedge clk_in )
    begin
        if (rst | terminate)
            count <= 0;
        else
            count <= count + 1;
        
        if (rst)
            clk_out <= 0;
        else if (terminate)
            clk_out <= ~clk_out;
    end

endmodule // clk_divider
