/**************************************
 Set GPIO to work as input or output
   r0 - GPIO number
   r1 - GPIO mode (see BCM2835)   
**************************************/
.globl set_gpio_function
set_gpio_function:
cmp r0, #53
cmpls r1, #7
movhi pc, lr

push {r4, r5, r6, lr}

mov r2, #0
find_gpio_register:
	subs r0, #10
	addhs r2, #4
	bhi find_gpio_register
add r0, #10					@ Restore the last substraction (r0 is now the register)

add r0, r0, lsl #1 			@ r0 = 3·r0
lsl r1, r0					@ r1 = r1 << r0 (as each GPIO has 3bits)

push {r0, r1, r2, r3}
bl get_gpio_base_address
mov r4, r0
pop {r0, r1, r2, r3}

ldr r3, [r4, r2]			@ Get old value
mov r5, #7 					@ Set new value while preserving the others
mov r5, r5, lsl r0
bic r3, r5			
orr r1, r3					
str r1, [r4, r2]			@ Store the new value

pop {r4, r5, r6, lr}
mov pc, lr


