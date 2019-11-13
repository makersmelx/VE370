`ifndef MODULE_ALU
`define MODULE_ALU
`timescale 1ns / 1ps

module ALU (
    input       [3:0]   control,
    input       [31:0]  a, b,
    output              zero,
    output reg  [31:0]  result
);

    assign zero = (result == 0);

    initial begin
        result = 32'b0;
    end

    always @ (*) begin
        case (control)
            4'b0000: // AND
                result = a & b;
            4'b0001: // OR
                result = a | b;
            4'b0010: // ADD
                result = a + b;
            4'b0110: // SUB
                result = a - b;
            4'b0111: // SLT
                result = (a < b) ? 1 : 0;
            4'b1100: // NOR
                result = ~(a | b);
            default: ;
        endcase
    end

endmodule 

`endif 
