`ifndef MODULE_ALUCONTROL
`define MODULE_ALUCONTROL
`timescale 1ns / 1ps

module ALUControl(
    input [5:0] func, // function
    input [1:0] op,   // operation
    output reg [3:0] ctrl
    );
    always @(func or op) begin
        if (op == 2'b00)
            ctrl = 4'b0010; //add
        else if (op == 2'b01)
            ctrl = 4'b0110; //minus
        else if (op == 2'b10)
            begin
                if (func == 6'b100000)
                    ctrl = 4'b0010;
                else if (func == 6'b100010)
                    ctrl = 4'b0110;
                else if (func == 6'b100100)
                    ctrl = 4'b0000;
                else if (func == 6'b100101)
                    ctrl = 4'b0001;
                else if (func == 6'b101010)
                    ctrl = 4'b0111;
            end
        else if (op == 2'b11) //and
            ctrl = 4'b0000;
    end
endmodule
`endif