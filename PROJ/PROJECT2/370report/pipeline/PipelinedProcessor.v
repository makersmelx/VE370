`timescale 1ns / 1ps
`include "ALU.v"
`include "ALUControl.v"
`include "Control.v"
`include "DataMemory.v"
`include "EX_MEM.v"
`include "ForwardingUnit.v"
`include "HazardDetectionUnit.v"
`include "ID_EX.v"
`include "IF_ID.v"
`include "InstructionMemory.v"
`include "MEM_WB.v"
`include "PC.v"
`include "Register.v"
`include "SignExtend.v"
`include "threetwonemux32.v"

module PipelinedProcessor(
    input clk,
    input [4:0] Input_Readreg,
    input Input_ReadPC,
    output [31:0] PCout,
    output [31:0] RegOut
    );


    //WIRE IF
    wire    [31:0]  ifpcin,
                    ifpcout,
                    ifpcplus4,
                    ifinstruction,
                    ifbranchjumpaddress;
    wire            ifbranchjump;// if there is branch or jump, then 1

    //WIRE ID
    wire    [31:0]  idpcplus4,
                    idinstruction,
                    idregdata1,
                    idregdata2,
                    idregdata1final,
                    idregdata2final,
                    idbranchaddress,
                    idjumpaddress,
                    idseimm;
    wire    [25:0]  idjumpinst;
    wire    [5:0]   idop;
    wire    [4:0]   idrs,
                    idrt,
                    idrd;
    wire    [15:0]  idimm;
    wire            idbranch,//if there is successful branch, then 1(beq or bne)
                    idbrancheq,
                    idbranchne,
                    idregwrite,
                    idmemtoreg,
                    idmemwrite,
                    idmemread,
                    idregdst,
                    idALUsrc,
                    equal,
                    jump;
    wire    [1:0]   idALUop;

    //WIRE EX
    wire            exregwrite,
                    exmemtoreg,
                    exmemwrite,
                    exmemread,
                    exregdst,
                    exALUsrc,
                    exzero;
    wire    [1:0]   exALUop;
    wire    [31:0]  exregdata1final,
                    exregdata2final,
                    exseimm,
                    exALUin1final,
                    exALUin2final,
                    exALUresult,
                    ALUin2;
    wire    [5:0]   exfunc;
    wire    [4:0]   exrs,
                    exrt,
                    exrd,
                    exregisterrd;
    wire    [3:0]   exALUctrl;


    //WIRE MEM
    wire    [31:0]  memALUresult,
                    memregdata2,
                    memregdata2final,
                    memwritedata,
                    memdataread;
    wire    [4:0]   memregisterrd;
    wire            memregwrite,
                    memmemtoreg,
                    memmemwrite,
                    memmemread;

    //WIRE WB
    wire            wbregwrite,
                    wbmemtoreg,
                    wbmemread;
    wire    [4:0]   wbregisterrd;
    wire    [31:0]  wbwriteback,
                    wbmemdata,
                    wbALUresult;

    //WIRE FORWARDING
    wire    [1:0]   forwardingeqin1,
                    forwardingeqin2;
    wire            memSrc;
    wire    [1:0]   forwardingALUin1,
                    forwardingALUin2;

    //WIRE Hazard
    wire            stall,
                    ifidflush,
                    idexflush;
                    

    //IF
    PC thePC(
        .clk(clk),
        .stall(stall),
        .in(ifpcin),
        .out(ifpcout)
        );
    InstructionMemory theIM(
        .address(ifpcout),
        .instruction(ifinstruction)
        );
    assign ifpcplus4 = ifpcout + 4;
    assign ifpcin = (ifbranchjump) ? ifbranchjumpaddress : ifpcplus4;

    //IFID
    IF_ID theIFID(.Clk(clk),
    .Stall(stall),
    .Flush(ifidflush),
    .IFPCplus4(ifpcplus4),
    .IFInstruction(ifinstruction),
    .IDInstruction(idinstruction),
    .IDPCplus4(idpcplus4));

    //ID

    assign idop = idinstruction[31:26];
    assign idrs = idinstruction[25:21];
    assign idrt = idinstruction[20:16];
    assign idrd = idinstruction[15:11];
    assign idimm = idinstruction[15:0];
    assign idjumpinst = idinstruction[25:0];
    Control theControl(
        .OpCode(idop),
        .RegWrite(idregwrite),
        .MemtoReg(idmemtoreg),
        .MemWrite(idmemwrite),
        .MemRead(idmemread),
        .ALUOP(idALUop),
        .RegDst(idregdst),
        .ALUSrc(idALUsrc),
        .Jump(jump),
        .Brancheq(idbrancheq),
        .Branchne(idbranchne)
        );

    Register theRegister(
        .clk(clk),
        .reg_write(wbregwrite),
        .read_reg1(idrs),
        .read_reg2(idrt),
        .write_reg(wbregisterrd),
        .Input_Readreg(Input_Readreg),
        .write_data(wbwriteback),
        .read_data1(idregdata1),
        .read_data2(idregdata2),
        .RegOut(RegOut)
        );
    
    SignExtend thesignextend(
        .short_input(idimm),
        .long_out(idseimm)
    );


    threetwonemux32 theEqual1(
        .control(forwardingeqin1),
        .in1(idregdata1),
        .in2(wbwriteback),
        .in3(memALUresult),
        .out(idregdata1final)
    );

    threetwonemux32 theEqual2(
        .control(forwardingeqin2),
        .in1(idregdata2),
        .in2(wbwriteback),
        .in3(memALUresult),
        .out(idregdata2final)
    );

    assign equal = (idregdata1final==idregdata2final) ? 1'b1 : 1'b0;
    
    assign idbranch = (idbrancheq && equal) ||(idbranchne && !equal);
    assign idbranchaddress = idpcplus4+(idseimm<<2);
    assign idjumpaddress[31:28] = idpcplus4[31:28];
    assign idjumpaddress[27:2] = idjumpinst;
    assign idjumpaddress[1:0] = 2'b00;
    assign ifbranchjump = idbranch || jump;
    assign ifbranchjumpaddress = (idbranch) ? idbranchaddress : idjumpaddress;
    assign ifidflush = ifbranchjump && (!stall);
    
    //IDEX
    ID_EX theID_EX(
        .Clk(clk),
        .Flush(idexflush),
        .IDRegWrite(idregwrite),
        .EXRegWrite(exregwrite),
        .IDMemtoReg(idmemtoreg),
        .EXMemtoReg(exmemtoreg),
        .IDMemWrite(idmemwrite),
        .EXMemWrite(exmemwrite),
        .IDMemRead(idmemread),
        .EXMemRead(exmemread),
        .IDALUOp(idALUop),
        .EXALUOp(exALUop),
        .IDRegDst(idregdst),
        .EXRegDst(exregdst),
        .IDALUSrc(idALUsrc),
        .EXALUSrc(exALUsrc),
        .IDRegData1(idregdata1final),
        .IDRegData2(idregdata2final),
        .EXRegData1(exregdata1final),
        .EXRegData2(exregdata2final),
        .IDSignExImm(idseimm),
        .EXSignExImm(exseimm),
        .IDrs(idrs),
        .EXrs(exrs),
        .IDrt(idrt),
        .EXrt(exrt),
        .IDrd(idrd),
        .EXrd(exrd)
    );

    //EX
    assign exregisterrd = (exregdst) ? exrd : exrt;
    assign exfunc = exseimm[5:0];
    assign ALUin2 = (exALUsrc) ? exseimm : exregdata2final;

    threetwonemux32 thefirst(
        .control(forwardingALUin1),
        .in1(exregdata1final),
        .in2(wbwriteback),
        .in3(memALUresult),
        .out(exALUin1final)
    );

    threetwonemux32 thesecond(
        .control(forwardingALUin2),
        .in1(ALUin2),
        .in2(wbwriteback),
        .in3(memALUresult),
        .out(exALUin2final)
    );

    ALUControl theALUcontrol(
        .func(exfunc),
        .op(exALUop),
        .ctrl(exALUctrl)
    );

    ALU theALU(
        .ALU_control(exALUctrl),
        .a(exALUin1final),
        .b(exALUin2final),
        .zero(exzero),
        .result(exALUresult)
    );

    //EXMEM
    EX_MEM theEX_MEM(
        .Clk(clk),
        .EXRegWrite(exregwrite),
        .MEMRegWrite(memregwrite),
        .EXMemtoReg(exmemtoreg),
        .MEMMemtoReg(memmemtoreg),
        .EXMemWrite(exmemwrite),
        .MEMMemWrite(memmemwrite),
        .ExMemRead(exmemread),
        .MEMMemRead(memmemread),
        .EXALUResult(exALUresult),
        .MEMALUResult(memALUresult),
        .EXRegData2(exregdata2final),
        .MEMRegData2(memregdata2final),
        .EXRegisterRd(exregisterrd),
        .MEMRegisterRd(memregisterrd)
    );

    //MEM
    assign memwritedata = (memSrc) ? wbwriteback : memregdata2final;

    DataMemory thedatamemory(
        .clk(clk),
        .mem_read(memmemread),
        .mem_write(memmemwrite),
        .address(memALUresult),
        .data_write(memwritedata),
        .data_read(memdataread)
    );

    //MEMWB
    MEM_WB theMEM_WB(
        .Clk(clk),
        .MEMRegWrite(memregwrite),
        .WBRegWrite(wbregwrite),
        .MEMMemtoReg(memmemtoreg),
        .WBMemtoReg(wbmemtoreg),
        .MEMMemData(memdataread),
        .WBMMemData(wbmemdata),
        .MEMALUResult(memALUresult),
        .WBALUResult(wbALUresult),
        .MEMRegisterRd(memregisterrd),
        .WBRegisterRd(wbregisterrd)
    );

    //WB
    assign wbwriteback = (wbmemtoreg) ? wbmemdata : wbALUresult;

    //Forwarding
    ForwardingUnit theForwarding(
        .IDEXrs(exrs),
        .IDEXrt(exrt),
        .IFIDrs(idrs),
        .IFIDrt(idrt),
        .MEMWBRegisterRd(wbregisterrd),
        .EXMEMRegisterRd(memregisterrd),
        .IDEXRegisterRd(exregisterrd),
        .MEMWBRegWrite(wbregwrite),
        .MEMWBMemRead(wbmemread),
        .EXMEMRegWrite(memregwrite),
        .EXMEMMemWrite(memmemwrite),
        .IDEXMemWrite(exmemwrite),
        .IDEXRegWrite(exregwrite),
        .IFIDbeq(idbrancheq),
        .IFIDbne(idbranchne),
        .ForwardingALUin1(forwardingALUin1),
        .ForwardingALUin2(forwardingALUin2),
        .ForwardingEqin1(forwardingeqin1),
        .ForwardingEqin2(forwardingeqin2),
        .MemSrc(memSrc)
    );

    //Hazard
    HazardDetectionUnit thehazard(
        .Stall(stall),
        .Flush(idexflush),
        .IF_IDrs(idrs),
        .IF_IDrt(idrt),
        .ID_EXrt(exrt),
        .ID_EXRegisterRd(exregisterrd),
        .ID_EXMemRead(exmemread),
        .IDBranchEq(idbrancheq),
        .IDBranchNe(idbranchne),
        .ID_EXRegWrite(exregwrite),
        .EX_MEMMemRead(memmemread),
        .EX_MEMRegisterRd(memregisterrd)
    );

    //output
    assign PCout = ifpcout;
 

endmodule
