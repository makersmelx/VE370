`timescale 1ns / 1ps

module Ringcounter(input clk,
output reg [3:0] SSDdigitchoice

    );
    always@(posedge clk)begin
    if (SSDdigitchoice==4'b1110) SSDdigitchoice<=4'b1101;
    else if (SSDdigitchoice==4'b1101) SSDdigitchoice<=4'b1011;
    else if (SSDdigitchoice==4'b1011) SSDdigitchoice<=4'b0111;
    else  SSDdigitchoice<=4'b1110;
    end
endmodule
