@ Questo è il main effettivo che effettua prima la codifica e poi la decodifica di un certo messaggio
@ con la chiave pubblica e privata.

.data

start:	.string "Mini RSA encryption and Decryption with ARMv7 Assembler code!\nLet's encrypt message '19':\n\n"
outp1:	.string "Original message is: %d\n"
outp2:	.string "Encrypted message is: %d\n"
outp3:	.string "Decrypted message is: %d\n\nMessage successful decrypted!\n"
debg:	.string "DEBUG: %d\n"

.text
.global main

@ Prendo un intero p e un intero q, calcolo n e phi(n), infine calcolo la chiave 'e' e la chiave 'd'.
@ r4 sarà p, r3 sarà q, n lo metto in r2, phi lo metto in r1, e la metto in r0, d in r5, il messaggio in r6

main:	push {lr}
	ldr r0, =start
	bl printf
	pop {lr}
	push {r4-r7}
	mov r4, #3
	mov r3, #7
	mov r2, r4
	mul r2, r2, r3
	mov r0, #2
	sub r7, r4, #1 @ p-1
	sub r6, r3, #1 @ q-1
	mov r1, r7
	mul r1, r1, r6 @ phi = (p-1)*(q-1) @ fino a qui ho solo inizializzato tutto. 
	mov r5, r1 @ phi lo salvo in r5
	mov r6, r0 @ il numero e di partenza lo salvo in r6
while:	cmp r6, r5 @ se e è minore di phi
	bge end
	push {r0, lr} 
	mov r1, r5 
	mov r0, r6
	bl GCD     @ calcolo il MCD(e,phi)
	cmp r0, #1 @ se è uno ho trovato il mio e effettivo
	pop  {r0, lr}
	beq end
	add r6, r6, #1 @ altrimenti incremento e itero di nuovo
	b while
end:	mov r7, #0	@ arrivato qui, io ho calcolato il mio e (in r6)
	mov r4, r0
	add r7, r5, r5 
	add r7, r7, #1
	mov r5, #0
div:	cmp r7, #1
	ble endiv
	sub r7, r7, r6
	add r5, r5, #1
	b div    @ in R5 ho il risultato della divisione (quindi la mia d) mentre in R6 ho la mia e (5).
endiv:	mov r7, r5 	@ arrivato qui, ho calcolato il mio d (in r7)
	mov r4, #19	@ in r4 metto il mio messaggio (20)
	push {r0-r1, r4, lr}
	ldr r0, =outp1
	mov r1, r4
	bl printf	@ e qui lo stampo
	pop {r0-r1, r4, lr}
	@ ora voglio calcolare c elevando msg a e e facendolo in modulo 21 (7*3)
	mov r2, r6 @ copio e in r2
	mov r7, r4
	@ in r4 mi tengo il msg:
pow:	cmp r2, #1
	beq endpow
	mul r4, r4, r7
	sub r2, r2, #1
	b pow
endpow:	mov r2, r4 @ ora devo fare in modulo
mod:	cmp r2, #21
	blt endmod
	sub r2, r2, #21
	b mod
	@ a questo punto ho finalmente ricavato il mio crittogramma c, lo stampo:
endmod:	push {r0-r1, r7, lr}
	ldr r0, =outp2
	mov r1, r2
	mov r6, r2 @ copio r2 in r6
	bl printf
	pop {r0-r1, r7, lr} @ ora voglio provare a decifrarlo con la mia chiave d (in r5):
	@ la mia chiave d è in r5, mentre il mio crittogramma è in r6
	@ ora io voglio elevare r6 a r5 e poi farlo in modulo:
	@ copio d in r2
	mov r2, r5
	@ il mio crt lo copio in r4
	mov r4, r6
pow2:	cmp r2, #1
	beq endpow2
	mul r6, r6, r4
	sub r2, r2, #1
	b pow2
endpow2:	mov r2, r6 @ ora devo fare in modulo
mod2:	cmp r2, #21
	blt endmod2
	sub r2, r2, #21
	b mod2
endmod2: mov r1, r2
	ldr r0, =outp3
	push {lr}
	bl printf
	pop {pc}
	






