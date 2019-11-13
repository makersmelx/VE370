`ifndef MODULE_ID_EX
`define MODULE_ID_EX
`timescale 1ns / 1ps

module ID_EX(
    input Clk,
    input Flush,
    input IDRegWrite,
    output reg EXRegWrite,
    input IDMemtoReg,
    output reg EXMemtoReg,
    input IDMemWrite,
    output reg EXMemWrite,
    input IDMemRead,
    output reg EXMemRead,
    input [1:0] IDALUOp,
    output reg [1:0] EXALUOp,
    input IDRegDst,
    output reg EXRegDst,
    input IDALUSrc,
    output reg EXALUSrc,
    input [31:0] IDRegData1,
    input [31:0] IDRegData2,
    output reg [31:0] EXRegData1,
    output reg [31:0] EXRegData2,
    input [31:0] IDSignExImm,
    output reg [31:0] EXSignExImm,
    input [4:0] IDrs,
    output reg [4:0] EXrs,
    input [4:0] IDrt,
    output reg [4:0] EXrt,
    input [4:0] IDrd,
    output reg [4:0] EXrd
    );
    
    initial begin
        EXRegWrite = 1'b0;
        EXMemtoReg = 1'b0;
        EXMemWrite = 1'b0;
        EXMemRead = 1'b0;
        EXALUOp = 2'b0;
        EXRegDst = 1'b0;
        EXALUSrc = 1'b0;
        EXRegData1 = 32'b0;
        EXRegData2 = 32'b0;
        EXSignExImm = 32'b0;
        EXrs = 5'b0;
        EXrt = 5'b0;
        EXrd = 5'b0;
    end

    always @ (posedge Clk) begin
        if (Flush) begin
            EXRegWrite <= 1'b0;
            EXMemtoReg <= 1'b0;
            EXMemWrite <= 1'b0;
            EXMemRead <= 1'b0;
            EXALUOp <= 2'b0;
            EXRegDst <= 1'b0;
            EXALUSrc <= 1'b0;
        end
        else begin
            EXRegWrite <= IDRegWrite;
            EXMemtoReg <= IDMemtoReg;
            EXMemWrite <= IDMemWrite;
            EXMemRead <= IDMemRead;
            EXALUOp <= IDALUOp;
            EXRegDst <= IDRegDst;
            EXALUSrc <= IDALUSrc;
            EXRegData1 <= IDRegData1;
            EXRegData2 <= IDRegData2;
            EXSignExImm <= IDSignExImm;
            EXrs <= IDrs;
            EXrt <= IDrt;
            EXrd <= IDrd;
        end
    end
endmodule

`endif