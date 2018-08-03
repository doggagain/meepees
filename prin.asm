.data
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
initGetBase4: .word 3
.text

#part a

xor $s4,$s4,$s4
la $t2, sum
lw $t4,0($t2)

la $t2, num1
lw $t3,0($t2)

add $t4,$t4,$t3

andi $s1,$t3,3
bne $s1,0,get_next

add $s4,$s4,$t3

get_next:
lw $t5,4($t2)
beq $t5,0,end

move $t2, $t5
lw $t3,0($t2)

add $t4,$t4,$t3

andi $s1,$t3,3
bne $s1,0,not_by_four

add $s4,$s4,$t3

not_by_four:


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
