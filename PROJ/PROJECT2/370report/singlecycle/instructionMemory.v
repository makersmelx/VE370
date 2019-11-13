`ifndef MODULE_INSTRUCTION_MEMEORY
`define MODULE_INSTRUCTION_MEMEORY
`timescale 1ns / 1ps
module instructionMemory (
	input	[31:0]	address,
	output	[31:0]	instruction
);
	// I really don't know how to get this num. At least 64 space is enough for this input file.
	parameter size = 64;
	reg	[31:0]	memory [0:size - 1];
	integer i;

	initial begin
		for(i = 0 ; i<size;i=i+1) begin
			memory[i] = 32'b0;
		end
		`include "InstructionMem_for_P2_Demo_updated.txt"
	end

	assign instruction = memory[address >> 2];
endmodule

`endif