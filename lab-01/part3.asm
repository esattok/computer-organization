## Author: Esad İsmail Tök
## Lab Work part3.asm finds the minimum maximum and average values in the defined array
##
## s0 - holds the size of the array
## s1 - holds the sum of the elements
## s2 - hold the max element
## s3 - holds the min element
## s4 - hold the average of the list
## t0, t1, t2, t3 - temporary registers used in the code
##

# Text Segment
	.text
	.globl __start
	
__start:
	lw $s0, size    	# s0 holds the size
	la $t0, array		# t0 holds the first element's address in array
	add, $t1, $0, $0    # t1 is the iterator
	add, $s1, $0, $0    # s1 holds the sum
	lw $s2, 0($t0)		# s2 is the max
	lw $s3, 0($t0)		# s3 is the min

# Find the total sum, max, and min in loop1
loop1:
	slt $t2, $t1, $s0
	beq $t2, $0, done
	
	lw $t3, 0($t0)	#t3 holds the current element
	add $s1, $s1, $t3
	
	blt $t3, $s2, else1
	move $s2, $t3
else1:

	bgt $t3, $s3, else2
	move $s3, $t3
else2:

	addi $t1, $t1, 1	# Increment iterator
	addi $t0, $t0, 4	# Increment base address
	j loop1
done:

	div $s1, $s0	# Calculate the average
	mflo $s4		# s4 hold the average 
	
# Printing the array
	li $v0, 4
	la $a0, message
	syscall
	
	la $t0, array		# Reinitilize t0 to hold the first element's address in array
	add, $t1, $0, $0    # t1 is the iterator again
	
	
loop2:
	slt $t2, $t1, $s0
	beq $t2, $0, end
	
	lw $t3, 0($t0)		#t3 holds the current element
	
	li $v0, 34
	move $a0, $t0
	syscall
	
	li $v0, 4
	la $a0, spaces
	syscall
	
	li $v0, 1
	move $a0, $t3
	syscall
	
	li $v0, 4
	la $a0, endLine
	syscall
	
	addi $t0, $t0, 4	# Increment base address
	addi $t1, $t1, 1	# Increment iterator
	j loop2
end:

	li $v0, 4
	la $a0, endLine
	syscall
	
# Printing the average
	li $v0, 4
	la $a0, avg
	syscall
	
	li $v0, 1
	move $a0, $s4
	syscall
	
	li $v0, 4
	la $a0, endLine
	syscall

# Printing the max
	li $v0, 4
	la $a0, max
	syscall
	
	li $v0, 1
	move $a0, $s2
	syscall
	
	li $v0, 4
	la $a0, endLine
	syscall
	
# Printing the min
	li $v0, 4
	la $a0, min
	syscall
	
	li $v0, 1
	move $a0, $s3
	syscall
	
	li $v0, 4
	la $a0, endLine
	syscall
	
# End the code
	li $v0, 10
	syscall
	
	
# Data Segment
	.data 
array:		.word 25, 100, -5, 15, 10, 0, 3, 17
size:		.word 8

message: 	.asciiz "Memory Address\t\tArray Element\nPosition (hex)\t\tValue (int)\n===============\t\t=============\n"

avg: 		.asciiz "Average: "
max: 		.asciiz "Max: "
min: 		.asciiz "Min: "
spaces:		.asciiz "\t\t"
endLine: 	.asciiz "\n"
