	.data
str: .asciiz "cadljgarhtoxAHdgdsJKhYEasduwBRLsdgHoptxnaseurh"
printa: .asciiz "Sorted string is "
printnewline: .asciiz "\n"
test: .asciiz "testloop\n"

	.text
	.globl main

countSort:
	la		$t0, str
	li		$t1, 255				# (range=255)->$t1
	li		$t2, 1000				# (n=1000)->$t2
	addiu	$sp, $sp, -8
	sw		$ra, 4($sp)
	sw		$fp, 0($sp)
	sll 	$t3, $t2, 2 			# shift N (N*4)				*******
	subu	$sp, $sp, $t3			# char output[N];		*******
	addiu	$t1, $t1, 1 			# range+1
	sll 	$s0, $t1, 2 			# shift range+1 ((range+1)*4)
	subu	$sp, $sp, $s0			# int count[range+1]
	li		$s1, 0					# i = 0 

	loop1: 
		sltu	$s2, $s1, $t1			# (i < range+1) == 1, (i>=range+1) == 0
		beq 	$s2, $0, loopi_0 		# goto loopi_0 if $s2=0
		addu  	$fp, $sp, $0			# move $fp to present position
		sll 	$s3, $s1, 2 			# shift i  (i*4)
		la 		$s4, 0($fp)				# load count[0] to $s4
		addu 	$t3, $s3, $s4			# &count[i]->$t3
		lw		$t4, 0($t3)				
		addu	$t4, $0, $0				# count[i] = 0
		sw		$t4, 0($t3) 
		addiu 	$s1, $s1, 1 			# i++
		j 		loop1

	loopi_0:
		li		$s1, 0					# i = 0

	loop2:
		la 		$s4, 0($t0)				# load address str[0]
		addu 	$t3, $s4, $s1			# &str[i] -> $t3
		lbu		$s4, 0($t3)				# load str[i] -> $s4
		beq		$s4, $0, loopi_1		# if(str[i] == 0) goto loopi_1
		addu  	$fp, $sp, $0			# move $fp to present position
		sll 	$s3, $s4, 2 			# str[i]*4
		la 		$s4, 0($fp)				# load count[0] to $s4
		addu 	$t3, $s4, $s3			# &count[str[i]] -> $t3
		lw		$t4, 0($t3)
		addiu	$t4, $t4, 1 			# count[str[i]]++
		sw		$t4, 0($t3)
		addiu	$s1, $s1, 1 			# i++
		j 		loop2

	loopi_1:
		li 		$s1, 1 					# i = 1

	loop3:
		sltu	$s2, $t1, $s1			# (range < i) == 1
		li 		$s7, 1 					# $s7 = 1
		beq		$s2, $s7, loopi_2
		addu  	$fp, $sp, $0			# move $fp to present position
		addiu	$s6, $s1, -1    		# i-1
		sll   	$s3, $s1, 2 			# i*4 ->$s3
		sll 	$s5, $s6, 2 			# (i-1)*4 ->$s5
		la 		$s4, 0($fp)				# load count[0] to $s4
		addu  	$t5, $s5, $s4			# &count[i-1]-> $t5
		addu 	$t3, $s3, $s4			# &count[i]->$t3
		lw 		$t6, 0($t5)				# load count[i-1] -> $t6
		lw 		$t4, 0($t3)				# load count[i] -> $t4
		addu 	$t4, $t4, $t6			# count[i] += count[i-1]
		sw 		$t4, 0($t3)				# store count[i]
		addiu 	$s1, $s1, 1 			# i++;
		j 		loop3

	loopi_2:
		li		$s1, 0					# i = 0

	loop4:
		la 		$s4, 0($t0)				# load address str[0]
		addu 	$t3, $s4, $s1			# &str[i] -> $t3
		lbu		$s4, 0($t3)				# load str[i] -> $s4
		beq		$s4, $0, loopi_3		# if(str[i] == 0) goto loopi_1
		addu  	$fp, $sp, $0			# move $fp to present position
		sll 	$s3, $s4, 2 			# shift str[i]
		la 		$s2, 0($fp)				# load count[0] to $s4
		addu 	$t3, $s2, $s3			# &count[str[i]] -> $t3
		lw		$t4, 0($t3)
		addiu	$t4, $t4, -1 			# count[str[i]]-1
		sll 	$s5, $t4, 2 			# shift count[str[i]]-1 // (count[str[i]]-1)*4
		la 		$s6, 0($fp)				# load address
		addu 	$s7, $s6, $s0			# &output[0]
		addu  	$s6, $s7, $s5			# output[count[str[i]]-1]
		lw		$t7, 0($s6)				# load output[count[str[i]]-1]
		addiu 	$t7, $s4, 0 			# output[count[str[i]]-1] = str[i];
		sw		$t7, 0($s6)				# store output[count[str[i]]-1]
		sw		$t4, 0($t3)				# store count[str[i]]-1
		addiu 	$s1, $s1, 1 			# i++;
		j 		loop4

	loopi_3:
		li		$s1, 0					# i = 0

	loop5:
		la 		$s4, 0($t0)				# load address str[0]
		addu 	$t3, $s4, $s1			# &str[i] -> $t3
		lbu		$s4, 0($t3)				# load str[i] -> $s4
		beq		$s4, $0, exit_loop		# if(str[i] == 0) goto loopi_1
		addu  	$fp, $sp, $0			# move $fp to present position
		sll 	$s7, $s1, 2
		la 		$t7, 0($fp)
		addu 	$t6, $t7, $s0			# output[0]
		addu 	$t5, $t6, $s7			# output[i]
		lbu		$t4, 0($t5)				# load output[i]
		addu 	$s4, $t4, $0 			# str[i] = output[i];
		sb 		$s4, 0($t3)				# store str[i]
		addiu 	$s1, $s1, 1 			# i++;
		j 		loop5

	exit_loop:
		jr 		$ra

main:
	la		$t0, str 				#load base address str($t0 = str[0])
	jal		countSort

	addu 	$sp, $sp, $s0
	addu 	$sp, $sp, $t2
	lw		$ra, 4($fp)
	lw		$fp, 0($fp)
	addiu	$sp, $sp, 8

	li		$v0, 4
	la   	$a0, printa
	syscall
	li		$v0, 4
	la 		$a0, str  
	syscall
	li		$v0, 4
	la 		$a0, printnewline
	syscall
	end:
		li		$v0, 10
		syscall	

	


	