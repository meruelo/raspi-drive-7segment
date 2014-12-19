/**************************************
 Get base adrress for GPIO 
**************************************/
.globl get_gpio_base_address
get_gpio_base_address:
ldr r0, =0x20200000
mov pc, lr

