addi x1, x0, 5       # x1 = 5
addi x2, x0, 3       # x2 = 3

# MEM-to-EX forwarding
add  x3, x1, x2      # x3 = 8
sub  x4, x3, x1      # x4 = 3

# WB-to-EX forwarding
and  x5, x1, x2      # x5 = 1
or   x6, x3, x4      # x6 = 11

# slt
slt  x7, x2, x1      # x7 = 1 (3 < 5)

# negative number slt
addi x16, x0, -1     # x16 = -1
slt  x17, x16, x0    # x17 = 1 (-1 < 0)

# sub resulting in negative
sub  x18, x2, x1     # x18 = -2 (3-5)

# store then load, lw stall via Rs1D
sw   x3, 0(x0)       # mem[0] = 8
lw   x8, 0(x0)       # x8 = 8
add  x9, x8, x1      # x9 = 13

# lw stall via Rs2D
sw   x1, 4(x0)       # mem[1] = 5
lw   x10, 4(x0)      # x10 = 5
add  x11, x2, x10    # x11 = 8

# back to back lw stalls
lw   x19, 0(x0)      # x19 = 8
lw   x20, 4(x0)      # x20 = 5
add  x21, x19, x20   # x21 = 13

# beq not taken
beq  x1, x2, 8       # not taken
addi x12, x0, 1      # x12 = 1 must execute

# beq with forwarded operands
addi x22, x0, 5      # x22 = 5
add  x23, x22, x0    # x23 = 5, x22 just written → forward
beq  x23, x1, 8      # taken (5==5), operands forwarded
addi x24, x0, 99     # must be skipped x24=0
addi x25, x0, 7      # x25 = 7

# beq taken
addi x13, x0, 5      # x13 = 5
beq  x1, x13, 8      # taken
addi x14, x0, 99     # must be skipped x14=0
addi x15, x0, 2      # x15 = 2
