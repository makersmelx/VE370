`ifndef MODULE_MEM_WB
`define MODULE_MEM_WB
`timescale 1ns / 1ps

module MEM_WB(
    input Clk,
    input MEMRegWrite,
    output reg WBRegWrite,
    input MEMMemtoReg,
    output reg WBMemtoReg,
    input [31:0] MEMMemData,
    output reg [31:0] WBMMemData,
    input [31:0] MEMALUResult,
    output reg [31:0] WBALUResult,
    input [4:0] MEMRegisterRd,
    output reg [4:0] WBRegisterRd
    );

    initial begin
        WBRegWrite = 1'b0;
        WBMemtoReg = 1'b0; 
        WBMMemData = 32'b0;
        WBALUResult = 32'b0;
        WBRegisterRd = 5'b0;
    end

    always @ (posedge Clk) begin
        WBRegWrite <= MEMRegWrite;
        WBMemtoReg <= MEMMemtoReg;
        WBMMemData <= MEMMemData;
        WBALUResult <= MEMALUResult;
        WBRegisterRd <= MEMRegisterRd;
    end
    
endmodule

`endif