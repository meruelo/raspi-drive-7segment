/****************************************************************************
 Display digit in the 7segment display
 Inputs:
   r0 - Digit position:
   			0: Leftmost
   			1: Rightmost
   r1 - Digit
   r2 - On cycles
****************************************************************************/
.global display_digit
display_digit:
	/* Check number boundaries */
	cmp r1, #9
	bxhi lr @ If bigger, exit

	/* Organize data ... */
	push {r4, r5, r6, r7, r8, r9, r10, lr}
	mov r9, r1
	ldr r3, =digits

	/* Select digit to be displayed */
	ldr r10, [r3, r0, LSL#2] 	@ Configure GPIO#{r0} as output
	ldr r0, [r10]
	mov r1, #1
	push {r0, r1, r2, r3}
	bl set_gpio_function 
	pop {r0, r1, r2, r3}

	mov r1, #1					@ Set GPIO#{r0} to HIGH (r0 is already set!)
	push {r0, r1, r2, r3}
	bl set_gpio_value
	pop {r0, r1, r2, r3}

	/* Start displaying numbers */
	ldr r4, =numbers        	@ Load base address
	ldr r5, [r4, r9, LSL#2]!	@ Load address where contents for digit r9 are
	ldr r6, [r4, #4]        	@ Load address for next digit
	sub r6, r6, r5		    	@ 
	lsr r6, #2  	        	@ Number of elements thare are used for digit
	sub r6, #1

	loop:						@ We are displaying the number in the inverse order
		ldr r7, [r5, r6, LSL#2]	@ We load the value of the GPIO that we need to lit
		ldr r7, [r7]

		mov r0, r7				@ Configure GPIO#{r7} as output
		mov r1, #1
		push {r0, r1, r2, r3}
		bl set_gpio_function 
		pop {r0, r1, r2, r3}

		mov r0, r7				@ Set GPIO#{r7} to LOW
		mov r1, #0
		push {r0, r1, r2, r3}
		bl set_gpio_value
		pop {r0, r1, r2, r3}

		mov r0, r2				@ Hold it LOW for r2 cycles
		push {r0, r1, r2, r3}
		bl wait
		pop {r0, r1, r2, r3}


		mov r0, r7				@ Set GPIO#{r7} to HIGH
		mov r1, #1
		push {r0, r1, r2, r3}
		bl set_gpio_value
		pop {r0, r1, r2, r3}


		subs r6, #1			@ Get next LED or quit if finished...
		bpl loop

	/* Un-select digit */
	ldr r0, [r10]			@ Set GPIO#{r0} to LOW
	mov r1, #0
	push {r0, r1, r2, r3}
	bl set_gpio_value
	pop {r0, r1, r2, r3}

	pop {r4, r5, r6, r7, r8, r9, r10, lr}
	bx lr