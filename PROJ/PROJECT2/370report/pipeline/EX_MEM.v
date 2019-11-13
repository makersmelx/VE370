`ifndef MODULE_EX_MEM
`define MODULE_EX_MEM
`timescale 1ns / 1ps

module EX_MEM(
    input Clk,
    input EXRegWrite,
    output reg MEMRegWrite,
    input EXMemtoReg,
    output reg MEMMemtoReg,
    input EXMemWrite,
    output reg MEMMemWrite,
    input ExMemRead,
    output reg MEMMemRead,
    input [31:0] EXALUResult,
    output reg [31:0] MEMALUResult,
    input [31:0] EXRegData2,
    output reg [31:0] MEMRegData2,
    input [4:0] EXRegisterRd,
    output reg [4:0] MEMRegisterRd
    );

    initial begin
        MEMRegWrite = 1'b0;
        MEMMemtoReg = 1'b0;
        MEMMemWrite = 1'b0;
        MEMMemRead = 1'b0;
        MEMALUResult = 32'b0;
        MEMRegData2 = 32'b0;
        MEMRegisterRd = 5'b0;
    end

    always @ (posedge Clk) begin
         MEMRegWrite <= EXRegWrite;
        MEMMemtoReg <= EXMemtoReg;
        MEMMemWrite <= EXMemWrite;
        MEMMemRead <= ExMemRead;
        MEMALUResult <= EXALUResult;
        MEMRegData2 <= EXRegData2;
        MEMRegisterRd <= EXRegisterRd;
    end
endmodule
`endif