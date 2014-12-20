/****************************************************************************
 Split number in the form of a·10+b
 Input:  
   r0 - Number
 Outputs:
   r0 - b
   r1 - a
****************************************************************************/
.globl get_digits
get_digits:
	mov r1, #0
	loop:
		subs r0, #10
		addhi r1, #1
		bhi loop
		addls r0, #10
	bx lr