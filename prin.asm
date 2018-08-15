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
initGetBase4: .word 3221225472
.text

#algorithm works as follows:
#first we take the first address loaded from the variable num1
#then we load the content of the variable into $t3 
#if it is not divisble by 4, we dont add it to divided by 4 sum
#
#then we iterate 16 times over the number twice:
#
#in the first loop we print number regularly over $t3
#we do it by masking the 2 leftmost bytes into a number,
#and then printing it.
#after that we shift left twice and move to the next pair until 
#the number is complete
#
#in the second loop we print number $s6,
#checking if it is positive or negative. 
#if it is, we slip its sign and then printing it like the first
#loop
#
#once we have printed the number, we load the content of the
#memory pointed by the reference in the node of the list.
#if its not zero, we do the above logic again.
#
#if it is zero,
#we print the sum of all the numbers and
#the sum of those divisible by 4

#registers:
#$t2 for loading variables from memory
#$t3 the number to sum and print for first loop
#$t4 for sum
#$t6 counter for iterations
#$t9 flag to know whether to print 0 or not
#
#$s1 and result with 4 to check if divisible
#$s2 hold compare result with counter 
#$s4 sum of divisible by 4
#$s5 left most 2 bits for current 4 base number
#$s6 number to print for seconed signed loop
#$s7 check if number is negative
#
#$t5 hold next number in list
#$t7 hold the size to mask with
#$t8 hold 16 to compare with counter 



#part a

xor $s4,$s4,$s4
la $t2, sum
lw $t4,0($t2)

la $t2, num1

get_next:
xor $t9,$t9,$t9 #flag to know whether to print 0 or not
xor $t6,$t6,$t6 # counter for iterations

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
srl $s5,$s5,30

beq $s5,0,maybe_not_print_because_zero

or $t9,$t9,1

maybe_not_print_because_zero:
beq $t9,0,dont_print_zero

#print digit base 4
li $v0,1
move $a0,$s5
syscall
#end print

dont_print_zero:

sll $t3,$t3,2
addi $t6,$t6,1 

addi $t8,$zero,15
slt $s2,$t8,$t6   # checks if $t6 > 16
beq $s2,0,get_4_base_next


#print new line for part c 
li $v0,4
la $a0,newLineSign
syscall
#end print new line for part c 	

xor $t9,$t9,$t9 #again flag for zero print 
xor $t6,$t6,$t6# again for counter

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
srl $s5,$s5,30

beq $s5,0,maybe_not_print_because_zero_sign

or $t9,$t9,1


maybe_not_print_because_zero_sign:

beq $t9,0,dont_print_zero_sign

#print digit base 4
li $v0,1
move $a0,$s5
syscall
#end print

dont_print_zero_sign:

sll $s6,$s6,2
addi $t6,$t6,1 

addi $t8,$zero,15
slt $s2,$t8,$t6   # checks if $t6 > 16
beq $s2,0,get_4_base_next_sign

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
