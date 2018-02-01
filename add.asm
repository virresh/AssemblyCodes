	.section .text
	.globl	add,add2
	.type	add, @function
	.type	add2, @function
	
add:
	movl	%edi, %eax		# edi = a, esi = b, this step puts eax = a
	addl	%esi, %eax		# eax = eax + esi, or eax = a + b which is the return value of our function
	ret

add2:
	movl	(%rdi), %eax	# rdi = &a, rsi = &b, this step puts value pointed in rdi register into eax, or eax = a
	movl	(%rsi), %edx	# edx = b
	addl	%edx, %eax		# eax = a + b
	ret
