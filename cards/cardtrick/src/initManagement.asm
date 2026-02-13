initialise
	LD		A,1
	OUT		(0xFE),A
	CALL	clearScreen
	LD		DE,0x5801
	LD		HL,0x5800
	LD		BC,0x2FF
	LD		(HL),7
	LDIR
	RET

clearScreen
	LD		DE,0x4001
	LD		HL,0x4000
	LD		BC,0x17FF
	LD		(HL),L
	LDIR
	RET
