`ifndef MODULE_INSTRUCTIONMEMORY
`define MODULE_INSTRUCTIONMEMORY
`timescale 1ns / 1ps

 module InstructionMemory(
    input       [31:0]  address,
    output      [31:0]  instruction
    );
    reg [31:0] memory [0:63]; // here the size is 64
    integer i;
   
    initial begin
        for (i = 0; i <= 63; i = i + 1)
           memory[i] = 32'b0;  // initialize the instruction memory
       `include "InstructionMem_for_P2_Demo_updated.txt"  // load the instructions
    end
   
    assign instruction = memory[address / 4]; // read instuction
endmodule
`endif