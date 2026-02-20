runCardTrick
	CALL	setUpScreen
	CALL	openingSequence
	CALL	initialiseDeck
.anotherRound
	CALL	shuffleDeck
	CALL	selectHand
	LD		B,NUMBER_OF_DEALS
.nxtDeal
	PUSH	BC
	CALL	clearScreenInsideBorder
    LD		A,B
	CP		NUMBER_OF_DEALS
	JR		Z,.firstDeal
	LD		DE,0x4850 - 18/2
    LD		HL,shufflingMessage
    LD		B,18
    CALL	prntFadingString
.firstDeal	
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
	CALL	playDrumRoll
	CALL	waitWhileSoundBusy
	LD		A,(cardHand+MAGIC_CARD_OFFSET)
	CALL	decodeCard
	LD		BC,0x0D07
	CALL	drawCard
	CALL	playTada
	LD		A,40
	CALL	waitForFrames
	LD		DE,0x5090 - 22/2
	LD		HL,anotherGoMessage
	LD		B,22
	CALL	prntString
	CALL	waitForYorN
	PUSH	AF
	LD		HL,animateBorderTicks
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
shufflingMessage
	DEFM	YELLOW_INK, "Shuffling Cards..."
okByeForNowMessage
	DEFM	MAGENTA_INK, "OK, Bye For Now!"
startRowLookup
	DEFB	0x02, 0x00, 0x01

cardHand
	DEFS	21, 0x00

workHand
	DEFS	21, 0x00
