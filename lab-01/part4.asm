## Author: Esad İsmail Tök
## Lab Work part4.asm prompts user to enter integers and make a calculation
##
## s0 - holds the B
## s1 - holds the C
## s2 - holds the D
## s3 - holds the result (A)
## t0 - temporary register used in the program
##

# Text Segment
	.text
	.globl __start
	
__start:

# Taking the values
	li $v0, 4
	la $a0, prompt1
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0
	
	li $v0, 4
	la $a0, prompt2
	syscall
	
	li $v0, 5
	syscall
	move $s1, $v0
	
	li $v0, 4
	la $a0, prompt3
	syscall
	
	li $v0, 5
	syscall
	move $s2, $v0
	
	li $v0, 4
	la $a0, endLine
	syscall
	
# First step
	div $s0, $s1	# (B % C)
	mfhi $s3
	
	li $v0, 4
	la $a0, step1
	syscall
	li $v0, 1
	move $a0, $s3
	syscall
	
# Second Step
	add $s3, $s3, $s2	# (B % C + D)
	
	li $v0, 4
	la $a0, step2
	syscall
	li $v0, 1
	move $a0, $s3
	syscall
	
# Third Step
	sub $t0, $s1, $s2	# (C - D)
	
	li $v0, 4
	la $a0, step3
	syscall
	li $v0, 1
	move $a0, $t0
	syscall
	
# Fourth Step
	div $s3, $s0	# (B % C + D) / B
	mflo $s3
	
	li $v0, 4
	la $a0, step4
	syscall
	li $v0, 1
	move $a0, $s3
	syscall

# Fifth Step
	mult $s3, $t0
	mflo $s3	# (B % C + D) / B * (C - D)
	
	li $v0, 4
	la $a0, step5
	syscall
	li $v0, 1
	move $a0, $s3
	syscall
	
# Printing the result
	li $v0, 4
	la $a0, result
	syscall
	
	li $v0, 1
	move $a0, $s3
	syscall
	
	li $v0, 4
	la $a0, endLine
	syscall
	
# End the program
	li $v0, 10
	syscall
	
	
# Data Segment
	.data
prompt1:	.asciiz "Enter the first integer (B): "
prompt2:	.asciiz "Enter the second integer (C): "
prompt3:	.asciiz "Enter the third integer (D): "

step1:		.asciiz "\nStep 1: (B % C) = "
step2:		.asciiz "\nStep 2: (B % C + D) = "
step3:		.asciiz "\nStep 3: (C - D) = "
step4:		.asciiz "\nStep 4: (B % C + D) / B = "
step5:		.asciiz "\nStep 5: # (B % C + D) / B * (C - D) = "

result:		.asciiz "\n\nThe result is "

endLine:	.asciiz "\n"


