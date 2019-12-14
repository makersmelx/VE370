`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/18 11:36:13
// Design Name: 
// Module Name: Cache
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Cache(readWrite, address, writeData, readData, isHit);
input readWrite;
input [9:0] address;
input [7:0] writeData;
output [31:0] readData;
output isHit;


wire hit;
assign isHit = hit;
reg [133:0] cache[0:3];
//in cache
wire valid;
wire dirty;
wire [3:0] tag;
wire [1:0] blockAddr;
wire [1:0] wordOffset;
wire [1:0] byteOffset;
reg [31:0] readDataTmp;
// in main memory
reg [9:0] memAddr;
wire [127:0] memReadData;
reg [127:0] memWriteData;
reg memWrite;

//
wire [3:0] cache_tag;
assign cache_tag = cache[blockAddr][131:128];
// in address
assign tag = address[9:6];
assign blockAddr = address[5:4];
assign wordOffset = address[3:2];
assign byteOffset = address[1:0];

// in cache
assign valid = cache[blockAddr][133];
assign dirty = cache[blockAddr][132];
assign hit = (cache[blockAddr][133] & cache[blockAddr][131:128]==tag);

// mem
MainMemory memory(memWrite, memAddr, memWriteData, memReadData);

//assign cache read out
assign readData = readDataTmp;

always@(address or readWrite) begin
// write back
#1;
if(~hit & dirty) begin
memAddr = {cache[blockAddr][131:128],address[5:0]};
memWriteData = cache[blockAddr][127:0];
memWrite = 1'b1;
#1 memWrite = 1'b0;
end
// read from memory
#1;
if(~hit) begin
memAddr = address; 
#1;
cache[blockAddr][131:128] = tag;
cache[blockAddr][127:0] = memReadData;
cache[blockAddr][132] = 1'b0;
cache[blockAddr][133] = 1'b1;
end
// writing cache
#1;
if(readWrite & hit) begin
cache[blockAddr][132] = 1'b1;
case(wordOffset)
2'b00:begin
case(byteOffset)
2'b00: cache[blockAddr][127:120] = writeData;
2'b01: cache[blockAddr][119:112] = writeData;
2'b10: cache[blockAddr][111:104] = writeData;
2'b11: cache[blockAddr][103:96] = writeData;
endcase
end
2'b01:begin
case(byteOffset)
2'b00: cache[blockAddr][95:88] = writeData;
2'b01: cache[blockAddr][87:80] = writeData;
2'b10: cache[blockAddr][79:72] = writeData;
2'b11: cache[blockAddr][71:64] = writeData;
endcase
end
2'b10:begin
case(byteOffset)
2'b00: cache[blockAddr][63:56] = writeData;
2'b01: cache[blockAddr][55:48] = writeData;
2'b10: cache[blockAddr][47:40] = writeData;
2'b11: cache[blockAddr][39:32] = writeData;
endcase
end
2'b11:begin
case(byteOffset)
2'b00: cache[blockAddr][31:24] = writeData;
2'b01: cache[blockAddr][23:16] = writeData;
2'b10: cache[blockAddr][15:8] = writeData;
2'b11: cache[blockAddr][7:0] = writeData;
endcase
end
endcase
end

// choose the word to read
case(wordOffset)
2'b00:begin
readDataTmp = cache[blockAddr][127:96];
end
2'b01:begin
readDataTmp = cache[blockAddr][95:64];
end
2'b10:begin
readDataTmp = cache[blockAddr][63:32];
end
2'b11:begin
readDataTmp = cache[blockAddr][31:0];
end
endcase

end

//initial cache
initial begin
memWrite = 1'b0;
memWriteData = 128'b0;
cache[0] = {2'b00,4'b1111,128'b0};
cache[1] = {2'b00,4'b1111,128'b0};
cache[2] = {2'b00,4'b1111,128'b0};
cache[3] = {2'b00,4'b1111,128'b0};
end


endmodule