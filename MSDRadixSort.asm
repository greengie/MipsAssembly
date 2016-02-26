.data
data: .word 132470, 324545, 73245, 93245, 80324542, 244, 2, 66, 236, 327, 236, 21544
printData: .asciiz "data["
printClose: .asciiz "] = "
newLine: .asciiz "\n" 
printsort: .asciiz "\n\nSorted\n"

	.text
	.globl main

#//////////////////////////////////////////////////////////////

partition:
	addiu 	$sp, $sp, -8 
	sw 		$ra, 4($sp)
	sw 		$fp, 0($sp)	
	addu 	$fp, $sp, $0
	lw		$t0, 8($fp)					# load first
	lw		$t1, 12($fp)				# load last
	lw		$t2, 16($fp)				# load msb
	addu 	$t3, $t0, $0 				# move first to $t3 // f = first
	addu	$t4, $t1, $0				# move last to $t3 // l = last
	#while(f<l)
	while:
		slt 	$t5, $t3, $t4 		# (f<l) == 1
		beq 	$t5, $0, exitwhile
		#while (((((*f >> msb) & 0x1)) == 0) && (f < last)) 
		while1:
			lw		$t5, 0($t3) 	# load f//*f
			srlv 	$t6, $t5, $t2 	# *f >> msb
			and 	$t7, $t6, 0x1
			bne 	$t7, $0, while2
			slt		$t7, $t3, $t1 	# f<last
			beq 	$t7, $0, while2
			addiu  	$t3, $t3, 4 	# f++
			j 		while1
		#while (((((*l >> msb) & 0x1)) == 1) && (first < l))  
		while2:
			lw		$t5, 0($t4) 	# load l//*l
			srlv 	$t6, $t5, $t2 	# *l >> msb
			and 	$t7, $t6, 0x1
			beq 	$t7, $0,  goif
			slt 	$t7, $t0, $t4 	# first<l
			beq 	$t7, $0, goif
			addiu 	$t4, $t4, -4 	# l--
			j 		while2	
		#if (l > f)
		goif:
			slt 	$t5, $t3, $t4 		# f<l
			beq 	$t5, $0, exitwhile
			lw	 	$t5, 0($t3)	 		# load *f -> $t5
			addu 	$t6, $t5, $0 		# temp = *f
			lw		$t7, 0($t4)			# load l//*l
			addu 	$t5, $t7, $0 		# *f=*l
			addu 	$t7, $t6, $0 		# *l = temp
			sw		$t7, 0($t4)  		# store *l to l
			sw		$t5, 0($t3) 		# store *f to f
	j 		while
	
	exitwhile:
		addu 	$v0, $t4, $0 			# return l
		lw 		$ra, 4($sp)
		lw 		$fp, 0($sp)
		addiu 	$sp, $sp, 8
		jr 		$ra

#//////////////////////////////////////////////////////////////

msd_radix_sort:
	addiu 	$sp, $sp, -8 
	sw 		$ra, 4($sp)
	sw 		$fp, 0($sp)			
	addu 	$fp, $sp, $0
	lw		$t0, 8($fp)				# load data // first
	lw 		$t1, 12($fp)			# load data[n-1] // last
	lw 		$t2, 16($fp)			# load 31 // msb

	#if (first < last && msb >= 0) 
	if:
		slt 	$t3, $t0, $t1 		# first<last == 1
		beq 	$t3, $0, exitif
		slt 	$t3, $t2, $0 		# msb < 0
		bne 	$t3, $0, exitif
		addiu 	$sp, $sp, -12 		# move stack to store first,last,msb
		sw 		$t0, 0($sp)			# store first
		sw 		$t1, 4($sp)			# store last
		sw		$t2, 8($sp)			# store msb
		addu 	$fp, $sp, $0 		#

		jal 	partition

		lw 		$t0, 0($fp)			# store first
		lw 		$t1, 4($fp)			# store last
		lw		$t2, 8($fp)			# store msb	
		addiu 	$sp, $sp, 12
		addu 	$fp, $sp, $0
		addiu 	$t2, $t2, -1 		# msb--
		addu 	$t3, $v0, $0        # mid = partition(first, last, msb)
		#*************************
		addiu 	$sp, $sp, -12
		sw 		$t0, 0($sp)			# store first
		sw 		$t3, 4($sp)			# store mid
		sw 		$t2, 8($sp)			# store msb
		addu 	$fp, $sp, $0

		#msd_radix_sort(first, mid, msb);
		jal 	msd_radix_sort 

		lw 		$t0, 0($sp)			# store first
		lw 		$t3, 4($sp)			# store mid
		lw 		$t2, 8($sp)			# store msb
		addiu 	$sp, $sp, 12
		addu 	$fp, $sp, $0
		addiu 	$t3, $t3, 4 		# mid+1
		#*********************
		addiu 	$sp, $sp, -12
		addu 	$fp, $sp, $0
		sw 		$t3, 0($fp)			# store mid+1
		sw 		$t1, 4($fp)			# store last
		sw 		$t2, 8($fp)			# store msb
		
		#msd_radix_sort(mid+1, last, msb)

		jal 	msd_radix_sort
		addiu 	$sp, $sp, 12
		addu 	$fp, $sp, $0

	exitif:
		lw 		$ra, 4($fp)
		lw 		$fp, 0($fp)
		addiu 	$sp, $sp, 8
		jr 		$ra

#///////////////////////////////////////////////////////////////////////////////////////////////////

main:
	la		$s0, data 				# load data[0]
	li 		$s1, 12 				# N = 12
	li 		$s2, 0 					# i = 0

	loop1:
		beq		$s2, $s1, exitloop1 	# i=N goto exitloop1
		li 		$v0, 4
		la 		$a0, printData
		syscall
		li 		$v0, 1
		addu 	$a0, $s2, $0 
		syscall
		li 		$v0, 4
		la 		$a0, printClose
		syscall
		sll 	$s3, $s2, 2 			# i*4
		addu 	$s4, $s3, $s0 			# data[i]
		lw		$s5, 0($s4)  
		li 		$v0, 1
		addu 	$a0, $s5, $0
		syscall
		li 		$v0, 4
		la 		$a0, newLine
		syscall
		addiu 	$s2, $s2, 1 			# i++
		j		loop1
	exitloop1:
		addiu 	$sp, $sp, -12 			# move stack to store 3 argument
		addu 	$t0, $s0, $0 			# $t0 = data *************
		sw 		$t0, 0($sp)				# store data to stack
		addiu 	$t1, $s1, -1 			# N-1 
		sll 	$t2, $t1, 2 			# (N-1)*4
		addu 	$t3, $s0, $t2 			# data[N-1]
		sw 		$t3, 4($sp) 			# store data[N-1] to stack 
		li 		$t4, 31 				# $t4 = 31
		sw 		$t4, 8($sp) 			# store 31 to stack

		jal 	msd_radix_sort

		li 		$v0, 4
		la 		$a0, printsort
		syscall
		# reinitial value
		la		$s0, data 				# load data[0]
		li 		$s1, 12 				# N = 12
		li 		$s2, 0 					# i = 0

	loop2:
		beq		$s2, $s1, exitloop2 	# i=N goto exitloop1
		li 		$v0, 4
		la 		$a0, printData
		syscall
		li 		$v0, 1
		addu 	$a0, $s2, $0 
		syscall
		li 		$v0, 4
		la 		$a0, printClose
		syscall
		sll 	$s3, $s2, 2 			# i*4
		addu 	$s4, $s3, $s0 			# data[i]
		lw		$s5, 0($s4)  
		li 		$v0, 1
		addu 	$a0, $s5, $0
		syscall
		li 		$v0, 4
		la 		$a0, newLine
		syscall
		addiu 	$s2, $s2, 1 			# i++
		j		loop2

	exitloop2:
		li 		$v0, 10
		syscall