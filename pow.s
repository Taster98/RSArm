.text
.global mypow
.type mypow, %function
mypow:	cmp r1, #1
	moveq pc, lr
	push {r0, lr}
	sub r1, r1, #1
	bl mypow
	pop {r1, lr}
	mul r0, r1, r0
	mov pc, lr
