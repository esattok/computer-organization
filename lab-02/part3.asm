## Author: Esad İsmail Tök
## Lab Work part3.asm generates a dynamic array using the size
## and does simple operations using subprograms.
##
## a0 - the base address of the array
## a1 - the size of the array
## s0, s1, s2, s3, s4, s5, s6 - saved registeres used in the subprograms
## v0, v1 - return registers
## 

# Text Segment
	.text
	.globl __main
	
__main:
# Generating the array using subprogram
	jal getArray
	
	move $s6, $v0 # $s6 holds the array beggining address for the rest of the program
	move $s7, $v1 # $s7 holds the array size for the rest of the program
	
	
	move $a0, $s6
	move $a1, $s7
	
	bne $a1, $0, full
	
# If the array is empty
	li $v0, 4
	la $a0, emptyMessage
	syscall
	j empty
	
full: # If the array is not empty
	
# Checking the symmetricity
	move $a0, $s6
	move $a1, $s7
	
	jal CheckSymmetric
	
# Displaying the result
	addi $sp, $sp, -4
	sw $v0, 0($sp)
	
	li $v0, 4
	la $a0, symmetricMessage
	syscall
	
	lw $v0, 0($sp)
	addi $sp, $sp, 4
	
	beq $v0, $0, isNotSym	# if the array is not symmetric
	
	# if it is symmetric
	li $v0, 4
	la $a0, result1
	syscall
	j finish
	
isNotSym:
	li $v0, 4
	la $a0, result2
	syscall
finish:

# Finding min and max
	move $a0, $s6
	move $a1, $s7
	
	jal FindMinMax
	
	move $s0, $v0 # Holds the min
	move $s1, $v1 # Holds the max
	
	li $v0, 4
	la $a0, endLine
	syscall
	li $v0, 4
	la $a0, minMaxMessage
	syscall
	
# Printing Min
	li $v0, 4
	la $a0, min
	syscall
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	li $v0, 4
	la $a0, endLine
	syscall
	
# Printing Max
	li $v0, 4
	la $a0, max
	syscall
	
	li $v0, 1
	move $a0, $s1
	syscall
	
	li $v0, 4
	la $a0, endLine
	syscall
	
	
empty:
# End of the program
	li $v0, 10
	syscall
	
	
# Generates a dynamic array usinng user inputs
#==============================================================
getArray:
# Saving the registers
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $ra, 16($sp)
	
# Getting the array size
	li $v0, 4
	la $a0, promptSize
	syscall

	li $v0, 5
	syscall
	
	move $s0, $v0 # s0 holds the array size
	mul $s1, $s0, 4 # each array element is 4 bytes
	
# Allocating the space dynamically
	li $v0, 9
	move $a0, $s1
	syscall
	
	move $s1, $v0 # s1 now points to the first array space
	move $s3, $v0 # a copy of the address
	addi $s2, $0, 0 # Iterator
	
# Populating the array dynamically
populateArrayLoop:
	bge $s2, $s0, endPopulate
	
	li $v0, 4
	la $a0, promptItem
	syscall
	
	li $v0, 5
	syscall
	
	sw $v0, 0($s1) # Store the item
	
	addi $s1, $s1, 4
	addi $s2, $s2, 1
	
	j populateArrayLoop
endPopulate:

	li $v0, 4
	la $a0, endLine
	syscall
	
	
	beq $s0, $0, skipCall
# Calling the print function with arguments if array is not empty
	move $a0, $s3
	move $a1, $s0
	jal PrintArray
	
skipCall:
	
# Putting return values before reload
	move $v0, $s3
	move $v1, $s0
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	jr $ra
#==============================================================
	
	
# Prints the content of the array
#==============================================================
PrintArray:
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	
	move $s0, $a0 # s0 holds the first address of array
	move $s1, $a1 # s1 holds the size of the array
	addi $s2, $0, 0 # s2 is the iterator
	
	
	li $v0, 4
	la $a0, printMessage
	syscall
	
printLoop:
	slt $s3, $s2, $s1
	beq $s3, $0, donePrint
	
	li $v0, 1
	lw $a0, 0($s0)
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	addi $s2, $s2, 1
	addi $s0, $s0, 4
	j printLoop
donePrint:

	li $v0, 4
	la $a0, endLine
	syscall
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
	jr $ra
#==============================================================

# Checks whether the array is symmetric or not
#==============================================================
CheckSymmetric:
	addi $sp, $sp, -28
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)

	move $s0, $a0
	move $s1, $a1
	addi $v0, $0, 1
	
	addi $s2, $s1, -1 
	addi $s3, $0, 4
	mult $s3, $s2
	mflo $s2
	add $s2, $s0,$s2 # s2 keeps the address of the last array element
	addi $s3, $0, 4	# s3 keeps the value of 4 
	
	li $v0, 4
	la $a0, endLine
	syscall
	
# Deciding whether the array is symmetric or not
symmetricLoop:
	slt $s4, $s0, $s2 # Compares the address of the 2 array items that will be compared
	beq $s4, $0 doneSymmetric
	
# Get the values and adjust the pointers
	lw $s5 0($s0)
	lw $s6 0($s2)
	add $s0, $s0, $s3
	sub $s2, $s2, $s3
	
	beq $s5, $s6, pass	# if the values are equal skip the boolean changing, else change the boolean to false
	add $v0, $0, $0
pass:
	j symmetricLoop
doneSymmetric:

	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	addi $sp, $sp, 28
	jr $ra
#==============================================================

# Finds the minimum and maximum array elements
#==============================================================
FindMinMax:
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	
	move $s0, $a0
	move $s1, $a1
	add $s2, $0, $0 # s2 is the iterator
	lw $v0, 0($s0) # Minimum
	lw $v1, 0($s0) # Maximum
	
minMaxLoop:
	slt $s3, $s2, $s1
	beq $s3, $0, doneMinMax
	
	lw $s4, 0($s0) # s4 is the current element
	
	blt $s4, $v1, else1
	move $v1, $s4
else1:
	
	bgt $s4, $v0, else2
	move $v0, $s4
else2:

	addi $s2, $s2, 1
	addi $s0, $s0, 4
	j minMaxLoop
doneMinMax:
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	addi $sp, $sp, 20
	jr $ra
#==============================================================
	
	
# Data Segment
	.data
	
promptSize:			.asciiz "Enter the size of the array: "
promptItem:			.asciiz "Enter an array item: "

printMessage: 		.asciiz "---The Content Of The Array---\n"

symmetricMessage:	.asciiz "---Checking Whether The Array Is Symmetric Or Not---\n"

result1:  			.asciiz "The array is symmetric\n"
result2:  			.asciiz "The array is not symmetric\n"

minMaxMessage:		.asciiz "---Finding The Minimum And Maximum Element Of The Array---\n"
min:				.asciiz "Min: "
max:				.asciiz "Max: "

emptyMessage: 		.asciiz "--WARNING--\n- The array is empty\n- Cannot be talked about the symmetricity of the array since it has no elements\n- There is no min and max element since it has no elements\n"

space:				.asciiz " "
endLine:			.asciiz "\n"




