`ifndef MODULE_CACHE
`define MODULE_CACHE
`include "Memory.v"
`timescale 1ns / 1ps
module Cache(
	input 						read_write_from_cpu,
	input 			[9:0] 		address_from_cpu,
	input 			[31:0] 		write_data_from_cpu,
	output 	wire 	[31:0]		read_data_out ,
	output  wire 	hit_miss_out
);
	integer	i,j;

	reg		[31:0] 		read_data_to_cpu;
	reg	 				hit_miss;

	assign hit_miss_out = hit_miss;
	assign read_data_out = read_data_to_cpu;

	reg 		recent	[1:0];
	reg [31:0] 	caches	[3:0][3:0];
	reg			visit	[3:0];
	reg	[4:0]	tag  	[3:0];
	reg 		index;
	reg	[3:0]	dirty;

	reg 						read_write_to_mem;
	reg							read_write_mark;
	// reg							read_to_mem;
	// reg							write_to_mem;
	reg				[9:0]		address_to_mem;
	reg				[127:0]		write_data_to_mem;
	wire 			[127:0]		read_data_from_mem;
	reg super_tmp;
	reg	[9:0] tag_back;

	initial begin
		for(i = 0; i < 4; i = i + 1) begin
			visit[i]=1'b0;
		end
		for(i = 0; i < 2; i = i + 1) begin
			recent[i]=1'b0;
		end
		for(i = 0; i < 4; i = i + 1) begin
			for(j = 0; j<4;j = j +1) begin
				caches[i][j]=32'b0;
			end
		end
		for(i = 0 ;i < 4; i = i + 1) begin
			tag[i] = 5'b0;
		end
		for(i = 0 ;i < 4; i = i + 1) begin
			dirty[i] = 1'b0;
		end
		super_tmp = 0;
	end

	Memory Shijian(
		.read_write(read_write_to_mem),
		.address   (address_to_mem),
		.read_data (read_data_from_mem),
		.write_data(write_data_to_mem)
	);

	// Tag: 5 + Index: 1 + Word: 2 + Byte: 2
	always @(read_write_from_cpu or address_from_cpu or write_data_from_cpu) begin
		$display("Start");
		index = address_from_cpu[4];
		hit_miss = ((visit[{index,1'b0}]==1'b1 & tag[{index,1'b0}] == address_from_cpu[9:5]) | (visit[{index,1'b1}]==1'b1 & tag[{index,1'b1}] == address_from_cpu[9:5]))? 1: 0;

		$display("Check: Dirty: %H",dirty[{index,recent[index]}]);
		
		// $display("Check: Dirty: %H",dirty[{address_from_cpu[4],1'b0}]);
		// if(hit_miss == 1'b0) begin
		// 	if((dirty[{address_from_cpu[4],1'b0}] == 1'b1 & address_from_cpu[9:5] != tag[{address_from_cpu[4],1'b0}] )| (dirty[{address_from_cpu[4],1'b1}] == 1'b1 & address_from_cpu[9:5] != tag[{address_from_cpu[4],1'b1}] )) begin
		// 		if(visit[{address_from_cpu[4],1'b0}] == 1'b1 & visit[{address_from_cpu[4],1'b1}] == 1'b1 & read_write_from_cpu == 1'b0 ) begin
		// 			read_write_to_mem = 1'b1;
		// 			//$display("Write! : %H",write_data_to_mem);
		// 			#1 ;
		// 			dirty[{address_from_cpu[4],1'b0}] = 1'b0;
		// 			dirty[{address_from_cpu[4],1'b1}] = 1'b0;
		// 		end
		// 	end
		// end

		address_to_mem = address_from_cpu;
		if(hit_miss == 1'b1) begin
			// hit
			if(read_write_from_cpu == 1'b0) begin
				// read from cache
				if(tag[{index,1'b0}] == address_from_cpu[9:5]) begin
					// the first block of 2-way
					recent[index] = 1'b0;
					read_data_to_cpu = caches[{index,1'b0}][address_from_cpu[3:2]];
				end
				else begin	
					// the second block of 2-way
					recent[index] = 1'b1;
					read_data_to_cpu = caches[{index,1'b1}][address_from_cpu[3:2]];
				end
			end
			else begin
				// write to cache then memory
				if(tag[{index,1'b0}] == address_from_cpu[9:5]) begin
					recent[index] = 1'b0;
					caches[{index,1'b0}][address_from_cpu[3:2]] = write_data_from_cpu;
					dirty[{index,1'b0}] = 1'b1;
					
				end
				else begin	
					recent[index] = 1'b1;
					caches[{index,1'b1}][address_from_cpu[3:2]] = write_data_from_cpu;
					dirty[{index,1'b1}] = 1'b1;
					
				end
				
				// for( i  = 0 ; i < 4 ; i = i + 1) begin
				// 	$display("Dirty: %B",dirty[i]);
				// end
			end
			
		end
		else begin
			// miss
			// When at least one of the block in [index] is invalid.
			if(visit[{index,1'b1}]==1'b0) begin
				recent[index] = 1'b0;
			end
			if(visit[{index,1'b0}]==1'b0) begin
				recent[index] = 1'b1;
			end
			// Change recent[index] to the block to be loaded.

			recent[index] = 1'b1 - recent[index];
			visit[{index,recent[index]}] = 1'b1;
			tag_back = tag[{index,recent[index]}];
			tag[{index,recent[index]}] = address_from_cpu[9:5];
		end

		//$display("cHECK: %h",write_data_to_mem);

		if(hit_miss == 1'b0) begin
			if((dirty[{index,recent[index]}] == 1'b1 )) begin
				if(visit[{address_from_cpu[4],1'b0}] == 1'b1 & visit[{address_from_cpu[4],1'b1}] == 1'b1 & read_write_from_cpu == 1'b0 ) begin
					//$display("Here");
					//$display("NMD: %B",{tag[{index,recent[index]}],index,4'b0});
					address_to_mem = tag_back;
					read_write_to_mem = 1'b1;
					//$display("Tri",);
					#10;
					super_tmp = 1'b1;
					#10;
					//$display("ll: %B",read_write_to_mem);
					//$display("Write! : %H",write_data_to_mem);
					dirty[{address_from_cpu[4],1'b0}] = 1'b0;
					dirty[{address_from_cpu[4],1'b1}] = 1'b0;
				end
			end
		end

		#1 if(hit_miss == 1'b0) begin
			// read from memory if there is miss
				read_write_to_mem = 1'b0;
				caches[{index,recent[index]}][3] = read_data_from_mem[127:96];
				caches[{index,recent[index]}][2] = read_data_from_mem[95:64];
				caches[{index,recent[index]}][1] = read_data_from_mem[63:32];
				caches[{index,recent[index]}][0] = read_data_from_mem[31:0];
			end

		if(super_tmp == 1'b0) begin	
			//$display("Here",);
			#1 if(read_write_from_cpu == 1'b1) begin
				if(hit_miss == 1'b1) begin
				// write to memory when it is hit
					write_data_to_mem = {caches[{index,recent[index]}][0],caches[{index,recent[index]}][1],caches[{index,recent[index]}][2],caches[{index,recent[index]}][3]};
				end
				else begin
					//write through to memory when it is miss
					caches[{index,recent[index]}][address_from_cpu[3:2]] = write_data_from_cpu;
					write_data_to_mem = {caches[{index,recent[index]}][0],caches[{index,recent[index]}][1],caches[{index,recent[index]}][2],caches[{index,recent[index]}][3]};
				end
				dirty[{index,recent[index]}] = 1'b1;
				//$display("write_data_to_mem: %H",write_data_to_mem);
			end

		end

		$display("==================================================",);
		$display("read_write= %B; address=10'b%B; write_data=8'b%H",read_write_from_cpu,address_from_cpu,write_data_from_cpu);
		if(hit_miss) begin
			if(read_write_from_cpu == 1'b0) begin
				$display("read_data_to_cpu: %H", read_data_to_cpu);
			end
		end
		$display("hit_miss: %B",hit_miss);
		$display("==================================================",);
		$display("\n",);
		for(i = 0 ; i < 4 ; i= i +1) begin
			$display("visit: %B, dirty: %B, recent: %B, tag: %B",visit[i],dirty[i],recent[i],tag[i]);
		end
		$display("\n\n");

	end
endmodule
`endif