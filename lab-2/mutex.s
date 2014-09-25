	.syntax unified
	.arch armv7-a
	.text

	.equ locked, 1
	.equ unlocked, 0

	.global lock_mutex
	.type lock_mutex, function
lock_mutex:
        @ --------------------------------------------- INSERT CODE BELOW

	mov r1, locked		@ save locked value into r1

.LOOP:
	ldrex r2, [r0] 		@ load lockbit from address r0

	cmp r2, #0		@ compare lockbit with unlocked value
	bne .LOOP		@ if locked ( not equal to zero ), restrart 

	strexeq r2, r1, [r0]    @ if unlocked (equal to zero),
				@ store locked value into lockbit
				@ and save the strex state into r2
	cmpeq r2, #0		@ check strex if 0 (successful)
	bne .LOOP		@ if strex NOT successful, restart
	
        @ --------------------------------------------- END CODE INSERT
	bx lr

	.size lock_mutex, .-lock_mutex

	.global unlock_mutex
	.type unlock_mutex, function

unlock_mutex:
	@ --------------------------------------------- INSERT CODE BELOW
        
      	mov r1, unlocked	@ save unlocked value into r1
	str r1, [r0] 		@ store unlocked value into lockbit

        @ --------------------------------------------- END CODE INSERT
	bx lr
	.size unlock_mutex, .-unlock_mutex

	.end
