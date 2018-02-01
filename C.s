@ ----- PA4, 2016118, Viresh Gupta ----------
@ Gives output as signed integer rather than the unsigned representation
@ ------ code to read the input -----
mov r0,#0
swi 0x6c		@	read integer which is the length of the string
mov r9,r0 		@	r2 has the length of the string

mov r0,#0
ldr r1,=TextVal
ldr r2,=MSize
ldr r2,[r2]
swi 0x6a		@ 	bogus code to read the extra newline

mov r0,#0
ldr r1,=TextVal
ldr r2,=MSize
ldr r2,[r2]
swi 0x6a

@ ------ main routine -----

ldr r1,=TextVal		@ load first argument to crc32
mov r2,r9			@ load length of the string

bl crc32unoptimised
mov r1,r0
mov r0,#1
swi 0x6b


swi 0x11		@ ----- exit ------


@ ----- Subroutines used ------

@ ----------- crc32unoptimised (r1,r2) return r0 -- stores value of crc of string pointed in r1 of length r2 in r0
crc32unoptimised:
	
	ldr r6,=0xFFFFFFFF		@ initialise crc register ---- has the final value
	ldr r7,=0x04C11DB7		@ the CRC polynomial
	mov r4,#0
	STMFD r13!, {LR}		@ store the link register on stack
	loopontext:
		cmp r4,r2
		beq endloopontext
			@--- r4 is the loop invariant, r5 will store current bit---
			ldrb r5,[r1, +r4]
			
			STMFD r13!, {r0-r4}		@ Store these values onto stack before calling reverse
				mov r1,r5
				bl reversal			@ now r0 has reversed bit
				mov r5,r0
				mov r1,#0 			@ second loop invariant
				looponmessagebit:
					cmp r1,#8
					beq endlooponmessagebit

					eor r2,r6,r5
					ldr r3,=0x80000000
					and r2,r2,r3
					cmp r2,#0
					beq else
					if:
						mov r6,r6,lsl#1
						eor r6,r6,r7			@ Take remainder with crcPolynomial
					b endif
					else:
						mov r6,r6,lsl#1			@ Just go to the next bit
					endif: 
					mov r5,r5,lsl#1
					add r1,r1,#1
					b looponmessagebit
				endlooponmessagebit:
			LDMFD r13!, {r0-r4}
			add r4,r4,#1
		b loopontext
	endloopontext:

	mvn r1,r6
	bl reversal				@ store the final crc value into r0
	LDMFD r13!,{LR}			@ retrive value of Link Register
	mov PC,LR

@--------------------------------------------



@ -------- rbit (r1) return r0 -- reverse bits of r1 and store in r0
reversal:
	
	ldr r2,=0x55555555 		@ 0x55555555 in r2, to swap with adjacent bit
	mov r3,r1,lsr#1
	and r3,r3,r2
	and r4,r1,r2
	mov r4,r4,lsl#1
	orr r1,r3,r4

	ldr r2,=0x33333333 		@ 0x33333333 in r2, to swap groups of 2
	mov r3,r1,lsr#2
	and r3,r3,r2
	and r4,r1,r2
	mov r4,r4,lsl#2
	orr r1,r3,r4
	
	ldr r2,=0x0F0F0F0F 		@ 0x0F0F0F0F in r2, to swap groups of 4
	mov r3,r1,lsr#4
	and r3,r3,r2
	and r4,r1,r2
	mov r4,r4,lsl#4
	orr r1,r3,r4

	ldr r2,=0x00FF00FF 		@ 0x00FF00FF in r2, to swap groups of 8
	mov r3,r1,lsr#8
	and r3,r3,r2
	and r4,r1,r2
	mov r4,r4,lsl#8
	orr r1,r3,r4

	mov r3,r1,lsl#16		@ Swap half words
	mov r4,r1,lsr#16
	orr r1,r3,r4

	mov r0,r1
	mov PC,LR

@ ------ Special Values used / memory locations -------
TextVal: .skip 132
Table: .skip 1024
newline: .byte '\n'
MSize: .word 130