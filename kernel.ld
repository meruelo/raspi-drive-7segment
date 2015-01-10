/******************************************************************************
*	kernel.ld
*	 by Alex Chadwick
*    mod by Fernando
*
*	A linker script for generation of raspberry pi kernel images.
******************************************************************************/

SECTIONS {
	/*
	* We also need to set the IVT
	*/
	.vector 0x0000 : {
		*(.vector)
	}
	/*
	* First and formost we need the .init section, containing the code to 
        * be run first. We allow room for the ATAGs and stack and conform to 
        * the bootloader's expectation by putting this code at 0x8000.
        * NOTE: 0x10000 to work in QEMU!
	*/
	.init 0x8000 : {
		*(.init)
	}

	/* 
	* Next we put the rest of the code.
	*/
	.text : {
		*(.text)
	}
	
	/* 
	* Next we put the data.
	*/
	.data : {
		*(.data)
	}

	/*
	* Finally comes everything else. A fun trick here is to put all other 
	* sections into this section, which will be discarded by default.
	*/
	/DISCARD/ : {
		*(*)
	}
}
