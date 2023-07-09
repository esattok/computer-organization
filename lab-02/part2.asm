## Author: Esad İsmail Tök
## Preliminary Work part2.asm reverses the order of the entered decimal number's bits
##
## a0 - the entered decimal number
## s0, s1, s2, s3, s4, s5 - saved registeres used in the subprogram
## v0- return register
## 

# Text Segment
	.text
	.globl __main
	
__main:
# Taking the value form the user
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0 # Storing the taken value 
	
	li $v0, 4
	la $a0, endLine
	syscall
	
# Printing the entered integer in hexadecimal format
	li $v0, 4
	la $a0, result1
	syscall
	
	li $v0, 34
	move $a0, $s0
	syscall
	
	li $v0, 4
	la $a0, endLine
	syscall
	
# Printing the reversed number in hexadecimal format
	li $v0, 4
	la $a0, result2
	syscall
	
	move $a0, $s0
	jal ReverseBits
	move $s1, $v0
	
	li $v0, 34
	move $a0, $s1
	syscall
	
	li $v0, 4
	la $a0, endLine
	syscall
	
	
# End the program
	li $v0, 10
	syscall
	
	
	
	
# Reverses the order of bits of the integer in $a0
#=======================================================

ReverseBits:
# Allocating space in stace
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp) # temporary register that holds the lsb of the decimal number
	
	move $s0, $a0 # s0 holds the decimal value
	add $s1, $0, $0 # s1 hold the reversed number initially 0
	add $s2, $0, $0 # s2 is the iterator through the 32 bits
	addi $s3, $0, 31 # s3 keeps the number of iteration
	

# Since we shift at the end of each iteration the shift at the last iteration is useless 
# So we need only 31 iteration for 32 bit number
loop:
	slt $s4, $s2, $s3
	beq $s4, $0, end
	
	andi $s5, $s0, 1
	or $s1, $s1, $s5
	srl $s0, $s0, 1
	sll $s1, $s1, 1
	
	addi $s2, $s2, 1 # Increment the iterator
	j loop
end:
	
# At last we place the last bit without any shifting
	andi $s5, $s0, 1
	or $s1, $s1, $s5
	
	move $v0, $s1 # Putting the result into return register

# Deallocating the used space in the stack
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	addi $sp, $sp, 24
	
	jr $ra # returning to the caller
#=======================================================
	
	
	
	
# Data Segment
	.data
prompt:    .asciiz "Enter a decimal number: "
result1:   .asciiz "Your number is (hex): "
result2:   .asciiz "The reversed form of your number is (hex): "
endLine:   .asciiz "\n"
