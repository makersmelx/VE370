`ifndef MODULE_PC
`define MODULE_PC
`timescale 1ns / 1ps

module PC(
    input       clk,stall,
    input       [31:0]  in,
    output reg  [31:0]  out
    );
    
    initial begin
        out = 32'b0; //initialize PC
    end
    
    always @ (posedge clk) begin
        if (!stall)
            out <= in;
    end
    
endmodule
`endif