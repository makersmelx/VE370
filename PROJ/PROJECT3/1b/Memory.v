`ifndef MODULE_MEMORY
`define MODULE_MEMORY
`timescale 1ns / 1ps
module Memory (
	input					read_write,
	input			[9:0]	address,
	input			[127:0]	write_data,
	output		 	[127:0]	read_data
);
	reg 	[31:0] 		memory [255:0];
	integer i;
	initial begin
		`include "Main_Memory_Data.txt"
		//$display("address: %H",address);
		// $display("read_data_initial: %H",read_data);
	end
	assign read_data = {memory[{address[9:4],2'b11}], memory[{address[9:4],2'b10}], memory[{address[9:4],2'b01}], memory[{address[9:4],2'b00}]};

	always @(read_write) begin
		if (read_write == 1'b1) begin
			memory[{address[9:4],2'b00}] = write_data[127:96];
			memory[{address[9:4],2'b01}] = write_data[95:64];
			memory[{address[9:4],2'b10}] = write_data[63:32];
			memory[{address[9:4],2'b11}] = write_data[31:0];
		end
	end
endmodule
`endif