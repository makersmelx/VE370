`ifndef MODULE_DATAMEMORY
`define MODULE_DATAMEMORY
`timescale 1ns / 1ps

module DataMemory(
    input       clk, mem_read, mem_write,
    input       [31:0]  address, data_write,
    output      [31:0]  data_read
    );
    parameter        size = 64;	
    wire     [31:0]  index;
    reg      [31:0]  register_memory [0:size-1];
    integer i;
    
    assign index = address >> 2;
    initial begin
        for (i = 0; i < size; i = i + 1)
            register_memory[i] = 32'b0;  // initialize the memory
    end
    
    always @ ( posedge clk ) begin
        if (mem_write == 1'b1) begin
            register_memory[index] = data_write;  //write data one by one
        end
    end
    
    assign data_read = (mem_read == 1'b1) ? register_memory[index]:32'b0;
    endmodule
`endif