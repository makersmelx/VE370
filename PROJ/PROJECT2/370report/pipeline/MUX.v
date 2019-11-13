`ifndef MODULE_MUX
`define MODULE_MUX
`timescale 1ns / 1ps

module MUX(
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