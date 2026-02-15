runCardTrick
	CALL	setUpScreen
	CALL	openingSequence
	CALL	initialiseDeck
.anotherRound
	CALL	shuffleDeck
	CALL	selectHand
	LD		B,0x03
.nxtDeal
	PUSH	BC
	CALL	clearScreenInsideBorder
    LD		DE,0x4850 - 16/2
    LD		HL,dealingMessage
    LD		B,16
    CALL	prntFadingString
	CALL	dealHand
	CALL	makeSelection
	CALL	collectHand
	POP		BC
	DJNZ	.nxtDeal
	CALL	selectMagicCard
	JR		Z,.anotherRound
	CALL	clearScreenInsideBorder
	LD		DE,0x4850 - 16/2
	LD		HL,okByeForNowMessage
	LD		B,16
	CALL	prntFadingString
	LD		A,8
	CALL	waitForFrames
	RET

makeSelection
	LD		DE,0x5090 - 30/2
	LD		HL,whichRowMessage
	LD		B,30
	CALL	prntStringDblHgt
	LD		DE,0x50D0 - 30/2
	LD		HL,optionsMessage
	LD		B,30
	CALL	prntString
	LD		HL,keyReleasedStatus
.waitForChoice
	LD		A,(HL)
	AND		%00000111
	JR		Z,.waitForChoice
	LD		C,A
	LD		A,(frames)
	LD		R,A
	XOR		A
	LD		(HL),A
.nxtShift
	INC		A
	RR		C
	JR		NC,.nxtShift
	RET

clearScreenInsideBorder
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
	LD		DE,0x5800
	LD		HL,0x5801
	LD		BC,0x1F
	LD		A,(DE)
	PUSH	AF
	LDIR
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
	DEC		HL
	LD		BC,0x001F
	LDDR
	LD		HL,DE
	ADD		HL,-0x0020
	LD		B,22
1:
	LD		A,(HL)
	LD		(DE),A
	ADD		HL,-0x0020
	ADD		DE,-0x0020
	DJNZ	1B
	POP		AF
	LD		(DE),A
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
	
selectHand
	LD		DE,cardHand
	LD		HL,cardDeck
	LD		BC,21
	LDIR
	RET

dealHand
	LD		BC,0x0201
	LD		HL,cardHand
.nxtRow
	PUSH	BC
.nxtColumn	
	PUSH	BC, HL
	LD		A,(HL)
	CALL	decodeCard
	CALL	drawCard
	LD		A,1
	CALL	waitForFrames
	POP		HL, BC
	LD		A,C
	ADD		0x04
	LD		C,A
	CP		0x0C
	INC		HL
	JR		C,.nxtColumn
	POP		BC
	LD		A,B
	ADD		0x04
	LD		B,A
	CP		0x17
	JR		C,.nxtRow
	RET

;
; collect the hand based on which row was selected
;
; A = row selected (1 - 3)
;
collectHand
	LD		DE,workHand
	LD		HL,startRowLookup - 1
	ADD		HL, A
	LD		C,(HL)
	LD		B,0x03
.nxtColumn
	PUSH	BC
.nxtCard
	LD		HL,cardHand
	LD		A,C
	ADD		HL,A
	LDI
	INC		BC		; restore BC to what it was before the LDI
	LD		A,C
	ADD		0x03
	LD		C,A
	CP		0x15
	JR		C,.nxtCard
	POP		BC
	INC		C
	LD		A,C
	CP		0x03
	JR		C,.noReset
	LD		C,0x00
.noReset
	DJNZ	.nxtColumn
	;
	; reset the hand
	;	
	LD		DE,cardHand
	LD		HL,workHand
	LD		BC,21
	LDIR
	RET
	
selectMagicCard
	LD		C,0x04
	CALL	colourBorder
	LD		HL,animateBorderTicks+1
	LD		A,(HL)
	DEC		HL
	LD		(HL),A	; activate animation
	CALL	clearScreenInsideBorder
	LD		DE,0x4070 - 28/2
	LD		HL,cardSelectedMessage
	LD		B,28
	CALL	prntStringDblHgt
	LD		BC,0x0B07
	LD		DE,0x0000
	CALL	drawCard
	LD		A,25
	CALL	waitForFrames
	LD		A,(cardHand+10)
	CALL	decodeCard
	LD		BC,0x0D07
	CALL	drawCard
	LD		A,40
	CALL	waitForFrames
	LD		DE,0x5090 - 22/2
	LD		HL,anotherGoMessage
	LD		B,22
	CALL	prntString
	LD		C,0x84
	CALL	colourBorder
	CALL	waitForYorN
	PUSH	AF
	LD		HL,animateBorderTicks+1
	LD		(HL),0
	LD		C,0x84
	CALL	colourBorder
	POP		AF
	RET

waitForEnter
	LD		HL,keyReleasedStatus
.waitForEnter
	LD		A,(HL)
	AND		1 << KEY_ENTER
	JR		Z,.waitForEnter
	;LD		A,(frames)
	;LD		R,A
	LD		(HL),0
	RET

waitForYorN
	LD		HL,keyReleasedStatus
.waitForYorN
	LD		A,(HL)
	AND		1 << KEY_Y | 1 << KEY_N
	JR		Z,.waitForYorN
	LD		A,(frames)
	LD		R,A
	BIT		KEY_N,(HL)			; return NZ if N pressed
	LD		(HL),0
	RET

animateBorderTicks
	DEFB	0x00, 0x02

TRborderGraphic
	DEFB	0x03, 0x0F, 0x1F, 0x38, 0x70, 0x70, 0xE0, 0xE0

whichRowMessage
	DEFM	MAGENTA_INK, " Which Row Is Your Card In ?? "

optionsMessage
	DEFM	WHITE_PAPER | BLUE_INK, "(1) Top (2)  Middle (3) Bottom"

cardSelectedMessage
	DEFM	YELLOW_INK, "The Card You Selected Was :-"

anotherGoMessage
	DEFM	FLASH | CYAN_INK, " Another Go ? (Y / N) "
dealingMessage	
	DEFM	YELLOW_INK, "Dealing Cards..."
okByeForNowMessage
	DEFM	MAGENTA_INK, "OK, Bye For Now!"
startRowLookup
	DEFB	0x02, 0x00, 0x01

cardHand
	DEFS	21, 0x00

workHand
	DEFS	21, 0x00
