`ifndef MODULE_HAZARDDETECTIONUNIT
`define MODULE_HAZARDDETECTIONUNIT
`timescale 1ns / 1ps

module HazardDetectionUnit(
    output reg Stall,
    output reg Flush,
    input [4:0] IF_IDrs,
    input [4:0] IF_IDrt,
    input [4:0] ID_EXrt,
    input [4:0] ID_EXRegisterRd,
    input ID_EXMemRead,
    input IDBranchEq,
    input IDBranchNe,
    input ID_EXRegWrite,
    input EX_MEMMemRead,
    input [4:0] EX_MEMRegisterRd
    );

    initial begin
        Stall = 1'b0;
        Flush = 1'b0;
    end

    always @(*) begin
        if(ID_EXMemRead && (ID_EXrt == IF_IDrs || ID_EXrt == IF_IDrt)) begin
            Stall = 1'b1;
            Flush = 1'b1;
        end

        else if (IDBranchEq || IDBranchNe) begin
        //If a comparison register is a destination of immediately preceding ALU instruction (R type)
            if(ID_EXRegWrite && ID_EXRegisterRd && (IF_IDrs == ID_EXRegisterRd 
|| IF_IDrt == ID_EXRegisterRd)) begin
                Stall = 1'b1;
                Flush = 1'b1;
            end
            //or 2nd preceding load instruction
            else if (EX_MEMMemRead && EX_MEMRegisterRd && (IF_IDrs == EX_MEMRegisterRd 
|| IF_IDrt == EX_MEMRegisterRd ))begin
                Stall = 1'b1;
                Flush = 1'b1;
            end
            else begin
            Stall = 1'b0;
            Flush = 1'b0;
            end
        end
        
        //If a comparison register is a destination of immediately preceding load instruction
        //Dealt by the first hazard situation...

        else begin
            Stall = 1'b0;
            Flush = 1'b0;
        end
    end
endmodule

`endif
