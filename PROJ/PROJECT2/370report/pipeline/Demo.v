`timescale 1ns / 1ps

module Demo(input[4:0] Input_Readreg,
input Input_ReadPC,
input switch,//clock
input SSDoutupper,//upper 4 digits
input clk2,//used for SSD output, W5
output reg [6:0] SSDout,
output reg [3:0] SSDdigit
    );
    
    //wire pipelinedprocessor
    reg [31:0] pcregout;
    wire [31:0] PCout;
    wire [31:0] Regout;
    
    //wire SSDfourdigit
    wire [6:0] SSDdigit1;//left to right
    wire [6:0] SSDdigit2;
    wire [6:0] SSDdigit3;
    wire [6:0] SSDdigit4;
    reg [3:0] pcregout1;
    reg [3:0] pcregout2;
    reg [3:0] pcregout3;
    reg [3:0] pcregout4;
    
    // wire Ringcounter
    wire [3:0] SSDdigitchoice;
    wire clkdivide;
//    wire clkdivide2;
    
    PipelinedProcessor thePipelinedProcessor(.clk(switch),
    .Input_Readreg(Input_Readreg),
    .Input_ReadPC(Input_ReadPC),
    .PCout(PCout),
    .RegOut(Regout)
    );

    
    always @(Input_ReadPC) begin
    if (Input_ReadPC == 1'b1)
        pcregout = PCout;
    else
        pcregout = Regout;    
    end
    
    always @ (SSDoutupper)begin
        if (SSDoutupper==1'b1) begin
           pcregout1 =  pcregout [31:28];
           pcregout2 =  pcregout [27:24];
           pcregout3 =  pcregout [23:20];
           pcregout4 =  pcregout [19:16]; 
        end
        else begin
           pcregout1 =  pcregout [15:12];
           pcregout2 =  pcregout [11:8];
           pcregout3 =  pcregout [7:4];
           pcregout4 =  pcregout [3:0]; 
        end    
    end
    
    SSDfour theSSDfourone (.SSDinput(pcregout1),
    .SSDdigit(SSDdigit1));
    SSDfour theSSDfourtwo (.SSDinput(pcregout2),
    .SSDdigit(SSDdigit2));
    SSDfour theSSDfourthree (.SSDinput(pcregout3),
    .SSDdigit(SSDdigit3));
    SSDfour theSSDfourfour (.SSDinput(pcregout4),
    .SSDdigit(SSDdigit4));


   Clockdivider theClockdivider(.clk(clk2),
   .clkdivide(clkdivide));

   Ringcounter theRingcounter(.clk(clkdivide),
    .SSDdigitchoice(SSDdigitchoice)
    );
    
    always @(SSDdigitchoice or Input_ReadPC or Input_Readreg )begin
        if (SSDdigitchoice==4'b1110) SSDout<=SSDdigit4;
                    else if (SSDdigitchoice==4'b1101) SSDout<=SSDdigit3;
                    else if (SSDdigitchoice==4'b1011) SSDout<=SSDdigit2;
                    else SSDout<=SSDdigit1;
       SSDdigit = SSDdigitchoice; 
                    
    end
    
    
endmodule

