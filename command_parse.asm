.data
instructions: .word 0x014B4820
registerCounter: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0


.text

format_r:

#t0 is funct 6 bits
#t1 is shamt 5 bits
#t2 is rd 5 bits
#t3 is rt 5 bits 
#t4 is rs 5 bits 
#t5 is op 6 bits

#s1 us for r_type count
#s2 is for lw
#s3  is for sw
#s4 is for beq

add $t6,$zero,0x014B4820

#parse command
and $t7,$t6,63 # get 6 bits
add $t0,$zero,$t7 
srl $t6,$t6,6

and $t7,$t6,31 # get 5 bits
add $t1,$zero,$t7 
srl $t6,$t6,5

and $t7,$t6,31 # get 5 bits
add $t2,$zero,$t7 
srl $t6,$t6,5

and $t7,$t6,31 # get 5 bits
add $t3,$zero,$t7 
srl $t6,$t6,5

and $t7,$t6,31 # get 5 bits
add $t4,$zero,$t7 
srl $t6,$t6,5

and $t7,$t6,63 # get 6 bits
add $t5,$zero,$t7 
srl $t6,$t6,6
#end parse command

#increase in registerCounter rs,rt

la $t8,registerCounter # for rt
sll $t9,$t3,2 
add $t8,$t8,$t9
lw $s0,0($t8)

addi $s0,$s0,1
sw $s0,0($t8)

la $t8,registerCounter # for rs
sll $t9,$t4,2 
add $t8,$t8,$t9
lw $s0,0($t8)

addi $s0,$s0,1
sw $s0,0($t8)

beq $t5,0,do_r_type

j do_i_type


do_r_type:
la $t8,registerCounter
sll $t9,$t2,2 
add $t8,$t8,$t9
lw $s0,0($t8)

addi $s0,$s0,1
sw $s0,0($t8)



do_i_type:

beq $t5,4,is_beq

beq $t5,43,is_sw

beq $t5,35,is_lw


