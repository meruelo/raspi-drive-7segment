/****************************************************************************
Configure pins to work for a 7-segment display
   r0 - Address that contains the first element
   r1 - Number of elements
   r2 - GPIO to be configured as I/O
   r3 - GPIO to be set to LOW/HIGH
****************************************************************************/
.globl setup_pins
setup_pins:
push {r4, r5, r8, lr}				@ AAPCS
sub r4, r1, #1				@ Iterate from r1-1 - 0 (length = r1)
	loop:
	ldr r5, [r0, r4, LSL#2]		@ Get pin
	
	push {r0, r1, r2, r3}
	mov r0, r5					@ r0 - GPIO number
	mov r1, r2					@ r1 - GPIO as I/O
	bl set_gpio_function
	pop {r0, r1, r2, r3}

	push {r0, r1, r2, r3}
	mov r0, r5					@ r0 - GPIO number
	mov r1, r3					@ r1 - GPIO value (LOW/HIGH)
	bl set_gpio_value
	pop {r0, r1, r2, r3}
	
	subs r4, r4, #1				@ Get next address
	bpl loop

pop {r4, r5, r8, lr}				@ AAPCS
mov pc, lr
