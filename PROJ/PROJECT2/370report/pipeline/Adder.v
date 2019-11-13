`ifndef MODULE_ADDER
`define MODULE_ADDER
`timescale 1ns / 1ps

module Adder(
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] result
    );
    always @(a or b) begin
        result = a + b;
    end
endmodule
`endif