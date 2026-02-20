clearScreenInsideBorder
	PUSH	BC
	LD		HL,0x5821
	LD		B, 22
.clrNxtAttrLine
	PUSH	BC
	PUSH	HL
	LD		DE,HL
	INC		DE
	LD		(HL),0x00
	LD		BC,0x1D
	LDIR
	POP		HL
	POP		BC
	ADD		HL,0x0020
	DJNZ	.clrNxtAttrLine
	
	LD		HL,0x4021
	LD		B, 22 * 8
.clrNxtPixelLine
	PUSH	BC
	PUSH	HL
	LD		DE,HL
	INC		DE
	LD		(HL),0
	LD		BC,0x1D
	LDIR
	POP		HL
	POP		BC
	PIXELDN
	DJNZ	.clrNxtPixelLine
	POP		BC
	RET

setUpScreen
	LD		C,0x84
	CALL	colourBorder
	LD		DE,0x4000
	LD		HL,TRborderGraphic
	LD		B,0x08
1:
	LD		A,(HL)
	LD		(DE),A
	ADD		DE,0x001F
	MIRROR	A
	LD		(DE),A
	ADD		DE,-0x001F
	INC		HL
	INC		D
	DJNZ	1B
	
	LD		B,30
	LD		DE,0x4001
	LD		A,%11111111
1:
	LD		(DE),A
	INC		D
	LD		(DE),A
	INC		D
	LD		(DE),A
	ADD		DE, 0x15E0
	LD		(DE),A
	DEC		D
	LD		(DE),A
	DEC		D
	LD		(DE),A
	ADD		DE, -0x15E0
	INC		E
	DJNZ	1B

	LD		B,22*8
	LD		HL,0x4020
1:
	LD		(HL),%11100000
	ADD		HL,0x001F
	LD		(HL),%00000111
	ADD		HL,-0x001F
	PIXELDN
	DJNZ	1B

	LD		DE,0x50E0
	LD		HL,TRborderGraphic+7
	LD		B,8
1:
	LD		A,(HL)
	LD		(DE),A
	ADD		DE,0x001F
	MIRROR	A
	LD		(DE),A
	ADD		DE,-0x001F
	DEC		HL
	INC		D
	DJNZ	1B
	RET

colourBorder
	LD		HL,0x5800
	LD		B,0x20
	LD		DE,0x0001
	CALL 	colourBar
	ADD		HL,0x1F
	LD		B,23
	LD		DE,0x0020
	CALL 	colourBar
	ADD		HL,-0x21
	LD		B,31
	LD		DE,-0x0001
	CALL 	colourBar
	ADD		HL,-0x1F
	LD		B,22
	LD		DE,-0x0020
	CALL 	colourBar
	RET

animateBorder
	LD		HL,animateBorderTicks
	LD		A,(HL)
	AND		A
	RET		Z
	DEC		(HL)
	RET		NZ
	INC		HL
	LD		A,(HL)
	DEC		HL
	LD		(HL),A
	LD		HL,.borderAnimationTable
	LD		A,(cardHand+MAGIC_CARD_OFFSET)
	AND		%00000011
	ADD		A
	ADD		HL,A
	LD		E,(HL)
	INC		HL
	LD		D,(HL)
	EX		DE,HL
	LD		B,(HL)
	INC		HL
.animateNxtSection
	LD		E,(HL)
	INC		HL
	LD		D,(HL)
	INC		HL
	PUSH	BC
	PUSH	HL
	PUSH	.animateBorderReturn
	EX		DE,HL
	JP		(HL)
.animateBorderReturn
	POP		HL
	POP		BC
	DJNZ	.animateNxtSection
	RET
	
.animateRightHalfAntiClockWise
	LD		DE,0x5810
	LD		HL,0x5811
	LD		BC,0x000F
	LD		A,(DE)
	PUSH	AF
	LDIR
	CALL	scrollSideUp
	LD		HL,DE
	DEC		HL
	LD		BC,0x000F
	LDDR
	POP		AF
	LD		(DE),A
	RET

.animateLeftHalfAntiClockWise
	LD		DE,0x580F+23*0x20
	LD		HL,0x580E+23*0x20
	LD		BC,0x000F
	LD		A,(DE)
	PUSH	AF
	LDDR
	CALL	scrollSideDown
	LD		HL,DE
	INC		HL
	LD		BC,0x000F
	LDIR
	POP		AF
	LD		(DE),A
	RET
	
.animateRightHalfClockWise
	LD		DE,0x5810+23*0x20
	LD		HL,0x5811+23*0x20
	LD		BC,0x000F
	LD		A,(DE)
	PUSH	AF
	LDIR
	CALL	scrollSideDown
	LD		HL,DE
	DEC		HL
	LD		BC,0x000F
	LDDR
	POP		AF
	LD		(DE),A
	RET

.animateLeftHalfClockWise
	LD		DE,0x5800+0x0F
	LD		HL,0x5800+0x0E
	LD		BC,0x000F
	LD		A,(DE)
	PUSH	AF
	LDDR
	CALL	scrollSideUp
	INC		HL
	LD		BC,0x000F
	LDIR
	POP		AF
	LD		(DE),A
	RET

.animateClockwise
	LD		DE,0x5800+0x1F
	LD		HL,0x5800+0x1E
	LD		BC,0x1F
	LD		A,(DE)
	PUSH	AF
	LDDR
	CALL	scrollSideUp
	INC		HL
	LD		BC,0x001F
	LDIR
	CALL	scrollSideDown
	POP		AF
	LD		(DE),A
	RET
	
.animateAntiClockwise
	LD		DE,0x5800
	LD		HL,0x5801
	LD		BC,0x1F
	LD		A,(DE)
	PUSH	AF
	LDIR
	CALL	scrollSideUp
	DEC		HL
	LD		BC,0x001F
	LDDR
	CALL	scrollSideDown
	POP		AF
	LD		(DE),A
	RET

.borderAnimationTable
	DEFW	.borderAnimation1
	DEFW	.borderAnimation2
	DEFW	.borderAnimation3
	DEFW	.borderAnimation4
	
.borderAnimation1
	DEFB	0x01
	DEFW	.animateAntiClockwise
.borderAnimation2
	DEFB	0x01
	DEFW	.animateClockwise
.borderAnimation3
	DEFB	0x02
	DEFW	.animateLeftHalfAntiClockWise, .animateRightHalfClockWise
.borderAnimation4
	DEFB	0x02
	DEFW	.animateLeftHalfClockWise, .animateRightHalfAntiClockWise

scrollSideUp
	LD		HL,DE
	ADD		HL,0x0020
	LD		B,23
1:
	LD		A,(HL)
	LD		(DE),A
	ADD		HL,0x0020
	ADD		DE,0x0020
	DJNZ	1B
	LD		HL,DE
	RET

scrollSideDown
	LD		HL,DE
	ADD		HL,-0x0020
	LD		B,23
1:
	LD		A,(HL)
	LD		(DE),A
	ADD		HL,-0x0020
	ADD		DE,-0x0020
	DJNZ	1B
	RET
	
colourBar
	LD		A,C
	AND		%01111111
	LD		(HL), A
	ADD		HL,DE
	CALL	setAndAdvanceColour
	DJNZ	colourBar
	RET

setAndAdvanceColour
	BIT		7,C
	RET		NZ ; don’t advance (static colour)
	INC		C
	LD		A,C
	AND		%01111111
	CP		%00001000
	RET		C
	LD		C,0x01
	RET
	
animateBorderTicks
	DEFB	0x00, 0x02

TRborderGraphic
	DEFB	0x03, 0x0F, 0x1F, 0x38, 0x70, 0x70, 0xE0, 0xE0
