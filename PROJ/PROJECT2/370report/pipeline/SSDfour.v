`timescale 1ns / 1ps

module SSDfour(input [3:0] SSDinput,
output reg [6:0] SSDdigit
    );
    always @(SSDinput,SSDdigit)
    begin
    case (SSDinput)
        4'b0000: SSDdigit=7'b1000000;
        4'b0001: SSDdigit=7'b1111001;
        4'b0010: SSDdigit=7'b0100100;
        4'b0011: SSDdigit=7'b0110000;
        4'b0100: SSDdigit=7'b0011001;
        4'b0101: SSDdigit=7'b0010010;
        4'b0110: SSDdigit=7'b0000010;
        4'b0111: SSDdigit=7'b1111000;
        4'b1000: SSDdigit=7'b0000000;
        4'b1001: SSDdigit=7'b0010000;
        4'b1010: SSDdigit=7'b0001000;
        4'b1011: SSDdigit=7'b0000011;
        4'b1100: SSDdigit=7'b1000110;
        4'b1101: SSDdigit=7'b0100001;
        4'b1110: SSDdigit=7'b0000110;
        4'b1111: SSDdigit=7'b0001110;
        endcase
   end   
endmodule
