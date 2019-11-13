`ifndef MODULE_SIGNEXTEND
`define MODULE_SIGNEXTEND
`timescale 1ns / 1ps

module SignExtend(
    input [15:0] short_input,
    output [31:0] long_out
    );
    assign long_out[15:0] = short_input[15:0];
    assign long_out[31:16] = short_input[15]?16'b1111111111111111:16'b0;
endmodule
`endif