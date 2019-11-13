`ifndef MODULE_SINGLE_CYCLE
`define MODULE_SINGLE_CYCLE
`timescale 1ns / 1ps
`include "ALU.v"
`include "ALUControl.v"
`include "Control.v"
`include "dataMemory.v"
`include "PC.v"
`include "register.v"
`include "signExtend.v"
`include "instructionMemory.v"

module singleCycle (input clk);
    //insturction and PC
    wire    [31:0]  instruction,
                    pc_in,
    				pc_out,
                    next_instruction_addr,
                    jump_addr,
                    next_addr;

    //control unit, all vars start with _
    wire            _reg_write,
                    _ALU_src,
                    _branch,
                    _jump,
                    _beq,
                    _bne,
                    _reg_dst,
                    _mem_to_reg,
                    _mem_read,
                    _mem_write;

    //register
    wire    [31:0]  read_reg_data_1,
                    read_reg_data_2,
                    write_data;
    wire    [4:0]   write_reg;

    // sign_extend output
    wire    [31:0]  sign_extend_output;

    //ALU control
    wire    [1:0]   ALU_op;
    wire    [3:0]   ALU_control;

    //ALU
    wire    [31:0]  ALU_second_input,
                    ALU_result;
    wire            ALU_zero_ouput;
 
    // dataMemory
    wire    [31:0]  data_memory_read_data;

    // MUX for next instructions
    assign next_addr = pc_out + 4;
    assign _branch = (ALU_zero_ouput & _beq) | (~ALU_zero_ouput & _bne);
    assign next_instruction_addr = (_branch == 1'b0) ? next_addr : next_addr + (sign_extend_output << 2 );
    assign jump_addr = {next_addr[31:28],instruction[25:0],2'b0};
    assign pc_in = (_jump == 1'b0) ? next_instruction_addr : jump_addr;
    //MUX for which register to be written 
    assign write_reg = (_reg_dst == 1'b0) ? instruction[20:16] : instruction[15:11];
    //MUX for which data to be written into register
    assign write_data = (_mem_to_reg == 1'b0) ? ALU_result : data_memory_read_data;
    //MUX for which data to be the second input of ALU
    assign ALU_second_input = (_ALU_src == 1'b0) ?  read_reg_data_2 : sign_extend_output;

    PC ShiLi(
    	.clk(clk),
    	.in(pc_in),
    	.out(pc_out)
    );

    instructionMemory VE370highShiLi(
        .address    (pc_out),
        .instruction(instruction)
    );

    Control  KingofEE_ShiJian(
        .opCode  (instruction[31:26]),
        .regDst  (_reg_dst),
        .jump    (_jump),
        .beq     (_beq),
        .bne     (_bne),
        .memRead (_mem_read),
        .memWrite(_mem_write),
        .memtoReg(_mem_to_reg),
        .ALUSrc  (_ALU_src),
        .regWrite(_reg_write),
        .ALUOp   (ALU_op)
    );
 
    register ktt(
    	.clk      (clk),
    	._regWrite (_reg_write),
    	.readReg1 (instruction[25:21]),
    	.readReg2 (instruction[20:16]),
    	.writeReg (write_reg),
    	.writeData(write_data),
        .readData1(read_reg_data_1),
        .readData2(read_reg_data_2)
    );

    signExtend UniverseNoOneSHiLi(
        .in (instruction[15:0]),
        .out(sign_extend_output)
    );

    ALUControl MostLearn_ShiJian(
    	.ALUop  (ALU_op),
    	.funct  (instruction[5:0]),
    	.control(ALU_control)
    );

    ALU Manuel(
        .control(ALU_control),
        .a      (read_reg_data_1),
        .b      (ALU_second_input),
        .zero   (ALU_zero_ouput),
        .result (ALU_result)
    );

    dataMemory zzz(
    	.clk      (clk),
    	.address  (ALU_result),
    	.memRead  (_mem_read),
    	.memWrite (_mem_write),
    	.writeData(read_reg_data_2),
    	.readData (data_memory_read_data)
    );

endmodule

`endif