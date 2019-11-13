`ifndef MODULE_CONTROL
`define MODULE_CONTROL
`timescale 1ns / 1ps

module Control(
    input [5:0] OpCode,
    output reg RegWrite,
    output reg MemtoReg,
    output reg MemWrite,
    output reg MemRead,
    output reg [1:0] ALUOP,
    output reg RegDst,
    output reg ALUSrc,
    output reg Jump,
    output reg Brancheq,
    output reg Branchne
    );

    initial begin
       RegWrite = 1'b0;
       MemtoReg = 1'b0;
       MemWrite = 1'b0;
       MemRead = 1'b0;
       ALUOP = 2'b00;
       RegDst = 1'b0;
       ALUSrc = 1'b0;
       Jump = 1'b0;
       Brancheq = 1'b0;
       Branchne  = 1'b0;
    end

    always @ (OpCode) begin
        case (OpCode)

            //R-type
            6'b000000: begin
            RegWrite <= 1'b1;
            MemtoReg <= 1'b0;
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            ALUOP <= 2'b10;
            RegDst <= 1'b1;
            ALUSrc <= 1'b0;
            Jump <= 1'b0;
            Brancheq <= 1'b0;
            Branchne  <= 1'b0;
            end

            //lw
            6'b100011:begin
            RegWrite <= 1'b1;
            MemtoReg <= 1'b1;
            MemWrite <= 1'b0;
            MemRead <= 1'b1;
            ALUOP <= 2'b00;
            RegDst <= 1'b0;
            ALUSrc <= 1'b1;
            Jump <= 1'b0;
            Brancheq <= 1'b0;
            Branchne  <= 1'b0;
            end

            //sw
            6'b101011:begin
            RegWrite <= 1'b0;
            MemtoReg <= 1'b0;
            MemWrite <= 1'b1;
            MemRead <= 1'b0;
            ALUOP <= 2'b00;
            RegDst <= 1'b0;
            ALUSrc <= 1'b1;
            Jump <= 1'b0;
            Brancheq <= 1'b0;
            Branchne  <= 1'b0;
            end

            //addi
            6'b001000:begin
            RegWrite <= 1'b1;
            MemtoReg <= 1'b0;
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            ALUOP <= 2'b00;
            RegDst <= 1'b0;
            ALUSrc <= 1'b1;
            Jump <= 1'b0;
            Brancheq <= 1'b0;
            Branchne  <= 1'b0;
            end

            //andi
            6'b001100:begin
            RegWrite <= 1'b1;
            MemtoReg <= 1'b0;
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            ALUOP <= 2'b11;
            RegDst <= 1'b0;
            ALUSrc <= 1'b1;
            Jump <= 1'b0;
            Brancheq <= 1'b0;
            Branchne  <= 1'b0;
            end

            //beq
            6'b000100:begin
            RegWrite <= 1'b0;
            MemtoReg <= 1'b0;
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            ALUOP <= 2'b01;
            RegDst <= 1'b1;
            ALUSrc <= 1'b1;
            Jump <= 1'b0;
            Brancheq <= 1'b1;
            Branchne  <= 1'b0;
            end

            //bne
            6'b000101:begin
            RegWrite <= 1'b0;
            MemtoReg <= 1'b0;
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            ALUOP <= 2'b01;
            RegDst <= 1'b1;
            ALUSrc <= 1'b1;
            Jump <= 1'b0;
            Brancheq <= 1'b0;
            Branchne  <= 1'b1;
            end

            //jump
            6'b000010:begin
            RegWrite <= 1'b0;
            MemtoReg <= 1'b0;
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            ALUOP <= 2'b00;
            RegDst <= 1'b1;
            ALUSrc <= 1'b0;
            Jump <= 1'b1;
            Brancheq <= 1'b0; 
            Branchne  <= 1'b0;
            end

            default:begin
            RegWrite <= 1'b0;
            MemtoReg <= 1'b0;
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            ALUOP <= 2'b00;
            RegDst <= 1'b0;
            ALUSrc <= 1'b0;
            Jump <= 1'b0;
            Brancheq <= 1'b0;
            Branchne  <= 1'b0;
            end
        endcase
    end
endmodule
`endif
