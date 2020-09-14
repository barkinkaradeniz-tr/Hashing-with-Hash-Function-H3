############################################
# MATRIKELNUMMER: 411576	
# VORNAME: Barkin
# NACHNAME: Karadeniz
############################################

.data 
	q:			.word 	44 47 53 0 3 59 3 39 9 19 21 50 36 23 6 24 24 12 58 1 38 39 23 46 24 17 37 25 13 8 9 20 51 16 51 5 62 15 47 0 18 35 24 49 51 29 19 19 14 39 32 1 9 57 63 32 31 10 52 23 35 62 11 50 55 28 34 0 0 36 53 5 38 40 52 17 15 4 41 42 58 31 56 1 1 39 41 57 35 38 55 11 46 18 27 0 14 35 53 12 57 42 20 11 4 6 4 47 63 52 3 12 36 52 40 14 15 20 35 58 23 15 13 53 21 48 49 5 41 35 0 31 5 30 0 49 50 36 34 48 29 3 34 42 13 48 39 21 9 63 0 10 50 43 58 63 23 59 2 57
	seed: 			.word 	0
	key: 			.word	6

	output_text: 		.asciiz "The hash values is: "

############################################
# Keys with their corresponding Hash Values for the seed 0
# Key	- > Hashwert 
#  0	- >		0
#  1	- > 	44
#  2 	- >		47 
#  3 	- > 	3
#  4 	- >		53
#  5 	- > 	25 
#  6	- > 	26 
#  7 	- > 	54
############################################

.text 

main:
	# Register save
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	
	la $a0, q
	lw $a1, seed
	lw $a2, key 
	jal H3_hash
	move $s0, $v0 
	
	la $a0, output_text
	jal print_string
	
	move $a0, $s0
	jal print_int
	jal print_new_line
	
	# Register restore
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	
	# exit programm 
	li $v0, 10
	syscall

########################################################################################


# $a0: int to print
print_int:
	li $v0, 1
	syscall

	jr $ra
	
# $a0: char to print
print_char:
	li $v0, 11
	syscall
	jr $ra

print_new_line:
	addi $a0, $0, 0x0A		## ASCII \n
	li $v0, 11
	syscall

	jr $ra

# $a0: string address to print
print_string:
	li $v0, 4
	syscall

	jr $ra

########################################################################################


# Calclulates the H3-hash value for a given key and seed
# 
# $a0: Base address of array q
# $a1: Seed value
# $a2: Key value

# $v0: Calculated hashvalue
H3_hash:
	
	addi $sp, $sp, -8
	sw $s6, 0($sp)
	sw $s7, 4($sp)
	
	move $t1, $zero		
	addi $t1, $a1, 1  
	mul  $t1, $t1, 32
	subi $t1, $t1, 1	#length
	
	addi $t0, $t1, -31	#sublimit
	li $s6, 31		#counter for 2^31, 2^30 ... 
	li $t2, 1		#constant
	

	sllv $s7, $t2, $s6	#s7 = 2^31
	and $t4, $a2, $s7	#checks if key has 0 or 1 in 32th digit
	beq $t4, $s7, exists
	j calculation
	
	exists:
		li $t4, 1	
		
	calculation:
		mul $t6, $t1, 4
		add $t6, $a0, $t6
		lw $t6, 0($t6)		#loads the  number  
		mul $t6, $t6, $t4	#checks if t6 exists
		
	
	for:
		addi $s6, $s6, -1	#counter for 2^31 -1 ...
		addi $t1, $t1, -1	#counter - 1
		sllv $t3, $t2, $s6	#t3 = 2^30
		and $t5, $a2, $t3	#checks if key has 0 or 1 in 31th digit(on the first loop)
		beq $t5, $t3, exists2	
		j calculation2
		
		exists2:
			li $t5, 1
		
		calculation2:
			mul $t7, $t1, 4
			add $t7, $a0, $t7
			lw $t7, 0($t7)
			mul $t7, $t7, $t5
		
			or $t8, $t6, $t7	#or for xor
			and $t9, $t6, $t7	#and for xor
			sub $t6, $t8, $t9	#sub for xor
			ble $t1, $t0, endfor
			j for
	
	endfor:
		lw $s6, 0($sp)
		lw $s7, 4($sp)
		addi $sp, $sp, 8
		move $v0, $t6
		jr $ra
	

########################################################################################
