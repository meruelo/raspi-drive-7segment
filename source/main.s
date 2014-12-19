/**************************************
 Main program's entry point
**************************************/
.section .init
.globl _start
_start:
	mov sp, #0x8000
	b main

/**************************************
 Main program's main function
 This is only a test to prove the
 functioning of display_number.s
**************************************/
.section .text
main:
	/* Set digit to display */
	mov r0, #22

	/* Set all GPIOs to be used as outputs */
	push {r0, r1, r2, lr}
	ldr r0, =_g 						@ Load the address of the first element
	mov r1, #7							@ Number of pins to be set
	mov r2, #1 							@ Set every PIN as output
	mov r3, #1 							@ Set every PIN to HIGH
	bl setup_pins

	/* Set the digits to zero */
	ldr r0, =digits						@ Load the address of the first element
	ldr r0, [r0]
	mov r1, #2							@ Number of pins to be set
	mov r2, #1 							@ Set every PIN as output
	mov r3, #0 							@ Set every PIN to LOW
	bl setup_pins
	pop {r0, r1, r2, lr}

	display:
		/* Get digits to be displayed */
		push {r0, r1, r2, lr}
		bl get_digits
		mov r3, r0							@ Leftmost digit
		mov r4, r1							@ Rightmost digit
		pop {r0, r1, r2, lr}

		/* Display digit #1 */
		push {r0, r1, r2, r3, r8, lr}
		mov r1, r3 							@ Move rightmost digit to r1
		mov r0, #1 							@ Set rightmost digit to be print
		bl display_digit
		pop {r0, r1, r2, r3, r8, lr}
		
		/* Display digit #2 */
		push {r0, r1, r2, r3, r8, lr}
		mov r1, r4
		mov r0, #0 							@ Set rightmost digit to be print. 
		bl display_digit
		pop {r0, r1, r2, r3, r8, lr}
		
		/* Loop until the end of the days */
		b display


/**************************************
 Data section
**************************************/
.section .data
.balign 4
.global numbers, digits

/* Numbers for each digit */
numbers:
	.word zero, one, two, three, four, five, six, seven, eight, nine, end

/* Pins that control digits */
digits:
	.word _a, _f

/* Elements of the 7-segment that are lit for each number */
zero:
	.word _b, _c, _d, _e, _g, _h

one:
	.word _b, _c

two:
	.word _b, _d, _e, _h, _i

three:
	.word _b, _c,  _e, _h, _i

four:
	.word _b, _c, _g, _i

five:
	.word _c, _e, _g, _h, _i

six:
	.word _c, _d, _e, _g, _h, _i

seven:
	.word _b, _c, _h

eight:
	.word _b, _c, _d, _e, _g, _h, _i

nine:
	.word _b, _c, _g, _h, _i

end:
	.word 0

/* 7-segment element -> GPIO */
_g:
	.word 23
_h:
	.word 24
_i:
	.word 8
_b:
	.word 4
_c:
	.word 17
_d:
	.word 18
_e:
	.word 27
_a:
	.word 11
_f:
	.word 22