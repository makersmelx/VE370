`timescale 1ns / 1ps
`include "Cache.v"
module testbench;
	integer i,j,k;
	reg 		read_write;
	reg	[31:0] 	write_data;
	reg	[9:0]	address;
	wire [31:0] read_data;
	wire hit_miss;
	reg clk;
	Cache uut(
		.read_write_from_cpu(read_write),
		.address_from_cpu   (address),
		.write_data_from_cpu(write_data),
		.read_data_out      (read_data),
		.hit_miss_out       (hit_miss)
	);
	initial begin
		$dumpfile("bench.vcd");
		$dumpvars(1, uut);
		#0 address = 10'b0000000000; read_write = 0; //should miss
		// #0 for(i = 0 ; i < 64 ; i = i + 4) begin
		// 	$display("memory[%D]= 0x%H, memory[%D]= 0x%H, memory[%D]= 0x%H, memory[%D]= 0x%H ",i,uut.Shijian.memory[i],i+1,uut.Shijian.memory[i+1],i+2,uut.Shijian.memory[i+2],i+3, uut.Shijian.memory[i+3]);
		// end
		#10 read_write = 1; address = 10'b0000000000; write_data = 8'b11111111; //should hit
		#10 read_write = 0; address = 10'b0000000000; //should hit and read out 0xff
		//here check main memory content,
		//the first byte should remain 0x00 if it is write-back,
		//should change to 0xff if it is write-through.
		#10 for(i = 0 ; i < 3 ; i = i + 4) begin
			$display("memory[%3D]= 0x%H, memory[%3D]= 0x%H, memory[%3D]= 0x%H, memory[%3D]= 0x%H ",i,uut.Shijian.memory[i],i+1,uut.Shijian.memory[i+1],i+2,uut.Shijian.memory[i+2],i+3, uut.Shijian.memory[i+3]);
		end
		$display("\n\n",);
		#10 read_write = 0; address = 10'b1000000000; //should miss
		#10 read_write = 0; address = 10'b0000000000; //should hit for 2-way associative, should miss for directly mapped

		#10 read_write = 0; address = 10'b1100000000; //should miss
		#10 read_write = 0; address = 10'b1000000000; //should miss both for directly mapped and for 2-way associative (Least-Recently-Used policy)
		#10 $stop;
	end
endmodule