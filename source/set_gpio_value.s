/****************************************************************************
Set GPIO contained in r0 to LOW or HIGH as specified in r1
Inputs:
   r0 - GPIO number
   r1 - bit value            
****************************************************************************/
.globl set_gpio_value
set_gpio_value:
	/* Check values */
	cmp r0, #53
	cmpls r1, #1
	moveq r3, #0x1C   	@ Set value offset
	movlo r3, #0x28   	@ Clear value offset
	movhi pc, lr 		@ Return

	mov r2, #0
	push {r4, r5, r6, r7} @ 8-byte aligned (AAPCS)

	/* Get base address */
	mov r4, r0
	push {r6, lr} 		@ 8-byte aligned (AAPCS) 
	bl get_gpio_base_address /* Better with LDR ?*/
	pop {r6, lr}  		@ 8-byte aligned (AAPCS)

	/* Set R0 = GPIO + FUNC s*/
	add r0, r0, r3

	/* Set bit to 1, as the set/clear is handled by setting a bit
	   in two different registers */
	orr r1, #1

	/* Select word: BASE+FUNC+⌊r4/32⌋*4 */
	mov r5, r4, lsr #5 
	lsl r5, #4         
	add r0, r5 			@ Now r0 contains the BASE+FUNC+OFFSET

	/* Set new value for GPIO n */
	and r2, r4, #31    	@ r2 ← r4 mod 32
	mov r1, r1, lsl r2 	@ r1 ← r1 << r2

	/* Clear the old value for GPIO n. Please note that writing a '0' to
	   this register will have no effect, avoiding the need of read+write */
	str r1, [r0]

	pop {r4, r5, r6, r7} @ 8-byte aligned (AAPCS)
	mov pc, lr
