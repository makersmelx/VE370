`ifndef MODULE_REGISTER
`define MODULE_REGISTER
`timescale 1ns / 1ps

module Register(
    input clk, reg_write,
    input [4:0] read_reg1, read_reg2, write_reg, Input_Readreg,
    input [31:0] write_data,
    output [31:0] read_data1, read_data2, RegOut
    );
    reg [31:0] registers [0:31];
    integer i;
    
    initial begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 32'b0;  // initialize the registers
    end
    
    assign read_data1 = registers[read_reg1];
    assign read_data2 = registers[read_reg2];
    assign RegOut = registers[Input_Readreg];
    always @(negedge clk) begin
        if (reg_write == 1)
            registers[write_reg] <= write_data;
    end
endmodule
`endif