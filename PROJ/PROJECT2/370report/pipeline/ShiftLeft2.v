`ifndef MODULE_SHIFTLEFT2
`define MODULE_SHIFTLEFT2
`timescale 1ns / 1ps

module ShiftLeft2(
    input [31:0] input1,
    output reg [31:0] output1
    );
    always @(input1) begin
        output1 = input1 << 2;
    end
endmodule
`endif