@Store the number of integers in r4
mov r0, #0
swi 0x6c	@r0 now contains n
mov r4, r0	@r4 has n

mov r6, #0 	@initialise r6 , it will hold the answer

mov r5, #0 @r5 is my loop invariant, loop n times and take an integer 
loop:
	cmp r5,r4
	beq after
	add r5,r5,#1
	mov r0,#0
	swi 0x6c
	add r6,r6,r0
	b loop
after:

mov r0, #1		@print the answer
mov r1, r6
swi 0x6b
swi 0x11
