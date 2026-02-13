computeCharAddress
	LD			L,A
	LD			H,0
	.3			ADD HL,HL
	ADD			HL,0x3C00
	RET

prntChar
	CALL		computeCharAddress
	PUSH		DE
	.8			LDWS
	POP			DE
	LD			L,E
	LD			A,D
	.3			RRCA
	AND			%00000011
	OR			%01011000
	LD			H,A
	LD			(HL),C
	INC			E
	RET

prntCharDblHgt
	CALL		computeCharAddress
	PUSH		DE
	DUP 4
		LD		A,(HL)
		LD		(DE),A
		INC		D
		LD		(DE),A
		INC		D
		INC		HL
	EDUP
	DEC		D
	EX		DE,HL
	PIXELDN
	EX		DE,HL
	DUP 4
		LD		A,(HL)
		LD		(DE),A
		INC		D
		LD		(DE),A
		INC		D
		INC		HL
	EDUP

	POP			DE
	LD			L,E
	LD			A,D
	.3			RRCA
	AND			%00000011
	OR			%01011000
	LD			H,A
	LD			(HL),C
	ADD			HL,0x0020
	LD			(HL),C
	INC			E
	RET

prntString:
	LD			C,(HL)
	INC			HL
.prntString
	PUSH		HL
	LD			A,(HL)
	CALL		prntChar
	POP			HL
	INC			HL
	DJNZ		.prntString
	RET

prntStringDblHgt:
	LD			C,(HL)
	INC			HL
.prntStringDblHgt
	PUSH		HL
	LD			A,(HL)
	CALL		prntCharDblHgt
	POP			HL
	INC			HL
	DJNZ		.prntStringDblHgt
	RET