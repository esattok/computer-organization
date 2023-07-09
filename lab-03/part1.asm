## Author: Esad İsmail Tök
## Preliminary Work part1.asm find the count of add and lw instructions 
## Note: Self-modifying code option is selected in the setting bar of mars simulator in order to be able to access the text segment of the memory
##
## a0 - the start address of the instructions in functions
## a1 - the end address of the instructions in functions
## s0, s1, s2, s3, s4, s5, s6, s7 - saved registeres used in the subprograms
## v0 - returns the add count
## v1 - returns the lw count
## 

# Text Segment
	.text
	.globl __main
	
__main:    # First instruction to be checked. And the label is its address
	la $a0, __main
	la $a1, endMain
	add $v0, $0, $0
	add $v1, $0, $0
	
	jal count
	
	move $s0, $v0	# s0 holds the count of add instruction
	move $s1, $v1	# s1 holds the count of lw instruction
	
	addi $v0, $0, 4
	la $a0, resultMainAdd
	syscall
	
	addi $v0, $0, 1
	add $a0, $0, $s0
	syscall
	
	li $v0, 4
	la $a0, endLine
	syscall
	
	
	lw $s5, endLine    # Reduntent lw instruction to test the counting of the lw instructions
	
	
	addi $v0, $0, 4
	la $a0, resultMainLw
	syscall
	
	addi $v0, $0, 1
	add $a0, $0, $s1
	syscall
	
	li $v0, 4
	la $a0, endLine
	syscall
	li $v0, 4
	la $a0, endLine
	syscall
	
	
	lw $s5, endLine    # Redundent lw instruction to test the counting of the lw instructions
	
	
# Testing using the function itself
#-----------------------------------
	la $a0, count
	la $a1, endCount
	add $v0, $0, $0
	add $v1, $0, $0
	
	jal count

	move $s0, $v0	# s0 holds the count of add instruction
	move $s1, $v1	# s1 holds the count of lw instruction
	
	addi $v0, $0, 4
	la $a0, resultFunctAdd
	syscall
	
	addi $v0, $0, 1
	add $a0, $0, $s0
	syscall
	
	li $v0, 4
	la $a0, endLine
	syscall
	
	lw $s5, endLine    # Redundent lw instruction to test the counting of the lw instructions
	
	addi $v0, $0, 4
	la $a0, resultFunctLw
	syscall
	
	addi $v0, $0, 1
	add $a0, $0, $s1
	syscall
	
	li $v0, 4
	la $a0, endLine
	syscall
	
	
	lw $s5, endLine    # Redundent lw instruction to test the counting of the lw instructions
	
	
# End the program
	li $v0, 10
	syscall
	
		
			
endMain:	# Last instruction to be checked. And the label is its address
		


#------------------------------------------------------------------------------------------
count:	# First instruction to be checked. And the label is its address
	addi $sp, $sp, -32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	
	
	li $s0, 0x8C000000 # 32 bit number including the opcode for lw in its first 6 bits
	li $s1, 0x00000020 # Same for the add instruction
	
	li $s2, 0xfc000000 # Will be used to mask the lw instructions
	li $s3, 0xfc00003f # Will be used to mask the add instructions
	
	add $v0, $v0, $0 # add instruction count
	add $v1, $v1, $0 # lw instruction count
	addi $s6, $0, 4 
	addi $s7, $0, 1
	
loop: 
	bgt $a0, $a1, endLoop
	
	lw $s4, 0($a0)	# s4 holds the machine instruction to be examined
	
# Examining for the add instruction
	and $s4, $s4, $s3
	bne $s4, $s1, else1
	add $v0, $v0, $s7 # Increment add count
else1:

	lw $s4, 0($a0)	# s4 holds the machine instruction to be examined
	
# Examining for the lw instruction
	and $s4, $s4, $s2
	bne $s4, $s0, else2
	add $v1, $v1, $s7 # Increment lw count
else2:
	
	add $a0, $a0, $s6
	j loop
endLoop:
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	addi $sp, $sp, 32
	
	jr $ra
	
endCount:	# Last instruction to be checked. And the label is its address
#------------------------------------------------------------------------------------------




# Data Segment
	.data
resultMainAdd:	.asciiz "Total number of \"add\" instructions in main function is: "
resultMainLw:	.asciiz "Total number of \"lw\" instructions in main function is: "

resultFunctAdd:	.asciiz "Total number of \"add\" instructions in the count function is: "
resultFunctLw:	.asciiz "Total number of \"lw\" instructions in the count function is: "

endLine: 		.asciiz "\n"
