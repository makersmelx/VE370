add rd, rs, rt #rd =rs + rt
sub rd,rs,rt #rd = rs-rt
addi rt,rs,imm # rt = rs+imm 常值(16-bit,2's)
lw rt, offset(rs) #向rt load mem[rs+offset]  offset 为16-bits, 2's
sw rt,offset(rs) #把rt save mem[rs+offset]
lb,sb,lh,sh,lbn
and,andi,or,ori...sll,srl
beq/bne