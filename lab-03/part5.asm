## Author: Esad İsmail Tök
## Lab Work part5.asm generates a copy of entered linked list recursively
##
## a0 - the head of the former linked list
## s6 - Holds the head of the original list
## s7 - holds the head of the duplicate of the original list
## v0 - the head of the new linked list
## 


# Test Segment
	.text
	.globl __main
	
__main:
# Creating the linked list
	li	$a0, 10 
	jal	createLinkedList
	move $s6, $v0	# s6 holds the list head
	
# Printing
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
	
# Making a copy of the linked list
	move $a0, $s6
	la $s5, L1
	jal DuplicateListRecursive
L1:	move $s7, $v0
	
# Printing The duplicated list
	li $v0, 4
	la $a0, duplicateMessage
	syscall
	
	move	$a0, $s7
	jal 	printLinkedList
	
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
	
	jr	$ra	# Return to caller
# -------------------------------------------------------------------------
	


# Prints the entered linked list
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
	jr	$ra # Return caller
# -------------------------------------------------------------------------
	

# Duplicates the entered list recursively
# -------------------------------------------------------------------------
DuplicateListRecursive:
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)
	
	move $s0, $a0	# s0 holds the current node of the original linked list
	
	bne $s0, $0, skip
	addi $sp, $sp, 24
	jr $ra
skip:
	
	bne $ra, $s5, skip2
	li	$v0, 9
	li	$a0, 8
	syscall
	
	move $s1, $v0	# s1 holds the head of the duplicate linked list
	move $s4, $v0	# s4 holds the current node of the duplicate linked list
	
	# Copying the first node
	lw $s2, 4($s0)	# s2 holds the data at the current node of orig list
	sw $s2, 4($s4)
	lw $s3, 0($s0)	# s3 holds the address of the next node of the orig list
	move $s0, $s3
	move $a0, $s3
	
	j else
skip2:
	
	
# Generating the new node
	li	$a0, 8
	li	$v0, 9
	syscall
	
# Filling the next pointer and updating the current node of duplicate
	sw $v0, 0($s4)
	move $s4, $v0

# Placing the data of the new node
	lw $s2, 4($s0)
	sw $s2, 4($s4)
	
# Updating the current ptr of the original list
	lw $s3, 0($s0)
	move $s0, $s3
	
	move $a0, $s0
	
else:
	jal DuplicateListRecursive
	
	move $v0, $s1	# Return value will be the head of the duplicate
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
	
	jr $ra	# Return to caller
# -------------------------------------------------------------------------



# Data Segment
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

normalMessage:	.asciiz " Printing The Array\n"
duplicateMessage:	.asciiz "\n\n Printing The Duplicated List\n"
