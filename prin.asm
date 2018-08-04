.data
placeholder: .word 0
num1: .word -1, num3
num2: .word 17, 0
num3: .word 32, num5
num4: .word -6, num2
num5: .word 1972, num4
sum: .word 0
sum_in_four: .word 0
msg1: .asciiz "The first number: "
result: .asciiz "\nThe sum is:  "
resultFour: .asciiz "\nThe sum of divisble by four is:  "
newLine: .asciiz "\nThe number in unsigned base 4: "
newLineSign: .asciiz "\nThe number in signed base 4: "
minus: .asciiz "-"
initGetBase4: .word 3
.text

#part a

xor $s4,$s4,$s4
la $t2, sum
lw $t4,0($t2)

la $t2, num1

get_next:

lw $t3,0($t2)

add $t4,$t4,$t3

andi $s1,$t3,3
bne $s1,0,not_by_four

add $s4,$s4,$t3

not_by_four:

move $s6, $t3  
la $t7, initGetBase4
lw $t7,0($t7)

#print new line
li $v0,4
la $a0,newLine
syscall
#end print new line

get_4_base_next:
and $s5,$t3,$t7

#print digit base 4
li $v0,1
move $a0,$s5
syscall
#end print

srl $t3,$t3,2
bne $t3,0,get_4_base_next

#print new line for part c 
li $v0,4
la $a0,newLineSign
syscall
#end print new line for part c 	

slt $s7, $s6, $zero      #is value < 0 ?
beq $s7, $zero, positive  #if r1 is positive, skip next inst
sub $s6, $zero, $s6      #r2 = 0 - r1
#print new line for part c 
li $v0,4
la $a0,minus
syscall
#end print new line for part c 	

positive:


get_4_base_next_sign:
and $s5,$s6,$t7

#print digit base 4
li $v0,1
move $a0,$s5
syscall
#end print

srl $s6,$s6,2
bne $s6,0,get_4_base_next_sign

lw $t5,4($t2)
beq $t5,0,end

move $t2, $t5

j get_next

end:
#print
li $v0,4
la $a0,result
syscall
 
li $v0,1
move $a0,$t4
syscall
#end print
#print
li $v0,4
la $a0,resultFour
syscall
 
li $v0,1
move $a0,$s4
syscall
#end print
li $v0,10
syscall
