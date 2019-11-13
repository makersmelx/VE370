`ifndef MODULE_CONTROL
`define MODULE_CONTROL
`timescale 1ns / 1ps

module Control (
    input       [5:0]   opCode,
    output reg          regDst,
                        jump,
                        beq,
                        bne,
                        memRead,
                        memtoReg,
                        memWrite,
                        ALUSrc,
                        regWrite,
    output reg  [1:0]   ALUOp
);

    initial begin
        regDst      = 1'b0;
        jump        = 1'b0;
        beq         = 1'b0;
        bne         = 1'b0;
        memRead     = 1'b0;
        memtoReg    = 1'b0;
        memWrite    = 1'b0;
        ALUSrc      = 1'b0;
        regWrite    = 1'b0;
        ALUOp       = 2'b00;
    end

    always @ (opCode) begin
        case (opCode)
            6'b000000: begin // R-type
                regDst      <= 1'b1;
                jump        <= 1'b0;
                beq         <= 1'b0;
                bne         <= 1'b0;
                memRead     <= 1'b0;
                memtoReg    <= 1'b0;
                memWrite    <= 1'b0;
                ALUSrc      <= 1'b0;
                regWrite    <= 1'b1;
                ALUOp       <= 2'b10;
            end
            6'b000010: begin // j-type
                regDst      <= 1'b1;
                jump        <= 1'b1;
                beq         <= 1'b0;
                bne         <= 1'b0;
                memRead     <= 1'b0;
                memtoReg    <= 1'b0;
                memWrite    <= 1'b0;
                ALUSrc      <= 1'b0;
                regWrite    <= 1'b0;
                ALUOp       <= 2'b10;
            end
            6'b000100: begin // beq
                regDst      <= 1'b1;
                jump        <= 1'b0;
                beq         <= 1'b1;
                bne         <= 1'b0;
                memRead     <= 1'b0;
                memtoReg    <= 1'b0;
                memWrite    <= 1'b0;
                ALUSrc      <= 1'b0;
                regWrite    <= 1'b0;
                ALUOp       <= 2'b01;
            end
            6'b000101: begin // bne
                regDst      <= 1'b1;
                jump        <= 1'b0;
                beq         <= 1'b0;
                bne         <= 1'b1;
                memRead     <= 1'b0;
                memtoReg    <= 1'b0;
                memWrite    <= 1'b0;
                ALUSrc      <= 1'b0;
                regWrite    <= 1'b0;
                ALUOp       <= 2'b01;
            end
            6'b001000: begin // addi
                regDst      <= 1'b0;
                jump        <= 1'b0;
                beq         <= 1'b0;
                bne         <= 1'b0;
                memRead     <= 1'b0;
                memtoReg    <= 1'b0;
                memWrite    <= 1'b0;
                ALUSrc      <= 1'b1;
                regWrite    <= 1'b1;
                ALUOp       <= 2'b00;
            end
            6'b001100: begin // andi
                regDst      <= 1'b0;
                jump        <= 1'b0;
                beq         <= 1'b0;
                bne         <= 1'b0;
                memRead     <= 1'b0;
                memtoReg    <= 1'b0;
                memWrite    <= 1'b0;
                ALUSrc      <= 1'b1;
                regWrite    <= 1'b1;
                ALUOp       <= 2'b11;
            end
            6'b100011: begin // lw
                regDst      <= 1'b0;
                jump        <= 1'b0;
                beq         <= 1'b0;
                bne         <= 1'b0;
                memRead     <= 1'b1;
                memtoReg    <= 1'b1;
                memWrite    <= 1'b0;
                ALUSrc      <= 1'b1;
                regWrite    <= 1'b1;
                ALUOp       <= 2'b00;
            end
            6'b101011: begin // sw
                regDst      <= 1'b0;
                jump        <= 1'b0;
                beq         <= 1'b0;
                bne         <= 1'b0;
                memRead     <= 1'b0;
                memtoReg    <= 1'b0;
                memWrite    <= 1'b1;
                ALUSrc      <= 1'b1;
                regWrite    <= 1'b0;
                ALUOp       <= 2'b00;
            end

            default: ;
        endcase
    end

endmodule 

`endif