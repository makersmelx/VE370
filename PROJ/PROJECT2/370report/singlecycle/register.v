`ifndef MODULE_REGISTER
`define MODULE_REGISTER
`timescale 1ns / 1ps

module register (
	input			clk, _regWrite,
	input	[4:0]	readReg1, 
					readReg2,
					writeReg,
	input	[31:0]	writeData,
	output	[31:0]	readData1,readData2
	
);
	reg 	[31:0] 	regs [0:31];
	integer i;
	initial begin
		for(i = 0 ; i < 32;i = i+1) begin
			regs[i] = 32'b0;
		end
	end

	assign readData1 = regs[readReg1];
	assign readData2 = regs[readReg2];
	always @(posedge clk ) begin
		if(_regWrite == 1'b1) begin
			 regs[writeReg] <= writeData;
		end
	end

endmodule

`endif


