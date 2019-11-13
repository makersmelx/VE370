`ifndef MODULE_MUX32BIT
`define MODULE_MUX32BIT
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/22 11:18:03
// Design Name: 
// Module Name: MUX32Bit
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


module MUX32Bit(
    input       select,
    input       [31:0]  input1, input2,
    output  reg [31:0]  out
    );
    always @(select or input1 or input2) begin
        if (select == 1'b0)
             out = input1;
        else
            out = input2;
    end
endmodule
`endif