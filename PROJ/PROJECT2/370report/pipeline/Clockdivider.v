`timescale 1ns / 1ps

module Clockdivider(input clk,
output reg clkdivide
    );
    reg [17:0] count;
    always@ (posedge clk)
    begin
    if (count==0) begin count<=count+1; clkdivide<=1;end
    else if (count<199999)begin count<=count+1;clkdivide<=0;end
    else count<=0;
    end
endmodule
