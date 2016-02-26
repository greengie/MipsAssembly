	.data
arrayOfA: .word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
arrayOfB: .word 0x7fffffff, 0x7ffffffe, 0x7ffffffd, 0x7ffffffc,0x7ffffffb, 0x7ffffffa, 0x7ffffff9, 0x7ffffff8, 0x7ffffff7, 0x7ffffff6

printa: .asciiz "Sum a = "
printb: .asciiz "Sum b = "
printnewline: .asciiz "\n"

	.text # text section
	.globl main # call main by SPIM

main:
		li 		$s0, 0 					# $s0 -> int i = 0;
		li 		$s1, 0 					# $s1 -> int sum = 0;
		la 		$s5, arrayOfA 			#(base of array A -> $s5)
	loop1:
		sll 	$s2, $s0, 2  			# $s2 -> i*4
		addu 	$s3, $s5, $s2			# $s3 -> &a[i] 
		lw 		$s4, 0($s3)				# load a[i] -> $s4
		slti 	$s6, $s0, 20			# if (i<20)  $s6 -> 1,0
		beq 	$s6, $0, exitloop1		# if($s6 == 0) goto exitloop1
		addu 	$s1, $s1, $s4			# sum+=a[i]
		addiu 	$s0, $s0, 1 			# i++
		j		loop1
	exitloop1: 
		li 		$v0, 4
		la 		$a0, printa
		syscall
		li 		$v0, 1
		addu 	$a0, $s1, $0
		syscall
		li 		$v0, 4
		la 		$a0, printnewline
		syscall
		li 		$s1, 0 					# sum = 0
		li 		$s0, 0 					# i = 0
		la 		$s5, arrayOfB			# (base of array A -> $s5)
	loop2:
		sll 	$s2, $s0, 2  			# $s2 -> i*4
		addu 	$s3, $s5, $s2			# $s3 -> &b[i] 
		lw 		$s4, 0($s3)				# load b[i] -> $s4
		slti 	$s6,$s0,10				# if (i<10)  $s6 -> 1,0
		beq 	$s6, $0, exitloop2 		# if($s6 == 0) goto exitloop2
		addu 	$s1,$s1,$s4				# sum+=b[i]
		addiu 	$s0,$s0,1 				# i++
		j 		loop2
	exitloop2:
		li $v0, 4
		la $a0, printb
		syscall
		li $v0, 1
		addu $a0, $s1, $0
		syscall
		li $v0, 4
		la $a0, printnewline
		syscall
	end:
		li $v0, 10 			# return
		syscall




