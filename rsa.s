@ Questo è il main effettivo che effettua prima la codifica e poi la decodifica di un certo messaggio
@ con la chiave pubblica e privata.
@ Per la crittografia RSA ho bisogno: Del messaggio 'msg' da cifrare (un intero),
@ di 2 numeri primi casuali 'p' e 'q', del prodotto di questi due numeri 'n' = p*q,
@ della phi di Eulero dei numeri primi scelti 'phi' = (p-1)*(q-1), di un numero intero
@ 'e' minore di 'n' e coprimo con 'phi'. Infine mi calcolo la chiave privata 'd' che 
@ è anch'essa un intero tale che e*d = 1 mod(phi(n)) (ossia che sia l'inverso in modulo 
@ di 'e').

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
	mov r4, #19	@ in r4 metto il mio messaggio (19)
	push {r0-r1, r4, lr}
	ldr r0, =outp1
	mov r1, r4
	bl printf	@ e qui lo stampo
	pop {r0-r1, r4, lr}
	@ ora voglio calcolare c elevando msg a e e facendolo in modulo 21 (7*3)
	mov r2, r6 @ copio e in r2
	mov r7, r4
	@ in r4 mi tengo il msg:
	push {r0,r1, lr}
	mov r0, r4
	mov r1, r2
	bl mypow
	mov r2, r0 @ ora devo fare in modulo
	pop {r0, r1, lr}
	push {r0, r1, lr}
	mov r0, r2
	mov r1, #21
	bl mymod
	mov r2, r0
	pop {r0, r1, lr}
	push {r0-r1, r7, lr}
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
	push {r0, r1, lr}
	mov r0, r6
	mov r1, r2
	bl mypow
	mov r2, r0
	pop {r0, r1, lr} @ ora devo fare in modulo
	push {r0, r1, lr}
	mov r0, r2
	mov r1, #21
	bl mymod
	mov r2, r0
	pop {r0, r1, lr}
	mov r1, r2
	ldr r0, =outp3
	push {lr}
	bl printf
	pop {pc}
