@ This is just the function that calculates the GCD (massimo comun divisore).
@ The C pseudocode:
@ gcd(int a, int h){
@ 	while(a!=h){
@        if(a > h)
@            a -= h;
@        else
@            h -= a;
@    	}
@ } 

.text
.global GCD

@ r0 -> a, r1 -> h:

GCD:	mov r2, #0	@ faccio qualcosa per permettere di avere un'etichetta
while:	cmp r0, r1
	beq end		@ se sono uguali il mcd è uno dei due, sennò continuo il ciclo
	cmp r0, r1	@ se r0 è <= vado all'else, sennò faccio solo l'if:
	ble else
	sub r0, r0, r1
	b while
else:	sub r1, r1, r0
	b while
end:	mov pc, lr	@ ritorno (il risultato è in r0)
	
  
