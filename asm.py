mem = []
for i in range(0,1024):
    mem.append('00000000')

f = open("code.txt", 'r')

labels = {}
labelsReverse = {}
instructions = []
lines = f.readlines()
counter = 0
for line in lines:
    if line[-1] == '\n':
        line = line[0:-1]
    if not line:
        continue
    line = line.split('#', 1)[0]
    parts = line.split(':')
    if len(parts) != 1:
        labels[parts[0]] = counter
        labelsReverse[counter] = parts[0]
        instructions.append(parts[1])
    else:
        instructions.append(parts[0])
    counter += 1
f.close()

code = []
memCounter = 512
counter = 0
labelMap = {}
for ins in instructions:
    ins = ins.lower()
    splt = ins.split(' ', 1)
    header = splt[0]
    rest = ''
    if counter in labelsReverse:
        labelMap[labelsReverse[counter]] = memCounter
    if header == 'hlt':
        mem[memCounter] = "11111000"
        memCounter += 1
    elif header == 'nop':
        mem[memCounter] = "11111001"
        memCounter += 1
    elif header == 'ret':
        mem[memCounter] = "11111010"
        memCounter += 1
    elif header == 'iret':
        mem[memCounter] = "11111011"
        memCounter += 1
    elif header == 'cli':
        mem[memCounter] = "11111100"
        memCounter += 1
    elif header == 'sti':
        mem[memCounter] = "11111101"
        memCounter += 1
    elif header == 'clc':
        mem[memCounter] = "11111110"
        memCounter += 1
    elif header == 'stc':
        mem[memCounter] = "11111111"
        memCounter += 1
    elif header == 'in':
        mem[memCounter] = "10111100"
        memCounter += 1
        mem[memCounter] = "00000000"
        memCounter += 1
    elif header == 'out':
        mem[memCounter] = "10111101"
        memCounter += 1
        mem[memCounter] = "00000000"
        memCounter += 1
    elif header == 'int':
        mem[memCounter] = "11101111"
        memCounter += 1
        mem[memCounter] = splt[1]
        memCounter += 1
    elif header == 'jmp':
        mem[memCounter] = "11100000"
        memCounter += 1
        mem[memCounter] = splt[1][8:]
        memCounter += 1
        mem[memCounter] = splt[1][:8]
        memCounter += 1
    elif header == 'je':
        mem[memCounter] = "11100001"
        memCounter += 1
        mem[memCounter] = splt[1][8:]
        memCounter += 1
        mem[memCounter] = splt[1][:8]
        memCounter += 1
    elif header == 'jne':
        mem[memCounter] = "11100010"
        memCounter += 1
        mem[memCounter] = splt[1][8:]
        memCounter += 1
        mem[memCounter] = splt[1][:8]
        memCounter += 1
    elif header == 'jg':
        mem[memCounter] = "11100011"
        memCounter += 1
        mem[memCounter] = splt[1][8:]
        memCounter += 1
        mem[memCounter] = splt[1][:8]
        memCounter += 1
    elif header == 'jge':
        mem[memCounter] = "11100100"
        memCounter += 1
        mem[memCounter] = splt[1][8:]
        memCounter += 1
        mem[memCounter] = splt[1][:8]
        memCounter += 1
    elif header == 'jl':
        mem[memCounter] = "11100101"
        memCounter += 1
        mem[memCounter] = splt[1][8:]
        memCounter += 1
        mem[memCounter] = splt[1][:8]
        memCounter += 1
    elif header == 'jle':
        mem[memCounter] = "11100110"
        memCounter += 1
        mem[memCounter] = splt[1][8:]
        memCounter += 1
        mem[memCounter] = splt[1][:8]
        memCounter += 1
    elif header == 'jp':
        mem[memCounter] = "11100111"
        memCounter += 1
        mem[memCounter] = splt[1][8:]
        memCounter += 1
        mem[memCounter] = splt[1][:8]
        memCounter += 1
    elif header == 'jnp':
        mem[memCounter] = "11101000"
        memCounter += 1
        mem[memCounter] = splt[1][8:]
        memCounter += 1
        mem[memCounter] = splt[1][:8]
        memCounter += 1
    elif header == 'jo':
        mem[memCounter] = "11101001"
        memCounter += 1
        mem[memCounter] = splt[1][8:]
        memCounter += 1
        mem[memCounter] = splt[1][:8]
        memCounter += 1
    elif header == 'jno':
        mem[memCounter] = "11101010"
        memCounter += 1
        mem[memCounter] = splt[1][8:]
        memCounter += 1
        mem[memCounter] = splt[1][:8]
        memCounter += 1
    elif header == 'loop':
        mem[memCounter] = "11101011"
        memCounter += 1
        mem[memCounter] = splt[1][8:]
        memCounter += 1
        mem[memCounter] = splt[1][:8]
        memCounter += 1
    elif header == 'loope':
        mem[memCounter] = "11101100"
        memCounter += 1
        mem[memCounter] = splt[1][8:]
        memCounter += 1
        mem[memCounter] = splt[1][:8]
        memCounter += 1
    elif header == 'loopne':
        mem[memCounter] = "11101101"
        memCounter += 1
        mem[memCounter] = splt[1][8:]
        memCounter += 1
        mem[memCounter] = splt[1][:8]
        memCounter += 1
    elif header == 'call':
        mem[memCounter] = "11101110"
        memCounter += 1
        mem[memCounter] = splt[1][8:]
        memCounter += 1
        mem[memCounter] = splt[1][:8]
        memCounter += 1
    elif header == 'neg':
        m = '100000'
        if splt[1] == 'ax':
            m += '00'
        elif splt[1] == 'bx':
            m += '01'
        elif splt[1] == 'cx':
            m += '10'
        elif splt[1] == 'dx':
            m += '11'
        mem[memCounter] = m
        memCounter += 1
    elif header == 'not':
        m = '100001'
        if splt[1] == 'ax':
            m += '00'
        elif splt[1] == 'bx':
            m += '01'
        elif splt[1] == 'cx':
            m += '10'
        elif splt[1] == 'dx':
            m += '11'
        mem[memCounter] = m
        memCounter += 1
    elif header == 'inc':
        m = '100010'
        if splt[1] == 'ax':
            m += '00'
        elif splt[1] == 'bx':
            m += '01'
        elif splt[1] == 'cx':
            m += '10'
        elif splt[1] == 'dx':
            m += '11'
        mem[memCounter] = m
        memCounter += 1
    elif header == 'dec':
        m = '100011'
        if splt[1] == 'ax':
            m += '00'
        elif splt[1] == 'bx':
            m += '01'
        elif splt[1] == 'cx':
            m += '10'
        elif splt[1] == 'dx':
            m += '11'
        mem[memCounter] = m
        memCounter += 1
    elif header == 'rcl':
        m = '100100'
        if splt[1] == 'ax':
            m += '00'
        elif splt[1] == 'bx':
            m += '01'
        elif splt[1] == 'cx':
            m += '10'
        elif splt[1] == 'dx':
            m += '11'
        mem[memCounter] = m
        memCounter += 1
    elif header == 'rcr':
        m = '100101'
        if splt[1] == 'ax':
            m += '00'
        elif splt[1] == 'bx':
            m += '01'
        elif splt[1] == 'cx':
            m += '10'
        elif splt[1] == 'dx':
            m += '11'
        mem[memCounter] = m
        memCounter += 1
    elif header == 'rol':
        m = '100110'
        if splt[1] == 'ax':
            m += '00'
        elif splt[1] == 'bx':
            m += '01'
        elif splt[1] == 'cx':
            m += '10'
        elif splt[1] == 'dx':
            m += '11'
        mem[memCounter] = m
        memCounter += 1
    elif header == 'ror':
        m = '100111'
        if splt[1] == 'ax':
            m += '00'
        elif splt[1] == 'bx':
            m += '01'
        elif splt[1] == 'cx':
            m += '10'
        elif splt[1] == 'dx':
            m += '11'
        mem[memCounter] = m
        memCounter += 1
    elif header == 'sahr':
        m = '101000'
        if splt[1] == 'ax':
            m += '00'
        elif splt[1] == 'bx':
            m += '01'
        elif splt[1] == 'cx':
            m += '10'
        elif splt[1] == 'dx':
            m += '11'
        mem[memCounter] = m
        memCounter += 1
    elif header == 'sar':
        m = '101001'
        if splt[1] == 'ax':
            m += '00'
        elif splt[1] == 'bx':
            m += '01'
        elif splt[1] == 'cx':
            m += '10'
        elif splt[1] == 'dx':
            m += '11'
        mem[memCounter] = m
        memCounter += 1
    elif header == 'sal':
        m = '101010'
        if splt[1] == 'ax':
            m += '00'
        elif splt[1] == 'bx':
            m += '01'
        elif splt[1] == 'cx':
            m += '10'
        elif splt[1] == 'dx':
            m += '11'
        mem[memCounter] = m
        memCounter += 1
    elif header == 'shl':
        m = '101011'
        if splt[1] == 'ax':
            m += '00'
        elif splt[1] == 'bx':
            m += '01'
        elif splt[1] == 'cx':
            m += '10'
        elif splt[1] == 'dx':
            m += '11'
        mem[memCounter] = m
        memCounter += 1
    elif header == 'shr':
        m = '101100'
        if splt[1] == 'ax':
            m += '00'
        elif splt[1] == 'bx':
            m += '01'
        elif splt[1] == 'cx':
            m += '10'
        elif splt[1] == 'dx':
            m += '11'
        mem[memCounter] = m
        memCounter += 1
    elif header == 'pop':
        m = '101101'
        if splt[1] == 'ax':
            m += '00'
        elif splt[1] == 'bx':
            m += '01'
        elif splt[1] == 'cx':
            m += '10'
        elif splt[1] == 'dx':
            m += '11'
        mem[memCounter] = m
        memCounter += 1
    elif header == 'push':
        m = '101110'
        if splt[1] == 'ax':
            m += '00'
        elif splt[1] == 'bx':
            m += '01'
        elif splt[1] == 'cx':
            m += '10'
        elif splt[1] == 'dx':
            m += '11'
        mem[memCounter] = m
        memCounter += 1
    elif header == 'add':
        m = '0000'
        b2 = ''
        b3 = ''
        spltt = splt[1].split(',')
        if(spltt[1] == 'ax'):
            b2 += '00000000'
            m += '0'
        elif(spltt[1] == 'bx'):
            b2 += '00100000'
            m += '0'
        elif(spltt[1] == 'cx'):
            b2 += '01000000'
            m += '0'
        elif(spltt[1] == 'dx'):
            b2 += '01100000'
            m += '0'
        elif(spltt[1] == 'sp'):
            b2 += '10000000'
            m += '0'
        else:
            m += '1'
            b2 = spltt[1][8:]
            b3 = spltt[1][:8]
        if spltt[0] == 'ax':
            m += '000'
        elif spltt[0] == 'bx':
            m += '001'
        elif spltt[0] == 'cx':
            m += '010'
        elif spltt[0] == 'dx':
            m += '011'
        elif spltt[0] == 'sp':
            m += '100'
        mem[memCounter] = m
        memCounter += 1
        mem[memCounter] = b2
        memCounter += 1
        if(b3 != ''):
            mem[memCounter] = b3
            memCounter += 1
    elif header == 'sub':
        m = '0001'
        b2 = ''
        b3 = ''
        spltt = splt[1].split(',')
        if(spltt[1] == 'ax'):
            b2 += '00000000'
            m += '0'
        elif(spltt[1] == 'bx'):
            b2 += '00100000'
            m += '0'
        elif(spltt[1] == 'cx'):
            b2 += '01000000'
            m += '0'
        elif(spltt[1] == 'dx'):
            b2 += '01100000'
            m += '0'
        elif(spltt[1] == 'sp'):
            b2 += '10000000'
            m += '0'
        else:
            m += '1'
            b2 = spltt[1][8:]
            b3 = spltt[1][:8]
        if spltt[0] == 'ax':
            m += '000'
        elif spltt[0] == 'bx':
            m += '001'
        elif spltt[0] == 'cx':
            m += '010'
        elif spltt[0] == 'dx':
            m += '011'
        elif spltt[0] == 'sp':
            m += '100'
        mem[memCounter] = m
        memCounter += 1
        mem[memCounter] = b2
        memCounter += 1
        if(b3 != ''):
            mem[memCounter] = b3
            memCounter += 1
    elif header == 'mul':
        m = '0010'
        b2 = ''
        b3 = ''
        spltt = splt[1].split(',')
        if(spltt[1] == 'ax'):
            b2 += '00000000'
            m += '0'
        elif(spltt[1] == 'bx'):
            b2 += '00100000'
            m += '0'
        elif(spltt[1] == 'cx'):
            b2 += '01000000'
            m += '0'
        elif(spltt[1] == 'dx'):
            b2 += '01100000'
            m += '0'
        elif(spltt[1] == 'sp'):
            b2 += '10000000'
            m += '0'
        else:
            m += '1'
            b2 = spltt[1][8:]
            b3 = spltt[1][:8]
        if spltt[0] == 'ax':
            m += '000'
        elif spltt[0] == 'bx':
            m += '001'
        elif spltt[0] == 'cx':
            m += '010'
        elif spltt[0] == 'dx':
            m += '011'
        elif spltt[0] == 'sp':
            m += '100'
        mem[memCounter] = m
        memCounter += 1
        mem[memCounter] = b2
        memCounter += 1
        if(b3 != ''):
            mem[memCounter] = b3
            memCounter += 1
    elif header == 'and':
        m = '0011'
        b2 = ''
        b3 = ''
        spltt = splt[1].split(',')
        if(spltt[1] == 'ax'):
            b2 += '00000000'
            m += '0'
        elif(spltt[1] == 'bx'):
            b2 += '00100000'
            m += '0'
        elif(spltt[1] == 'cx'):
            b2 += '01000000'
            m += '0'
        elif(spltt[1] == 'dx'):
            b2 += '01100000'
            m += '0'
        elif(spltt[1] == 'sp'):
            b2 += '10000000'
            m += '0'
        else:
            m += '1'
            b2 = spltt[1][8:]
            b3 = spltt[1][:8]
        if spltt[0] == 'ax':
            m += '000'
        elif spltt[0] == 'bx':
            m += '001'
        elif spltt[0] == 'cx':
            m += '010'
        elif spltt[0] == 'dx':
            m += '011'
        elif spltt[0] == 'sp':
            m += '100'
        mem[memCounter] = m
        memCounter += 1
        mem[memCounter] = b2
        memCounter += 1
        if(b3 != ''):
            mem[memCounter] = b3
            memCounter += 1
    elif header == 'or':
        m = '0100'
        b2 = ''
        b3 = ''
        spltt = splt[1].split(',')
        if(spltt[1] == 'ax'):
            b2 += '00000000'
            m += '0'
        elif(spltt[1] == 'bx'):
            b2 += '00100000'
            m += '0'
        elif(spltt[1] == 'cx'):
            b2 += '01000000'
            m += '0'
        elif(spltt[1] == 'dx'):
            b2 += '01100000'
            m += '0'
        elif(spltt[1] == 'sp'):
            b2 += '10000000'
            m += '0'
        else:
            m += '1'
            b2 = spltt[1][8:]
            b3 = spltt[1][:8]
        if spltt[0] == 'ax':
            m += '000'
        elif spltt[0] == 'bx':
            m += '001'
        elif spltt[0] == 'cx':
            m += '010'
        elif spltt[0] == 'dx':
            m += '011'
        elif spltt[0] == 'sp':
            m += '100'
        mem[memCounter] = m
        memCounter += 1
        mem[memCounter] = b2
        memCounter += 1
        if(b3 != ''):
            mem[memCounter] = b3
            memCounter += 1
    elif header == 'xor':
        m = '0101'
        b2 = ''
        b3 = ''
        spltt = splt[1].split(',')
        if(spltt[1] == 'ax'):
            b2 += '00000000'
            m += '0'
        elif(spltt[1] == 'bx'):
            b2 += '00100000'
            m += '0'
        elif(spltt[1] == 'cx'):
            b2 += '01000000'
            m += '0'
        elif(spltt[1] == 'dx'):
            b2 += '01100000'
            m += '0'
        elif(spltt[1] == 'sp'):
            b2 += '10000000'
            m += '0'
        else:
            m += '1'
            b2 = spltt[1][8:]
            b3 = spltt[1][:8]
        if spltt[0] == 'ax':
            m += '000'
        elif spltt[0] == 'bx':
            m += '001'
        elif spltt[0] == 'cx':
            m += '010'
        elif spltt[0] == 'dx':
            m += '011'
        elif spltt[0] == 'sp':
            m += '100'
        mem[memCounter] = m
        memCounter += 1
        mem[memCounter] = b2
        memCounter += 1
        if(b3 != ''):
            mem[memCounter] = b3
            memCounter += 1
    elif header == 'cmp':
        m = '0110'
        b2 = ''
        b3 = ''
        spltt = splt[1].split(',')
        if(spltt[1] == 'ax'):
            b2 += '00000000'
            m += '0'
        elif(spltt[1] == 'bx'):
            b2 += '00100000'
            m += '0'
        elif(spltt[1] == 'cx'):
            b2 += '01000000'
            m += '0'
        elif(spltt[1] == 'dx'):
            b2 += '01100000'
            m += '0'
        elif(spltt[1] == 'sp'):
            b2 += '10000000'
            m += '0'
        else:
            m += '1'
            b2 = spltt[1][8:]
            b3 = spltt[1][:8]
        if spltt[0] == 'ax':
            m += '000'
        elif spltt[0] == 'bx':
            m += '001'
        elif spltt[0] == 'cx':
            m += '010'
        elif spltt[0] == 'dx':
            m += '011'
        elif spltt[0] == 'sp':
            m += '100'
        mem[memCounter] = m
        memCounter += 1
        mem[memCounter] = b2
        memCounter += 1
        if(b3 != ''):
            mem[memCounter] = b3
            memCounter += 1
    elif header == 'test':
        m = '0111'
        b2 = ''
        b3 = ''
        spltt = splt[1].split(',')
        if(spltt[1] == 'ax'):
            b2 += '00000000'
            m += '0'
        elif(spltt[1] == 'bx'):
            b2 += '00100000'
            m += '0'
        elif(spltt[1] == 'cx'):
            b2 += '01000000'
            m += '0'
        elif(spltt[1] == 'dx'):
            b2 += '01100000'
            m += '0'
        elif(spltt[1] == 'sp'):
            b2 += '10000000'
            m += '0'
        else:
            m += '1'
            b2 = spltt[1][8:]
            b3 = spltt[1][:8]
        if spltt[0] == 'ax':
            m += '000'
        elif spltt[0] == 'bx':
            m += '001'
        elif spltt[0] == 'cx':
            m += '010'
        elif spltt[0] == 'dx':
            m += '011'
        elif spltt[0] == 'sp':
            m += '100'
        mem[memCounter] = m
        memCounter += 1
        mem[memCounter] = b2
        memCounter += 1
        if(b3 != ''):
            mem[memCounter] = b3
            memCounter += 1
    elif header == 'ldv':
        m = '11000'
        spltt = splt[1].split(',')
        if spltt[0] == 'ax':
            m += '000'
        elif spltt[0] == 'bx':
            m += '001'
        elif spltt[0] == 'cx':
            m += '010'
        elif spltt[0] == 'dx':
            m += '011'
        elif spltt[0] == 'sp':
            m += '100'
        mem[memCounter] = m
        memCounter += 1
        mem[memCounter] = spltt[1][8:]
        memCounter += 1
        mem[memCounter] = spltt[1][:8]
        memCounter += 1
    elif header == 'ldr':
        m = '11001'
        spltt = splt[1].split(',')
        if spltt[0] == 'ax':
            m += '000'
        elif spltt[0] == 'bx':
            m += '001'
        elif spltt[0] == 'cx':
            m += '010'
        elif spltt[0] == 'dx':
            m += '011'
        elif spltt[0] == 'sp':
            m += '100'
        mem[memCounter] = m
        memCounter += 1
        mem[memCounter] = spltt[1][8:]
        memCounter += 1
        mem[memCounter] = spltt[1][:8]
        memCounter += 1
    elif header == 'str':
        m = '11010'
        spltt = splt[1].split(',')
        if spltt[0] == 'ax':
            m += '000'
        elif spltt[0] == 'bx':
            m += '001'
        elif spltt[0] == 'cx':
            m += '010'
        elif spltt[0] == 'dx':
            m += '011'
        elif spltt[0] == 'sp':
            m += '100'
        mem[memCounter] = m
        memCounter += 1
        mem[memCounter] = spltt[1][8:]
        memCounter += 1
        mem[memCounter] = spltt[1][:8]
        memCounter += 1
    elif header == 'mov':
        m = '11011'
        spltt = splt[1].split(',')
        b2 = ''
        if(spltt[1] == 'ax'):
            b2 += '00000000'
        elif(spltt[1] == 'bx'):
            b2 += '00100000'
        elif(spltt[1] == 'cx'):
            b2 += '01000000'
        elif(spltt[1] == 'dx'):
            b2 += '01100000'
        elif(spltt[1] == 'sp'):
            b2 += '10000000'
        if spltt[0] == 'ax':
            m += '000'
        elif spltt[0] == 'bx':
            m += '001'
        elif spltt[0] == 'cx':
            m += '010'
        elif spltt[0] == 'dx':
            m += '011'
        elif spltt[0] == 'sp':
            m += '100'
        mem[memCounter] = m
        memCounter += 1
        mem[memCounter] = b2
        memCounter += 1
    elif header == 'div':
        m = '11110'
        if splt[1] == 'ax':
            m += '000'
        elif splt[1] == 'bx':
            m += '001'
        elif splt[1] == 'cx':
            m += '010'
        elif splt[1] == 'dx':
            m += '011'
        else:
            m += '100'
        mem[memCounter] = m
        memCounter += 1
        if m[5] == '1':
            mem[memCounter] = splt[1][8:]
            memCounter += 1
            mem[memCounter] = splt[1][:8]
            memCounter += 1
    else:
        print "Error counter: " + str(counter) + ", memCounter: " + str(memCounter)
    counter += 1

mem[12] = '00110101'
mem[13] = '00000010'
mem[14] = '00111001'
mem[15] = '00000010'

f = open("memInit.txt", 'w')
for elem in range(0, len(mem)):
    f.write('rom('+str(elem)+') <= "'+mem[elem]+'";\n')
f.close()

