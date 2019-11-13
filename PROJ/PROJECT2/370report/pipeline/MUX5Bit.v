`ifndef MODULE_MUX5BIT
`define MODULE_MUX5BIT
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/22 11:17:38
// Design Name: 
// Module Name: MUX5Bit
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


module MUX5Bit(
    input       select,
    input       [4:0]  input1, input2,
    output  reg [4:0]  out
    );
    always @(select or input1 or input2) begin
        if (select == 1'b0)
            out = input1;
        else
            out = input2;
    end
endmodule
`endif