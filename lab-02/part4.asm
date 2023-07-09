## Author: Esad İsmail Tök
## Lab Work part4.asm count a bit pattern in register using subprogram
##
## a0 - the bit pattern to be counted
## a1 - the register to be searched for counting
## a2 - holds the bit pattern length
## s0, s1, s2, s3, s4, s5, s6 - saved registeres used in the subprograms
## v0 - returns the pattern count
## 

# Text Segment
	.text
	.globl __main
	
__main:
	li $a0, 0x00000007 # The pattern
	li $a1, 0xE700E1C7 # The value to be searched
	li $a2, 3		   # The length of the pattern (bitwise)
	
	move $s0, $a0	   # a copy of the pattern
	move $s1, $a1	   # a copy of the value
	
	jal patternCounter
	move $s2, $v0 # Saving the result
	
# Displaying results
	li $v0, 4
	la $a0, value
	syscall
	
	li $v0, 34
	move $a0, $s1
	syscall
	
	li $v0, 4
	la $a0, endLine
	syscall
#--------------------
	
	li $v0, 4
	la $a0, pattern
	syscall
	
	li $v0, 34
	move $a0, $s0
	syscall
	
	li $v0, 4
	la $a0, endLine
	syscall
#--------------------
	
	li $v0, 4
	la $a0, result
	syscall
	
	li $v0, 1
	move $a0, $s2
	syscall
	
	li $v0, 4
	la $a0, endLine
	syscall
#--------------------
	
# End the program
	li $v0, 10
	syscall
	
	
	
# Counts the pattern
#-----------------------------------------------
patternCounter:
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	
# The value to be used in masking 
	addi $s0, $0, 1 # Iterator
	addi $s2, $0, 1 # Used in masking initially 1
	
subLoop:
	bge $s0, $a2, endSubLoop
	
	sll $s2, $s2, 1
	addi $s2, $s2, 1
	addi $s0, $s0, 1
	j subLoop
endSubLoop:
	
	
	
	addi $s0, $0, 0 # Reinitialize iterator
	addi $v0, $0, 0 # Counter initially 0
	
loop:
	add $s1, $s0, $a2 # Guarantee the step
	bgt $s1, 32, end
	
	and $s3, $a1, $s2 # Masking
	
	bne $s3, $a0, skip
	addi $v0, $v0, 1
skip:
	
	srlv  $a1, $a1, $a2 # Shift the value
	add $s0, $s0, $a2 # Increment iterator by the pattern length
	j loop
end:
	
# Reloading registers
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
	
	jr $ra # Going back to main
#-----------------------------------------------
	
	
	
# Data Segment
	.data
value:		.asciiz "The value that is searched (hex): "
pattern:	.asciiz "The bit pattern (hex): "
result:		.asciiz "Count: "
endLine: 	.asciiz "\n"
	
