import re

TAG = {}
TAG_C = {}
PROGRAM = []
COMMAND = ['add', 'addi', 'addiu', 'nop', 'lw', 'sw', 'lui', 'addu', 'sub', 'subu', 'and', 'or', 'xor', 'nor', 'andi', 'sll', 'srl', 'sra', 'slt', 'slti', 'ori', 'sltiu', 'beq', 'bne', 'blez', 'bgtz', 'bltz', 'j', 'jal', 'jr', 'jalr']
OPCODE = {'add': '000000', 'addi': '001000', 'addiu': '001001', 'nop': '000000', 'lw': '100011', 'sw': '101011', 'lui': '001111', 'addu': '000000', 'sub': '000000', 'subu': '000000', 'and': '000000', 'or': '000000', 'xor': '000000', 'nor': '000000', 'andi': '001100', 'sll': '000000', 'srl': '000000', 'sra': '000000', 'slt': '000000', 'slti': '001010', 'ori': '001101', 'sltiu': '001011', 'beq': '000100', 'bne': '000101', 'blez': '000110', 'bgtz': '000111', 'bltz': '000001', 'j': '000010', 'jal': '000011', 'jr': '000000', 'jalr': '000000'}
FUNCTION = {'add': '100000', 'nop': '000000', 'addu': '100001', 'sub': '100010', 'subu': '100011', 'and': '100100', 'or': '100101', 'xor': '100110', 'nor': '100111', 'sll': '000000', 'srl': '000010', 'sra': '000011', 'slt': '101010', 'jr': '001000', 'jalr': '001001'}
REGISTER = {'zero': '00000', 'at': '00001', 'v0': '00010', 'v1': '00011', 'a0': '00100', 'a1': '00101', 'a2': '00110', 'a3': '00111', 't0': '01000', 't1': '01001', 't2': '01010', 't3': '01011', 't4': '01100', 't5': '01101', 't6': '01110', 't7': '01111', 's0': '10000', 's1': '10001', 's2': '10010', 's3': '10011', 's4': '10100', 's5': '10101', 's6': '10110', 's7': '10111', 't8': '11000', 't9': '11001', 'k0': '11010', 'k1': '11011', 'gp': '11100', 'sp': '11101', 'fp': '11110', 'ra': '11111', '0': '00000', '1': '00001', '2': '00010', '3': '000011', '4': '00100', '5': '00101', '6': '00110', '7': '00111', '8': '01000', '9': '01001', '10': '01010', '11': '01011', '12': '01100', '13': '01101', '14': '01110', '15': '01111', '16': '10000', '17': '10001', '18': '10010', '19': '10011', '20': '10100', '21': '10101', '22': '10110', '23': '10111', '24': '11000', '25': '11001', '26': '11010', '27': '11011', '28': '11100', '29': '11101', '30': '11110', '31': '11111'}
TYPE = {'add': 'r', 'addi': 'i', 'addiu': 'i', 'nop': 'nop', 'lw': 'lw', 'sw': 'sw', 'lui': 'lui', 'addu': 'r', 'sub': 'r', 'subu': 'r', 'and': 'r', 'or': 'r', 'xor': 'r', 'nor': 'r', 'andi': 'i', 'ori': 'i', 'sll': 'shamt', 'srl': 'shamt', 'sra': 'shamt', 'slt': 'r', 'slti': 'i', 'sltiu': 'i', 'beq': 'br', 'bne': 'br', 'blez': 'bz', 'bgtz': 'bz', 'bltz': 'bz', 'j': 'j', 'jal': 'j', 'jr': 'jr', 'jalr': 'jalr'}


#convert numbers into binary
def ToBin(num, length):                        
    sign = 1
    base = [0, 1]
    num = int(num)
    mid = []
    if num < 0:
        sign = 0
        num += 65536
    while True:
        if num == 0: break
        num, rem = divmod(num, 2)
        mid.append(base[rem])
    while len(mid) < length:
        mid.append(0)
    if sign == 0: mid[length - 1] = 1
    return ''.join([str(x) for x in mid[::-1]])


#read mips program file
def ReadFile():
    commandCount = 0
    f = open('MIPS_program.asm', 'r')
    str = f.readline()
    while str != '':
        if str.find('#') != -1: str = str[0:str.find('#')]
        str = str.replace('(', ' ')
        str = str.replace(')', ' ')
        str = str.replace(',', ' ')
        str = str.replace('$', '')
        Instruction = str.split()
        if len(Instruction) > 0:
            if Instruction[0] in COMMAND:
                PROGRAM.append(Instruction)
                commandCount += 1
            elif Instruction[0].find(':') != -1:
                TAG[Instruction[0]] = commandCount
                TAG_C[commandCount] = Instruction[0]
        str = f.readline()
    f.close()


ReadFile()
count = 0
f = open('BinaryCode.txt', 'w')
for Instruction in PROGRAM:
    if count in TAG_C:
        f.write('\t\t' + '//' + TAG_C[count] + '\n')
    count = count + 1
    Command = Instruction[0]
	
	#normal R-type instruction
    if (TYPE[Command] == 'r'):
        Rd = Instruction[1]
        Rs = Instruction[2]
        Rt = Instruction[3]
        Shamt = '00000'
        BinCode = OPCODE[Command] + REGISTER[Rs] + REGISTER[Rt] + REGISTER[Rd] + Shamt + FUNCTION[Command]
        f.write('\t\t' + '//  ' + Command + ' $' + Rd + ', $' + Rs + ', $' + Rt + '\n')
        f.write('\t\t' + str(count - 1) + ': data <= 32\'b' + BinCode + ';\n')
		
	#normal I-type instruction	
    if (TYPE[Command] == 'i'):
        Rt = Instruction[1]
        Rs = Instruction[2]
        Imm = Instruction[3]
        if (Imm.find('0x') == -1):
            BinCode = OPCODE[Command] + REGISTER[Rs] + REGISTER[Rt] + ToBin(Imm, 16)
        else:
            BinCode = OPCODE[Command] + REGISTER[Rs] + REGISTER[Rt] + ToBin(int(Imm, 16), 16)
        f.write('\t\t' + '//  ' + Command + ' $' + Rt + ', $' + Rs + ', ' + Imm + '\n')
        f.write('\t\t' + str(count - 1) + ': data <= 32\'b' + BinCode + ';\n')
		
	#nop type instruction
    if (TYPE[Command] == 'nop'):
        BinCode = '00000000000000000000000000000000'
        f.write('\t\t' + '//  nop\n')
        f.write('\t\t' + str(count - 1) + ': data <= 32\'b' + BinCode + ';\n')
		
	#lw or sw type instruction
    if (TYPE[Command] == 'lw' or TYPE[Command] == 'sw'):
        Rs = Instruction[3]
        Rt = Instruction[1]
        Imm = Instruction[2]
		#if the immediate is a hex number
        if (Imm.find('0x') == -1):
            BinCode = OPCODE[Command] + REGISTER[Rs] + REGISTER[Rt] + ToBin(Imm, 16)
		#if the immediate is a oct number
        else:
            BinCode = OPCODE[Command] + REGISTER[Rs] + REGISTER[Rt] + ToBin(int(Imm, 16), 16)
        f.write('\t\t' + '//  ' + Command + ' $' + Rt + ', ' + Imm + '(' + '$' + Rs + ')' + '\n')
        f.write('\t\t' + str(count - 1) + ': data <= 32\'b' + BinCode + ';\n')
		
	#lui type instruction
    if (TYPE[Command] == 'lui'):
        Rt = Instruction[1]
        Imm = Instruction[2]
		#if the immediate is a hex number
        if (Imm.find('0x') == -1):
            BinCode = OPCODE[Command] + '00000' + REGISTER[Rt] + ToBin(Imm, 16)
		#if the immediate is a oct number
        else:
            BinCode = OPCODE[Command] + '00000' + REGISTER[Rt] + ToBin(int(Imm, 16), 16)
        f.write('\t\t' + '//  ' + Command + ' $' + Rt + ', ' + Imm + '\n')
        f.write('\t\t' + str(count - 1) + ': data <= 32\'b' + BinCode + ';\n')
		
	#shamt type instruction
    if (TYPE[Command] == 'shamt'):
        Rt = Instruction[2]
        Rd = Instruction[1]
        Shamt = Instruction[3]
        BinCode = OPCODE[Command] + '00000' + REGISTER[Rt] + REGISTER[Rd] + ToBin(Shamt, 5) + FUNCTION[Command]
        f.write('\t\t' + '//  ' + Command + ' $' + Rd + ', $' + Rt + ', ' + Shamt + '\n')
        f.write('\t\t' + str(count - 1) + ': data <= 32\'b' + BinCode + ';\n')
		
	#br type instruction	
    if (TYPE[Command] == 'br'):
        Rs = Instruction[1]
        Rt = Instruction[2]
        Label = Instruction[3]
        Imm = TAG[(Label + ':')] - count
        BinCode = OPCODE[Command] + REGISTER[Rs] + REGISTER[Rt] + ToBin(Imm, 16)
        f.write('\t\t' + '//  ' + Command + ' $' + Rs + ', $' + Rt + ', ' + Label + '\n')
        f.write('\t\t' + str(count - 1) + ': data <= 32\'b' + BinCode + ';\n')
		
	#j type instruction
    if (TYPE[Command] == 'j'):
        Target = Instruction[1]
        Imm = TAG[(Target + ':')]
        BinCode = OPCODE[Command] + ToBin(Imm, 26)
        f.write('\t\t' + '//  ' + Command + ' ' + Target + '\n')
        f.write('\t\t' + str(count - 1) + ': data <= 32\'b' + BinCode + ';\n')
		
	#jr type instruction
    if (TYPE[Command] == 'jr'):
        Rs = Instruction[1]
        BinCode = OPCODE[Command] + REGISTER[Rs] + '000000000000000' + FUNCTION[Command]
        f.write('\t\t' + '//  ' + Command + ' $' + Rs + '\n')
        f.write('\t\t' + str(count - 1) + ': data <= 32\'b' + BinCode + ';\n')
		
	#jalr type instruction
    if (TYPE[Command] == 'jalr'):
        Rs = Instruction[2]
        Rd = Instruction[1]
        BinCode = OPCODE[Command] + REGISTER[Rs] + '00000' + REGISTER[Rd] + '00000' + FUNCTION[Command]
        f.write('\t\t' + '//  ' + Command + ' $' + Rs + ', $' + Rd + '\n')
        f.write('\t\t' + str(count - 1) + ': data <= 32\'b' + BinCode + ';\n')
		
	#bz type instruction
    if (TYPE[Command] == 'bz'):
        Rs = Instruction[1]
        Label = Instruction[2]
        Imm = TAG[(Label + ':')] - count
        BinCode = OPCODE[Command] + REGISTER[Rs] + '00000' + ToBin(Imm, 16)
        f.write('\t\t' + '//  ' + Command + ' $' + Rs + ', ' + Label + '\n')
        f.write('\t\t' + str(count - 1) + ': data <= 32\'b' + BinCode + ';\n')
f.close()
