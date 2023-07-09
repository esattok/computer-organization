## Author: Esad İsmail Tök
## Preliminary Work part2.asm does a division using recursive subtraction in a function
##
## a0 - the divident
## a1 - the divisor
## s0, s1, s2 - saved registeres used in the subprograms
## v0 - returns quotient
## 

# Text Segment
	.text
	.globl __main
	
__main:

loop:
	li $v0, 4
	la $a0, takeNum1
	syscall
	
	li $v0, 5
	syscall
	move $s6, $v0 # s6 holds the divident
	
	li $v0, 4
	la $a0, takeNum2
	syscall
	
	li $v0, 5
	syscall
	move $s7, $v0 # s7 holds the divisor
	
	move $a0, $s6
	move $a1, $s7
	
	bne $s7, $0, skip	# If the divisor is 0 ask another number
	li $v0, 4
	la $a0, div0
	syscall
	
	j loop
	
skip:
	
	jal recursiveDivision
	
# Printing the result
	move $s0, $v0	# s0 holds the result
	
	li $v0, 4
	la $a0, result
	syscall
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	li $v0, 4
	la $a0, endLine
	syscall
	
# Asking for another turn

	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 5
	syscall
	move $s2, $v0	# s2 hold the user result
	
	li $v0, 4
	la $a0, endLine
	syscall
	
	beq $s2, 1, loop
	
# Out of the loop
	li $v0, 4
	la $a0, bye
	syscall
	
	
# End the program
	li $v0, 10
	syscall
	
	
	
	
recursiveDivision:
	addi $sp, $sp, -20
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $ra, 16($sp)
	
# Base condition
	bge $a0, $a1, else
	
	addi $v0, $0, 0
	addi $sp, $sp, 20
	jr $ra
	
else:
	sub $a0, $a0, $a1
	
	jal recursiveDivision
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	
	addi $v0, $v0, 1
	jr $ra
	
	
	
# Data Segment
	.data
takeNum1:	.asciiz "Enter the divident value: "
takeNum2:	.asciiz "Enter the divisor value: "

result:		.asciiz "\nThe result of the division is: "
div0:		.asciiz "\nCannot divide by 0 !\n\n"

bye:		.asciiz "Good Bye\n"

prompt:		.asciiz "\nDo you want to continue? (\"1\" for yes, \"0\" for no): "

endLine:	.asciiz "\n"

