.text
.global mymod
mymod:	cmp r0, r1
	blt end
	sub r0, r0, r1
	b mymod
end:	mov pc, lr
