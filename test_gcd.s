@ Questo è un semplice test della funzione che calcola il MCD tra i due numeri

.data
outp:	.string "GCD is: %d\n"
.text
.global main

main:	mov r0, #81
	mov r1, #153
	push {lr}
	bl GCD	@ chiamo GCD
	@ sposto il risultato in r1
	mov r1, r0
	ldr r0, =outp
	bl printf
	mov r0, #0 @ return 0
	pop {pc}
