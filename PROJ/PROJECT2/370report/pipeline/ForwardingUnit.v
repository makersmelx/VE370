`ifndef MODULE_FORWARDINGUNIT
`define MODULE_FORWARDINGUNIT
`timescale 1ns / 1ps

module ForwardingUnit(
    input [4:0] IDEXrs,
    input [4:0] IDEXrt,
    input [4:0] IFIDrs,
    input [4:0] IFIDrt,
    input [4:0] MEMWBRegisterRd,
    input [4:0] EXMEMRegisterRd,
    input [4:0] IDEXRegisterRd,
    input MEMWBRegWrite,
    input MEMWBMemRead,
    input EXMEMRegWrite,
    input EXMEMMemWrite,
    input IDEXMemWrite,
    input IDEXRegWrite,
    input IFIDbeq,
    input IFIDbne,
    output reg [1:0] ForwardingALUin1,
    output reg [1:0] ForwardingALUin2,
    output reg [1:0] ForwardingEqin1,
    output reg [1:0] ForwardingEqin2,
    output reg MemSrc
    );
    
    initial begin
        ForwardingALUin1 = 2'b00;
        ForwardingALUin2 = 2'b00;
        MemSrc = 1'b00;
    end
    always @(*) begin
    //ForwardingA
        //EX
        if(EXMEMRegWrite && EXMEMRegisterRd && EXMEMRegisterRd == IDEXrs)
            ForwardingALUin1 = 2'b10;
        //MEM
        else if(MEMWBRegWrite && MEMWBRegisterRd && MEMWBRegisterRd == IDEXrs)
            ForwardingALUin1 = 2'b01;
        else 
            ForwardingALUin1 = 2'b00;
        
    //ForwardingB
         //EX
        if(EXMEMRegWrite && EXMEMRegisterRd && EXMEMRegisterRd == IDEXrt && !IDEXMemWrite)
            ForwardingALUin2 = 2'b10;
         //MEM
        else if(MEMWBRegWrite && MEMWBRegisterRd && MEMWBRegisterRd == IDEXrt && !IDEXMemWrite)
            ForwardingALUin2 = 2'b01;
        else 
            ForwardingALUin2 = 2'b00;
    //Memsource
        if(MEMWBRegisterRd == EXMEMRegisterRd && EXMEMMemWrite)      
            MemSrc = 1'b1;
        else
            MemSrc = 1'b0;

    //BEQ using the ALU result or mem result of last instruction

        if(EXMEMRegWrite && EXMEMRegisterRd && 
EXMEMRegisterRd == IFIDrs && (IFIDbeq || IFIDbne))
            ForwardingEqin1 = 2'b10;
        else if (MEMWBMemRead && MEMWBRegWrite && 
MEMWBRegisterRd && MEMWBRegisterRd == IFIDrs && (IFIDbeq || IFIDbne))
            ForwardingEqin1 = 2'b01;
        else
            ForwardingEqin1 = 2'b00;

         if(EXMEMRegWrite && EXMEMRegisterRd && 
EXMEMRegisterRd == IFIDrt && (IFIDbeq || IFIDbne))
            ForwardingEqin2 = 2'b10;
        else if (MEMWBMemRead && MEMWBRegWrite && 
MEMWBRegisterRd && MEMWBRegisterRd == IFIDrt && (IFIDbeq || IFIDbne))
            ForwardingEqin2 = 2'b01;
        else
            ForwardingEqin2 = 2'b00;
    end

endmodule

`endif