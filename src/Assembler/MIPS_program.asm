j INIT
j INTER
j EXCEPT

#########################INIT#########################
INIT:
addi $t0, $zero, 0x0014  
jr $t0                   #clear PC to enable interrupt
######################################################

########################Timer#########################
lui $s0, 0x4000          #s0 base address of peripheral
sw, $zero, 8($s0)        #initialize the timer
addi $s1, $zero, -25000
sw $s1, 0($s0)           #initialize the timer
addi $s1, $zero, -1
sw $s1, 4($s0)           #initialize the timer
addi $s1, $zero, 3
sw $s1, 8($s0)           #turned on the timer
######################################################

#####################UART RECEIVE#####################
sw $t0, 32($s0)          #initialize uart
UART_START:
addi $s1, $zero, -1

UART_LOOP:
lw $t0, 32($s0)
andi $t0, $t0, 0x08
beq $t0, $zero, UART_LOOP
lw $v1, 28($s0)          #read UART data
beq $v1, $zero, UART_LOOP
beq $s1, $zero LOAD_2
addi $s4, $v1, 0         #get the first number
addi $s1, $s1, 1
j UART_LOOP

LOAD_2:
addi $s3, $v1, 0         #get the second number
addi $v0, $s4, 0
######################################################

#########################GCD##########################
GCD:
beq $v0, $zero, ANS1
beq $v1, $zero, ANS2
sub $t3, $v0, $v1
bgtz $t3 LOOP1
bltz $t3 LOOP2

LOOP1:
sub $v0, $v0, $v1
j GCD

LOOP2:
sub $v1, $v1, $v0
j GCD

ANS1:
add $a0, $v1, $zero
j RESULT_DISPLAY

ANS2:
add $a0, $v0, $zero

RESULT_DISPLAY:
sw $a0, 12($s0)          #LED display of result
######################################################

######################UART SEND BACK##################    
UART_SEND_BACK:
lw $t0, 32($s0)
andi $t0, $t0, 0x10
bne $t0, $zero, UART_SEND_BACK
sw $a0, 24($s0)
j UART_START
########################################################

#######################INTERRUPTON###################### 
INTER:
lw $t7, 8($s0) 
andi $t7, $t7, 0xfff9
sw $t7, 8($s0)           #clear interrupt status and disable interrupt
addi $t3, $zero 1
addi $t4, $zero 2
addi $t5, $zero 4
addi $t6, $zero 8
lw $t7, 20($s0)
andi $t7, $t7, 0xf00
srl $t7, $t7, 8          #read the current status of digital_tube
beq $t7, $t3, DIGITAL_TUBE_1
beq $t7, $t4, DIGITAL_TUBE_2
beq $t7, $t5, DIGITAL_TUBE_3

DIGITAL_TUBE_0:          #prepare data for digital tube 0
andi $s5, $s3, 0x0f
jal DECODE
addi $s5, $s2, 0x100
j DIGITAL_TUBE_DISPLAY

DIGITAL_TUBE_1:          #prepare data for digital tube 1
andi $s5, $s3, 0xf0
srl $s5, $s5, 4
jal DECODE
addi $s5, $s2, 0x200
j DIGITAL_TUBE_DISPLAY

DIGITAL_TUBE_2:          #prepare data for digital tube 2
andi $s5, $s4, 0x0f
jal DECODE
addi $s5, $s2, 0x400
j DIGITAL_TUBE_DISPLAY

DIGITAL_TUBE_3:          #prepare data for digital tube 3
andi $s5, $s4, 0xf0
srl $s5, $s5, 4
jal DECODE
addi $s5, $s2, 0x800
j DIGITAL_TUBE_DISPLAY

DECODE:                  #decode of '0'
addi $s2, $zero, 0xc0
beq $zero, $s5, DECODE_COMPLETE
addi $s2, $zero, 0xf9    #decode of '1'
addi $s6, $zero, 1
beq $s6, $s5, DECODE_COMPLETE
addi $s2, $zero, 0xa4    #decode of '2'
addi $s6, $zero, 2
beq $s6, $s5, DECODE_COMPLETE
addi $s2, $zero, 0xb0    #decode of '3'
addi $s6, $zero, 3
beq $s6, $s5, DECODE_COMPLETE
addi $s2, $zero, 0x99    #decode of '4'
addi $s6, $zero, 4
beq $s6, $s5, DECODE_COMPLETE
addi $s2, $zero, 0x92    #decode of '5'
addi $s6, $zero, 5
beq $s6, $s5, DECODE_COMPLETE
addi $s2, $zero, 0x82    #decode of '6'
addi $s6, $zero, 6
beq $s6, $s5, DECODE_COMPLETE
addi $s2, $zero, 0xf8    #decode of '7'
addi $s6, $zero, 7
beq $s6, $s5, DECODE_COMPLETE
addi $s2, $zero, 0x80    #decode of '8'
addi $s6, $zero, 8
beq $s6, $s5, DECODE_COMPLETE
addi $s2, $zero, 0x90    #decode of '9'
addi $s6, $zero, 9
beq $s6, $s5, DECODE_COMPLETE
addi $s2, $zero, 0x88    #decode of 'A'
addi $s6, $zero, 0x0a
beq $s6, $s5, DECODE_COMPLETE
addi $s2, $zero, 0x83    #decode of 'B'
addi $s6, $zero, 0x0b
beq $s6, $s5, DECODE_COMPLETE
addi $s2, $zero, 0xc6    #decode of 'C'
addi $s6, $zero, 0x0c
beq $s6, $s5, DECODE_COMPLETE
addi $s2, $zero, 0xa1    #decode of 'D'
addi $s6, $zero, 0x0d
beq $s6, $s5, DECODE_COMPLETE
addi $s2, $zero, 0x86    #decode of 'E'
addi $s6, $zero, 0x0e
beq $s6, $s5, DECODE_COMPLETE
addi $s2, $zero, 0x8e    #decode of 'F'


DECODE_COMPLETE:
jr $ra


DIGITAL_TUBE_DISPLAY:
sw $s5, 20($s0)
lw $t3, 8($s0)
addi $t4, $zero, 2
or $t3, $t3, $t4
sw $t3, 8($s0)           # TCON |= 0x00000002
addi $26, $26, -4
jr $26


######################EXCEPTION#########################
EXCEPT:
nop