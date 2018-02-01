@ Store the fibonacci number index in r4
mov r0, #0
swi 0x6c	@ r0 now contains n
mov r4, r0	@ r4 has n

mov r6, #0 	@initialise r6 , it will hold the nth fibonacci number
mov r7, #1 	@ r7 is the temporary register to aid in computation
mov r5, #1 	@r5 is my loop invariant, loop n times and take an integer 
loop:
	cmp r5,r4
	beq after
	add r5,r5,#1	@ update loop invariant

	add r6,r6,r7 	@ update fibonacci number
	sub r7,r6,r7
	b loop
after:
mov r5,r6	@ r5 also has the fibonacci number now

@ printing in reverse

reverse_num:
	cmp r5,#0
	ble finish 			@ all digits printed, so exit now

	mov r7,r5
	mov r8,#0

	bl divide_by_ten	@ use the divide routine, and do a branch link to return back to this instruction
	mov r1,r7
	mov r0,#1
	swi 0x6b
	mov r5,r8
	b reverse_num
finish:
swi 0x11		@ exit program


divide_by_ten:
	@ divide the number in r7 by 10 and store the remainder in r7 
	@ and quotient in r8
	@ no safety checks here
	a:
		cmp r7,#10
		blt finish2
		add r8,r8,#1
		sub r7,r7,#10
		b a
	finish2:
	mov pc, r14 	@ return to the instruction that called this routine