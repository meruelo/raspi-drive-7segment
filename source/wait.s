/****************************************************************************
 Timer function via sys timer of raspi. This timer runs at 1MHz
 Inputs:
   r0 - Time to wait (in cycles)
****************************************************************************/
.include "rpi_peripherals.h"
.globl wait
wait:
	mov r3, r0 @ Copy time to wait to r3
	push {r4, lr} @ 8-byte aligned (AAPCS)
	load_constant r0, SYS_TIMER_BASE_ADDRESS

	ldr r1, [r0, #4] @ Read CLO register
	mov r2, r1 @ Put initial counter value into r2

	/* Loop until time passes */
	loop:
		sub r4, r1, r2 @ Now r4 stores time elapsed
		cmp r3, r4
		ldrhi r1, [r0, #4]
		bhi loop

	/* Exit */
	pop {r4, lr} @ 8-byte aligned (AAPCS)
	mov pc, lr @ Exit 
