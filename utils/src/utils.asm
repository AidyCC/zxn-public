BLACK_INK			EQU %00000000
BLUE_INK			EQU %00000001
RED_INK				EQU %00000010
MAGENTA_INK			EQU %00000011
GREEN_INK			EQU %00000100
CYAN_INK 			EQU %00000101
YELLOW_INK 			EQU %00000110
WHITE_INK 			EQU %00000111

BLACK_PAPER			EQU BLACK_INK << 3
BLUE_PAPER			EQU BLUE_INK << 3
RED_PAPER			EQU RED_INK << 3
MAGENTA_PAPER		EQU MAGENTA_INK << 3
GREEN_PAPER			EQU GREEN_INK << 3
CYAN_PAPER			EQU CYAN_INK << 3
YELLOW_PAPER		EQU YELLOW_INK << 3
WHITE_PAPER			EQU WHITE_INK << 3

BRIGHT				EQU %01000000
FLASH				EQU %10000000

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
	EX DE,HL
	DUP 8
		LD		A,(DE)
		LD		(HL),A
		PIXELDN
		LD		(HL),A
		PIXELDN
		INC		DE
	EDUP
	EX DE,HL

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

; requires a frames counter intremented every interrupt
;
waitForFrames
	PUSH	BC
	PUSH	HL
	LD		B,A
	LD		HL,frames
.waitNxtInt
	LD		C,(HL)
.waitForFrame
	LD		A,(HL)
	SUB		C
	CP		5
	JR		C,.waitForFrame
	DJNZ	.waitNxtInt
	POP		HL
	POP		BC
	RET

prntFadingString
	PUSH	BC
	PUSH	DE
	CALL	prntStringDblHgt
	POP		DE
	POP		BC
	LD		A,3
	CALL	waitForFrames

	LD		A,D
	.3		RRCA
	AND		%00000011
	OR		%01011000
	LD		D,A

	LD		HL,fadeAttrSequence
	LD		C,5
.nxtInSequence
	PUSH	BC
	PUSH	DE
	LD		A,3
	CALL	waitForFrames
.nxtByte
	LD		A,(HL)
	LD		(DE),A
	ADD		DE,0x0020
	LD		(DE),A
	ADD		DE,-0x001F
	DJNZ	.nxtByte
	POP		DE
	POP		BC
	INC		HL
	DEC		C
	JR		NZ,.nxtInSequence
	RET

fadeAttrSequence
	DEFB BRIGHT | BLACK_PAPER | WHITE_INK
	DEFB BLACK_PAPER | WHITE_INK
	DEFB BLACK_PAPER | CYAN_INK
	DEFB BLACK_PAPER | BLUE_INK
	DEFB BLACK_PAPER | BLACK_INK
