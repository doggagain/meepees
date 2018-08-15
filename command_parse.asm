.data
TheCode: .word 0x014B4820, 0x012A4822, 0x8f0e0000, 0x1032005a, 0x1021005a,0xae300000, 0xFFFFFFFF
registerCounter: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
r_type_count: .word 0
lw_count: .word 0
sw_count: .word 0
beq_count: .word 0
cantBeZero: .asciiz "\nrt is zero in lw command"
rTypeRdZero: .asciiz "\nrd is zero in r_type command"
rtRsBeqEqual: .asciiz "\nrt and rs are equal in beq command"
opCodeNotRecognized: .asciiz "\nop code is not recognized"
forRegister: .asciiz "\nfor register: "
printRtype: .asciiz "\nr_type: "
printlw: .asciiz "\nlw : "
printsw: .asciiz "\nsw: "
printbeq: .asciiz "\nbeq: "
colon: .asciiz " : "
.text

#algorithm works as follows:
#we take te array of commands to parse and parse 
#them in a loop with
#masking according to each size of the regions,
#and saving each part in a specific register
#list of registers is below.
#
#we then attend to increasing the relevant counters
# according to the contents of each command part,
#i.e. rt,rs,
#
#we check whether or not it is i ot r type,
#
#if it is, we treat r_type specific conditions
#
#if it is i_type, we differentiate whether it is sw,beq,lw
#and treat each time if the special case happened or not for each one
#
#if command doesnt fit any opcode we alert the user
#
#after command handling we loop again unless we see ffffffff or passed 100
#
#after that, we print summary of all commands count
#
#registers:
#t0 is funct 6 bits
#t1 is shamt 5 bits
#t2 is rd 5 bits
#t3 is rt 5 bits 
#t4 is rs 5 bits 
#t5 is op 6 bits
#$t6 to hold the current command
#$t7 to get current mask 
#$t8 to load from memory for print 
#$t9 to hold offest in array to read
#
#$s0 to hold content of variable from memory
#$s1 for loading variable from memory
#$s2 to be counter for command loop 
#
#$a0 
#$a1
# both for args for procedures



xor $s2,$s2,$s2 #init $s2 to be counter for command loop 

get_next:

beq $s2,100,done


#t0 is funct 6 bits
#t1 is shamt 5 bits
#t2 is rd 5 bits
#t3 is rt 5 bits 
#t4 is rs 5 bits 
#t5 is op 6 bits

la $t8,TheCode # load current command
sll $t9,$s2,2 
add $t8,$t8,$t9
lw $t6,0($t8)

beq $t6,0xFFFFFFFF,done

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

add $a0,$zero,$t3
add $a1,$zero,$t4

jal increase_rt_rs #call increase_rt_rs procedure  

beq $t5,0,do_r_type

j do_i_type


do_r_type: #####r_type

add $a0,$zero,$t2

jal count_rd_r_type

la $s1,r_type_count# count for r_type
lw $s0,0($s1)

addi $s0,$s0,1
sw $s0,0($s1)

beq $t2,0,print_r_type_rd_be_0 #check for r_type rd 0
j r_type_not_rd_be_0

print_r_type_rd_be_0:
li $v0,4
la $a0,rTypeRdZero
syscall
 
r_type_not_rd_be_0:

j after_i_r_sorting

do_i_type:

beq $t5,4,is_beq

beq $t5,43,is_sw

beq $t5,35,is_lw

li $v0,4 # print opCodeNotRecognized
la $a0,opCodeNotRecognized
syscall

j after_i_r_sorting

is_beq: #beq
la $s1,beq_count
lw $s0,0($s1)

addi $s0,$s0,1
sw $s0,0($s1)

beq $t3,$t4,print_rt_rs_beq_equal #check for rs rt equal beq
j rt_rs_beq_not_equal

print_rt_rs_beq_equal:
li $v0,4
la $a0,rtRsBeqEqual
syscall
 
rt_rs_beq_not_equal:

j after_i_r_sorting

is_sw:#####sw
la $s1,sw_count
lw $s0,0($s1)

addi $s0,$s0,1
sw $s0,0($s1)
j after_i_r_sorting


is_lw:#####lw
la $s1,lw_count
lw $s0,0($s1)

addi $s0,$s0,1
sw $s0,0($s1)

beq $t3,0,print_lw_cant_rt_be_0 #check for lw rt 0
j lw_not_rt_be_0

print_lw_cant_rt_be_0:
li $v0,4
la $a0,cantBeZero
syscall
 
lw_not_rt_be_0:
j after_i_r_sorting

after_i_r_sorting:

addi $s2,$s2,1
j get_next

done:
xor $s2,$s2,$s2 #init $s2 to be counter for command loop 

print_next_register:

la $t8,registerCounter # for current register
sll $t9,$s2,2 
add $t8,$t8,$t9
lw $s0,0($t8)

beq $s0,0,shouldnt_print_0

li $v0,4
la $a0,forRegister
syscall
 
li $v0,1
move $a0,$s2
syscall

li $v0,4
la $a0,colon
syscall

li $v0,1
move $a0,$s0
syscall

shouldnt_print_0:
addi $s2,$s2,1
beq $s2,32,end
j print_next_register

end:
la $s1,r_type_count# print for r_type
lw $s0,0($s1)

li $v0,4
la $a0,printRtype
syscall

li $v0,1
move $a0,$s0
syscall

la $s1,lw_count #print for lw 
lw $s0,0($s1)

li $v0,4
la $a0,printlw
syscall

li $v0,1
move $a0,$s0
syscall

la $s1,sw_count #print for sw 
lw $s0,0($s1)

li $v0,4
la $a0,printsw
syscall

li $v0,1
move $a0,$s0
syscall

la $s1,beq_count #print for beq
lw $s0,0($s1)

li $v0,4
la $a0,printbeq
syscall

li $v0,1
move $a0,$s0
syscall

li $v0,10
syscall

increase_rt_rs:

add $t3,$zero,$a0
add $t4,$zero,$a1

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

jr $ra

count_rd_r_type:

add $t2,$zero,$a0

la $t8,registerCounter #count for rd
sll $t9,$t2,2 
add $t8,$t8,$t9
lw $s0,0($t8)

addi $s0,$s0,1
sw $s0,0($t8)

jr $ra

