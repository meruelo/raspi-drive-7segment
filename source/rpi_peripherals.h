/* Define base addresses */
.equ GPIO_BASE_ADDRESS, 0x20200000
.equ SYS_TIMER_BASE_ADDRESS, 0x20003000

/* Load a constant c into r. If the constant does not fit
   on 2⁸ bits a ldr instruction will be created. If it does fit, 
   a mov one will be used instead */
.macro load_constant r:req, c:req
ldr \r,=\c
.endm
