	.data
	printa: .asciiz "gcd of 1890 and 3315 is "
	printnewline: .asciiz "\n"

	.text # text section
	.globl main # call main by SPIM

gcd:
	addiu	$sp, $sp, -8		# move $sp down for record address $ra and $fp
	sw		$ra, 4($sp)			# store address $ra to stack
	sw		$fp, 0($sp)			# store address $fp to stack
	addu 	$fp, $sp, 0			# move fp to present position
	lw		$t0, 8($sp)			# $t0 <- m
	lw		$t1, 12($sp)		# $t1 <- n
	beq		$t0, $t1, exit_gcd	# if(m==n)
	sltu	$t3, $t1, $t0		# n<m if true $t3=1
	beq		$t3, $0, lastelse	# if(n>=m) goto lastelse
	subu 	$t3, $t0, $t1 		# m-n #start lastelse
	addiu	$sp, $sp, -8		
	sw		$t3, 0($sp)			# push (m-n)
	sw		$t1, 4($sp)			# push n
	jal   	gcd
	addu 	$v0, $v0, $0
	addiu	$sp, $sp, 8
	lw		$ra, 4($fp)
	lw		$fp, 0($fp)
	addiu 	$sp, $sp, 8
	jr		$ra

lastelse:
	subu	$t3, $t1, $t0		# n-m
	addiu  	$sp, $sp, -8
	sw 		$t0, 0($sp)			# push m 
	sw		$t3, 4($sp)			# push (n-m)
	jal 	gcd
	addu 	$v0, $v0, $0
	addiu	$sp, $sp, 8
	lw		$ra, 4($fp)
	lw		$fp, 0($fp)
	addiu 	$sp, $sp, 8
	jr		$ra

exit_gcd:
	addi 	$v0, $t0, 0		# m => $v0 for return m
	lw		$ra, 4($fp)
	lw		$fp, 0($fp)
	addiu	$sp, $sp, 8
	jr		$ra

main: 
	addiu 	$sp, $sp, -8		# change position of pointer down 8 byte for record value 1890 and 3315
	li 		$t0, 1890   		# $t0=1890=m
	li		$t1, 3315			# $t1=3315=n
	sw		$t0, 0($sp)			# store $t0 to stack		
	sw		$t1, 4($sp)			# store $t1 to stack
	jal		gcd 				# jump to gcd
	addu 	$t2, $v0, $0
	addiu	$sp, $sp, 8
	li 		$v0, 4
	la 		$a0, printa
	syscall
	li 		$v0, 1
	addu 	$a0, $t2, $0
	syscall
	li 		$v0, 4
	la 		$a0, printnewline
	syscall
	end:
		li 		$v0, 10 		# return
		syscall