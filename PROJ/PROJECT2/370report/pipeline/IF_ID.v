`ifndef MODULE_IF_ID
`define MODULE_IF_ID
`timescale 1ns / 1ps

module IF_ID(
    input Clk,
    input Stall,
    input Flush,
    input [31:0] IFPCplus4,
    input [31:0] IFInstruction,
    output reg [31:0] IDInstruction,
    output reg [31:0] IDPCplus4
    );

    initial begin
        IDInstruction = 32'b0;
        IDPCplus4 = 32'b0;
    end

    always @(posedge Clk) begin
        if(Flush) begin
            IDInstruction <= 32'b0;
            IDPCplus4 <= 32'b0;
        end 
        else if (Stall) begin
            IDInstruction <= IDInstruction;
            IDPCplus4 <= IDPCplus4;
        end
        else begin
            IDInstruction <= IFInstruction;   
            IDPCplus4 <= IFPCplus4;
        end
    end
endmodule

`endif