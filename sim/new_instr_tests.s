# xor, xori
addi x1, x0, 12       # x1 = 12 (1100)
addi x2, x0, 10       # x2 = 10 (1010)
xor  x3, x1, x2       # x3 = 6  (0110)
xori x4, x1, 10       # x4 = 6

# shifts
addi x5, x0, 8        # x5 = 8  (1000)
sll  x6, x5, x2       # x6 = 8 << 10 ... use small shift
addi x7, x0, 2        # x7 = 2  (shift amount)
sll  x8, x5, x7       # x8 = 32
srl  x9, x5, x7       # x9 = 2
sra  x10, x5, x7      # x10 = 2 (positive)
addi x11, x0, -8      # x11 = -8
sra  x12, x11, x7     # x12 = -2 (sign preserved)
slli x13, x5, 2       # x13 = 32
srli x14, x5, 2       # x14 = 2
srai x15, x11, 2      # x15 = -2

# sltu, sltiu
addi x16, x0, -1      # x16 = 0xFFFFFFFF (large unsigned)
sltu x17, x1, x16     # x17 = 1 (12 < 0xFFFFFFFF unsigned)
slt  x18, x1, x16     # x18 = 0 (12 > -1 signed)
sltiu x19, x1, 20     # x19 = 1 (12 < 20 unsigned)

# lui, auipc
lui  x20, 1           # x20 = 0x00001000
auipc x21, 1          # x21 = PC + 0x00001000

# bltu, bgeu
bltu x1, x16, 8       # taken (12 <u 0xFFFFFFFF)
addi x22, x0, 99      # skipped
addi x22, x0, 5       # x22 = 5
bgeu x16, x1, 8       # taken (0xFFFFFFFF >=u 12)
addi x23, x0, 99      # skipped
addi x23, x0, 7       # x23 = 7

# sb, lb, lbu
addi x24, x0, 0xAB    # x24 = 0xAB (171)
sb   x24, 8(x0)       # mem byte at 8 = 0xAB
lb   x25, 8(x0)       # x25 = sign extended 0xAB = -85
lbu  x26, 8(x0)       # x26 = 171 (zero extended)

# sh, lh, lhu
addi x27, x0, 0x7F    # x27 = 127
sh   x27, 12(x0)      # mem halfword at 12 = 0x007F
lh   x28, 12(x0)      # x28 = 127 (positive, no sign ext difference)
lhu  x29, 12(x0)      # x29 = 127

#jalr check
addi x30, x0, 0      # clear x30
auipc x30, 0         # x30 = current PC (next instr addr - 4) = 36*4 = 144
addi x30, x30,24    # x30 = PC of jalr target = 144+24 = 168 
jalr x0, x30, 0      # jump to target (rn at 152)
addi x31, x0, 99     # skipped
addi x31, x0, 99     # skipped  
addi x31, x0, 99     # skipped
addi x31, x0, 55     # jalr target, x31=55
