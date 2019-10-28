`ifndef MODULE_DATA_MEMORY
`define MODULE_DATA_MEMORY
module dataMemory (
	input 			clk,    
	input	[31:0]	address,
					writeData,
	input			memRead,
					memWrite,
	output	[31:0]	readData
	
);

	// numbers of memory the program wants
	parameter nums = 32;
	wire 	[31:0]	index;
	reg		[31:0]	memory [0:nums-1];
	integer 		i;

	assign index = address >> 2;
	
	initial begin
		for(i = 0; i < nums; i = i + 1)
			memory[i] = 32'b0;
	end

	always @(negedge clk ) begin
		if (memWrite == 1'b1) begin
			 memory[index] = writeData;
		end
	end

	assign readData = (memRead == 1'b1) ? memory[index]:32'b0; 
	

endmodule

`endif