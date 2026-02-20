openingSequence
	CALL	initialiseDeck
	CALL	shuffleDeck
    LD      BC,0x020B
    LD      DE,0x0001
    CALL    drawCard
    LD      BC,0x040D
    LD      DE,0x0002
    CALL    drawCard
	LD		A,(animateCardTicks+1)
	LD		(animateCardTicks),A
	LD		DE,0x4030-16/2
	LD		HL,cardTrickMessge
	LD		B,16
	CALL    prntStringDblHgt
    LD      A,10
    CALL    waitForFrames
    LD      DE,0x40D0 - 12/2
    LD      HL,welcomeString
    LD      B,12
    CALL    prntFadingString
    LD      A,10
    CALL    waitForFrames
    LD      DE,0x40D0 - 22/2
    LD      HL,amazingString
    LD      B,22
    CALL    prntFadingString
    LD      A,5
    CALL    waitForFrames
    LD      DE,0x40D0 - 22/2
    LD      HL,pressEnterString
    LD      B,22
    CALL    prntStringDblHgt
	XOR		A
	LD		(animateCardTicks),A
    CALL	waitForEnter
    RET

animateCard
	LD		HL,animateCardTicks
	LD		A,(HL)
	AND		A
	RET		Z
	DEC		(HL)
	RET		NZ
	INC		HL
	LD		A,(HL)
	DEC		HL
	LD		(HL),A
    LD		HL,animatedHPos
	LD		B,(HL)
	LD		A,3
	ADD		(HL)
	CP 		0x17
	JR		C,.posOK
	LD		A,0x0D
.posOK
	LD		(HL),A
	INC		HL
	LD		C,(HL)
	LD		A,C
	XOR		%00000110
	LD		(HL),A
    LD		A,(animateCardTicks)
	LD		H,A
	LD		A,R
.tryNxtIdx
	CP		52
	JR		C,.aInRange
	ADD		H
	JR		.tryNxtIdx
.aInRange
	LD		HL,cardDeck
	ADD		HL, A
	LD		A,(HL)
	CALL	decodeCard
    CALL    drawCard
	RET

animateCardTicks
	DEFB	0x00, 0x02
animatedHPos
	DEFB	0x13
animatedVPos
	DEFB	0x0B

cardTrickMessge
	DEFM	YELLOW_INK, "** Card Trick **"
welcomeString
    DEFM    BLUE_INK, "Welcome ...."
amazingString
    DEFM    BLUE_INK, "Prepare To Be Amazed !"
pressEnterString
    DEFM    FLASH | WHITE_PAPER | BLUE_INK, " Press Enter To Start "