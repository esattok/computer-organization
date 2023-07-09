## Author: Esad İsmail Tök
## Preliminary Work part2.asm calculates the mathematical expression (x = a * (b - c) % d)
##
## s0, s1, s2, s3, s4 - a, b, c, d, x
## t0 - temporary calculation results
##


# Text Segment
	.text
	.globl __start

__start:

# Asking for a variable
	li $v0, 4
	la $a0, promptA
	syscall
	
# Getting the variable
	li $v0, 5
	syscall
	
# Saving it into register
	move $s0, $v0
	
# And taking the other 3 variables similarly
	li $v0, 4
	la $a0, promptB
	syscall
	
	li $v0, 5
	syscall
	
	move $s1, $v0
	
	li $v0, 4
	la $a0, promptC
	syscall
	
	li $v0, 5
	syscall
	
	move $s2, $v0
	
	li $v0, 4
	la $a0, promptD
	syscall
	
	li $v0, 5
	syscall
	
	move $s3, $v0
	
# Computations
	sub $t0, $s1, $s2	# $t0 = (b - c)
	mult $t0, $s0		# a * (b - c)  
	mflo $t0			# Replace $t0 with the mulplied number
	div $t0, $s3		# a * (b - c) / d
	mfhi $t0			# $t0 = a * (b - c) % d
	
	move $s4, $t0
	
# Displaying the result
	li $v0, 4
	la $a0, result
	syscall
	
	li $v0, 1	# printing integer result
	move $a0, $s4
	syscall
	
	li $v0, 4
	la, $a0, endLine
	syscall
	
	li $v0, 10	# Exit
	syscall
	

# Data Degment
	.data
promptA: .asciiz "Enter the variable a: "
promptB: .asciiz "Enter the variable b: "
promptC: .asciiz "Enter the variable c: "
promptD: .asciiz "Enter the variable d: "
result: .asciiz "\nThe result of the mathematical expression (x = a * (b - c) % d) is "

endLine: .asciiz "\n"
