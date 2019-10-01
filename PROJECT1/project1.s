.text
.globl __start
__start:
    addi $s0,$0,21  #int size = 21
    addi $sp,$sp,-84 #stack for 21*4 items
    
    addu $s1,$0,$0 # int PosCnt = 0
    addu $s2,$0,$0 # int NegCnt = 0
    addu $s3,$0,$0 # int ZeroCnt = 0
    
    addi $t0, $0, 14 # store 1st temporarily in $t0
    sw $t0, 0($sp) #store in testArray[0]
    addi $t0, $0, -15 # store 2nd temporarily in $t0
    sw $t0, 4($sp) #store in testArray[1]
    addi $t0, $0, 0 # store 3th temporarily in $t0
    sw $t0, 8($sp) #store in testArray[2]
    addi $t0, $0, -13 # store 4th temporarily in $t0
    sw $t0, 12($sp) #store in testArray[3]
    addi $t0, $0, -8 # store 5th temporarily in $t0
    sw $t0, 16($sp) #store in testArray[4]
    addi $t0, $0, 16 # store 6th temporarily in $t0
    sw $t0, 20($sp) #store in testArray[5]
    addi $t0, $0, 30 # store 7th temporarily in $t0
    sw $t0, 24($sp) #store in testArray[6]
    addi $t0, $0, -38 # store 8th temporarily in $t0
    sw $t0, 28($sp) #store in testArray[7]
    addi $t0, $0, 24 # store 9th temporarily in $t0
    sw $t0, 32($sp) #store in testArray[8]
    addi $t0, $0, 0 # store 10th temporarily in $t0
    sw $t0, 36($sp) #store in testArray[9]
    addi $t0, $0, 18 # store 11st temporarily in $t0
    sw $t0, 40($sp) #store in testArray[10]
    addi $t0, $0, 14 # store 12nd temporarily in $t0
    sw $t0, 44($sp) #store in testArray[11]
    addi $t0, $0, -30 # store 13th temporarily in $t0
    sw $t0, 48($sp) #store in testArray[12]
    addi $t0, $0, -13 # store 14th temporarily in $t0
    sw $t0, 52($sp) #store in testArray[13]
    addi $t0, $0, -2 # store 15th temporarily in $t0
    sw $t0, 56($sp) #store in testArray[14]
    addi $t0, $0, 17 # store 16th temporarily in $t0
    sw $t0, 60($sp) #store in testArray[15]
    addi $t0, $0, 0 # store 17th temporarily in $t0
    sw $t0, 64($sp) #store in testArray[16]
    addi $t0, $0, -27 # store 18th temporarily in $t0
    sw $t0, 68($sp) #store in testArray[17]
    addi $t0, $0, 11 # store 19th temporarily in $t0
    sw $t0, 72($sp) #store in testArray[18]
    addi $t0, $0, -30 # store 20th temporarily in $t0
    sw $t0, 76($sp) #store in testArray[19]
    addi $t0, $0, 25 # store 21st temporarily in $t0
    sw $t0, 80($sp) #store in testArray[20]

    addu $a0,$0,$sp # a0 = testArray
    addu $a1,$0,$s0 # a1 = size
    addi $a2,$0,1 # a2 = 1
    jal countArray # $v0 = countArray(testArray, size, 1)
    addi $t0, $0, 1  # wait for delay
    addu $s1,$v0,$0 # PosCnt = $v0

    addu $a0,$0,$sp # a0 = testArray
    addu $a1,$0,$s0 # a1 = size
    addi $a2,$0,-1 # a2 = -1
    jal countArray # $v0 = countArray(testArray, size, -1)
    addi $t0, $0, 1  # wait for delay
    add $s2, $v0, $0 # NegCnt = $v0

    addu $a0,$0,$sp # a0 = testArray
    addu $a1,$0,$s0 # a1 = size
    addi $a2,$0,0 # a2 = 0
    jal countArray # $v0 = countArray(testArray, size, 0)
    addi $t0, $0, 1  # wait for delay
    add $s3, $v0, $0 # ZeroCnt = $v0
    jal exit # exit

countArray:
    sw $ra, 84($sp) # save ra into the stack
    addu $t0,$a1,$0 # save $a1(numElements) into $t0
    addu $t1,$a2,$0 # save $a2(cntType) into $t1
    addi $t3,$t0,-1 # t3(i) = numElements - 1
    add $t9, $0,0 # cnt = 0

countArrayFor:
    addi $t0, $0, 1  # wait for delay
    slt $t4,$t3,$0 # t4 = i < 0
    bne $t4,$0,countArrayForEnd # if (i< 0 == 1), the loop ends, go to ForEnd
    sll $t5,$t3,2 # t5 = t3*4
    add $t5,$t5,$sp # t5 =array + t5
    lw $a0,0($t5) # a0 = testArray[i]
    add $t2, $0,1 # t2 = 1
    addi $t0, $0, 1  # wait for delay
    beq $t1,$t2,Case1 #if(cntType == 1) go to Case 1
    addi $t0, $0, 1  # wait for delay
    add $t2,$0,-1 # t2 = -1
    beq $t1,$t2,CaseM1 #if(cntType == -1) go to Case M1(-1)
    addi $t0, $0, 1  # wait for delay
    beq $t1,$0, Case0 #if(cntType == 0) go to Case 0
    j countArrayEsac # jump to end of case
    addi $t0, $0, 1  # wait for delay

Case1:
    jal Pos #v0 = Pos(array[i])
    addi $t0, $0, 1  # wait for delay
    j countArrayEsac # break; jump to end of case
    addi $t0, $0, 1  # wait for delay

CaseM1:
    jal Neg #v0 = Neg(array[i])
    addi $t0, $0, 1  # wait for delay
    j countArrayEsac # break; jump to end of case
    addi $t0, $0, 1  # wait for delay

Case0:
    jal Zero #v0 = Zero(array[i])
    addi $t0, $0, 1  # wait for delay
    j countArrayEsac # break; jump to end of case
    addi $t0, $0, 1  # wait for delay

countArrayEsac:
    addu $t9,$t9,$v0 # cnt+=v0
    add $v0,$0,$0 # reset v0 to 0
    addi $t3,$t3,-1 # i--
    j countArrayFor # next loop
    addi $t0, $0, 1  # wait for delay

countArrayForEnd:
    addi $t0, $0, 1  # wait for delay
    addu $v0,$0,$t9 # v0 = cnt
    lw $ra,84($sp) #recover ra from the stack
    addi $t0, $0, 1  # wait for delay
    jr $ra # return 
    addi $t0, $0, 1  # wait for delay

Pos:
    slt $t5, $0, $a0       # $t5 = 0 < x
    bne $t5, $0, PosIf     # if ($t5 == 1) go to PosIf
    addi $v0, $0, 0         # $v0 = 0
    jr $ra                  # return
    addi $t0, $0, 1  # wait for delay
PosIf:
    addi $v0, $0, 1         # $v0 = 1
    jr $ra                  # return
    addi $t0, $0, 1  # wait for delay
    
Neg:
    slt $t5, $a0, $0       # $t5 = x < 0
    bne $t5, $0, NegIf     # if ($t5 == 1) go to NegIf
    addi $v0, $0, 0         # $v0 = 0
    jr $ra                  # return
    addi $t0, $0, 1  # wait for delay
NegIf:
    addi $v0, $0, 1         # $v0 = 1
    jr $ra                  # return
    addi $t0, $0, 1  # wait for delay
Zero:
    beq $a0, $0, ZeroIf     # if ($a0 == 0) go to ZeroIf
    addi $v0, $0, 0         # $v0 = 0
    jr $ra                  # return
    addi $t0, $0, 1  # wait for delay
ZeroIf:
    addi $v0, $0, 1         # $v0 = 1
    jr $ra                  # return
    addi $t0, $0, 1  # wait for delay

exit:
    addi $v0, $0, 10        # prepare to exit (system call 10)
    syscall                 # exit
