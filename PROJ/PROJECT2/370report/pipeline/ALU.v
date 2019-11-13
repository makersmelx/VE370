`ifndef MODULE_ALU
`define MODULE_ALU
`timescale 1ns / 1ps

module ALU(
    input       [3:0]   ALU_control,
    input       [31:0]  a, b,
    output       zero,
    output reg  [31:0]  result
    );
    
    assign zero = (result == 0);
    
    initial begin
        result = 32'b0;  //to initialize the result
    end
    
    always @ (a or b or ALU_control) begin
        case (ALU_control)
            4'b0000:
                result = a & b;  // and
            4'b0001:
                result = a | b;  // or
            4'b0010:
                result = a + b;  // add
            4'b0110:
                result = a - b;  // sub
            4'b0111:
                result = (a < b) ? 1:0;  // slt
            default:
                result = a;  
        endcase    
    end
endmodule
`endif