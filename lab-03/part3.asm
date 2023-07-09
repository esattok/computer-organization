## Author: Esad İsmail Tök
## Lab Work part3.asm displays the linked list elements in reverse order using a recursive function
##
## a0 - the head of the linked list
## s0, s1, s2 - saved registeres used in the subprograms
## v0 - returns list head
## 


# Test Segment
	.text
	.globl __main
	
__main:
# Creating the linked list
	li	$a0, 10 
	jal	createLinkedList
	move $s6, $v0	# s6 holds the list head
	
# Normal order printing
	li $v0, 4
	la $a0, normalMessage
	syscall
	
	move	$a0, $s6
	jal 	printLinkedList
	
	li $v0, 4
	la $a0, endLine
	syscall
	li $v0, 4
	la $a0, endLine
	syscall
	
# Reverse order printing
	li $v0, 4
	la $a0, reverseMessage
	syscall
	
	move $a0, $s6
	jal printRecursive
	
	li $v0, 4
	la $a0, endLine
	syscall
	
# End program 
	li	$v0, 10
	syscall
	
	

# Creates a linked list
# -------------------------------------------------------------------------
createLinkedList:

	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	
	
	move	$s0, $a0	
	li	$s1, 1		

	li	$a0, 8
	li	$v0, 9
	syscall

	move	$s2, $v0	
	move	$s3, $v0	
	move $s4, $s1

	sw	$s4, 4($s2)	
	
addNode:

	beq	$s1, $s0, allDone
	addi	$s1, $s1, 1	
	li	$a0, 8 		
	li	$v0, 9
	syscall

	sw	$v0, 0($s2)

	move	$s2, $v0	
	move $s4, $s1

	sw	$s4, 4($s2)	
	j	addNode
allDone:

	sw	$zero, 0($s2)
	move	$v0, $s3	
	

	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	jr	$ra	# Returns to caller
# -------------------------------------------------------------------------
	

# Prints the linked list in normal order
# -------------------------------------------------------------------------
printLinkedList:
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 	


	move $s0, $a0	
	li   $s3, 0
printNextNode:
	beq	$s0, $zero, printedAll
				
	lw	$s1, 0($s0)	
	lw	$s2, 4($s0)	
	addi	$s3, $s3, 1


	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s3	# $s3: Node number (position) of current node
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s0	# $s0: Address of current node
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move	$a0, $s1	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move	$a0, $s2	# $s2: Data of current node
	li	$v0, 1		
	syscall	


	move	$s0, $s1	# Consider next node.
	j	printNextNode
printedAll:


	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra	# Returns to caller
# -------------------------------------------------------------------------
	

# Prints the linked list reverse order recursively 
# -------------------------------------------------------------------------
printRecursive:
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $a0, 8($sp)
	sw $ra, 12($sp)
	sw $s2, 16($sp)
	
	bne $a0, $0, end
	addi $sp, $sp, 20
	jr $ra	# Base case
end:
	
	lw $a0, 0($a0)
	jal printRecursive
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $a0, 8($sp)
	lw $ra, 12($sp)
	lw $s2, 16($sp)
	addi $sp, $sp, 20
	
# Printing
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	lw $s0, 0($a0)	# s0 hold the address of the next node
	lw $s1, 4($a0)	# s1 hold the data in the current node
	move $s2, $a0	# s2 holds the address of the current node
	
	
	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move $a0, $s2	# $s0: Address of current node
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move $a0, $s0	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move $a0, $s1	# $s2: Data of current node
	li	$v0, 1		
	syscall	
	
	
	lw $a0, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	
# End printing

	jr $ra	# return back
# -------------------------------------------------------------------------
	
	
# Data Segmennt
	.data
line:	
	.asciiz "\n --------------------------------------"

nodeNumberLabel:
	.asciiz	"\n Node No.: "
	
addressOfCurrentNodeLabel:
	.asciiz	"\n Address of Current Node: "
	
addressOfNextNodeLabel:
	.asciiz	"\n Address of Next Node: "
	
dataValueOfCurrentNode:
	.asciiz	"\n Data Value of Current Node: "
	
endLine:	.asciiz "\n"

normalMessage:	.asciiz " Printing The Array In Normal Order\n"
reverseMessage:	.asciiz "\n\n Printing The Array In Reverse Order\n"
