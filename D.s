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

bl crc32optimised
mov r1,r0
mov r0,#1
swi 0x6b


swi 0x11		@ ----- exit ------


@ ----- Subroutines used ------

@ ----------- crc32optimised (r1,r2) retun r0 -- stores the crc value in string at r1 of length r2 in r0
crc32optimised:
	
	ldr r7,=0xEDB88320		@ the CRC polynomial in reverse

	mov r5,#0 	@ used for iterating over all the ascii values and storing their crc in table
	loopontable:
		cmp r5,#256
		beq endloopontable
		mov r3,#7
		mov r6,r5
		loopontablebit:
			cmp r3,#0
			blt endloopontablebit
			and r8,r6,#1
			rsb r8,r8,#0

			and r8,r8,r7 @ mask = CRCPOLYREV & mask
			mov r6,r6,lsr#1
			eor r6,r6,r8

			sub r3,r3,#1
			b loopontablebit
		endloopontablebit:
		ldr r8,=Table
		str r6,[r8,r5,lsl#2];
		add r5,r5,#1

		b loopontable
	endloopontable:

	ldr r6,=0xFFFFFFFF		@ initialise crc register ---- has the final value
	mov r3,#0
	mov r4,#0
	mov r5,#0
	@sub r2,r2,#1
	looponmsg:
		cmp r3,r2
		bge endloopmsg
		ldrb r5,[r1,+r3] 	@ r5 now has the i-th byte
		eor r5,r5,r6
		and r5,r5,#0xff
		ldr r4,=Table
		ldr r4,[r4,r5,lsl#2]
		mov r6,r6,lsr#8
		eor r6,r6,r4
		add r3,r3,#1
		b looponmsg
	endloopmsg:
	mvn r0,r6
	mov PC,LR

@ ----------------------------------------------


@ ------ Special Values used / memory locations -------
TextVal: .skip 132
Table: .skip 1024
newline: .byte '\n'
MSize: .word 130