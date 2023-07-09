## Author: Esad İsmail Tök
## Preliminary Work part1.asm defines an array with its size
## and checkes whether the array is symmetric or not.
##
## s0 - the base address of the array
## s1 - the size of the array
## s2 - keeps whether the array is symmetric or not (boolean)
## t0, t1, t2, t3, t4 - temporary variables holding the addresses and the values of the array items
##


# Text Segment
	.text
	.globl __start

__start:
	la $s0, array	# Loads the base address of the array
	lw $s1, size	# Keeps the array size
	addi $t0, $0, 0	# The iterator initially zero
	addi $s2, $0, 1 # The boolean that is initially true
	
	li $v0, 4
	la $a0, message
	syscall
	
loop: 
	slt $t1, $t0, $s1	# t2 is 1 if iterator < size
	beq $t1, $0, end	# exit loop if it is done
	
	lw $t2, 0($s0) # load the array item
	addi $s0, $s0, 4 # increment to the next array item
	
# print the item
	li $v0, 1
	move $a0, $t2
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	addi $t0, $t0, 1	# increment iterator
	
	j loop
	
end:

	la $s0, array	# Reinitialize the s0 with the base address of the array
	addi $t0, $0, 1
	sub $t0, $s1, $t0 
	addi $t3, $0, 4
	mult $t3, $t0
	mflo $t0
	add $t3, $s0,$t0 # t3 keeps the address of the last array element
	addi $t0, $0, 4	# t0 keeps the value of 4 
	
	li $v0, 4
	la $a0, endLine
	syscall
	
	
	
# Deciding whether the array is symmetric or not
loop2:
	slt $t1, $s0, $t3 # Compares the address of the 2 array items that will be compared
	beq $t1, $0 done
	
# Get the values and adjust the pointers
	lw $t2 0($s0)
	lw $t4 0($t3)
	add $s0, $s0, $t0
	sub $t3, $t3, $t0
	
	beq $t2, $t4, pass	# if the values are equal skip the boolean changing, else change the boolean to false
	add $s2, $0, $0
pass:
	
	j loop2
done:



	li $v0, 4
	la $a0, message2
	syscall
	
# Displaying the result
	beq $s2, $0, isNotSym	# if the array is not symmetric
	
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

	li $v0, 10	# End the program
	syscall

# Data Segment
	.data
array:    .word 1, 5, 4
size:     .word 3

message:  .asciiz "---Displaying The Array---\n"
message2: .asciiz "\n---Result---\n"
result1:  .asciiz "The above array is symmetric\n"
result2:  .asciiz "The above array is not symmetric\n"
space:	  .asciiz " "
endLine:  .asciiz "\n"
