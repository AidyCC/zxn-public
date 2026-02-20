selectHand
	LD		DE,cardHand
	LD		HL,cardDeck
	LD		BC,CARDS_PER_ROW * CARDS_PER_COLUMN
	LDIR
	RET

dealHand
	LD		B,CARD_START_X
	LD		HL,cardHand
.nxtRow
	LD		C,0x01
	PUSH	BC
.nxtColumn	
	PUSH	BC, HL
	LD		A,(HL)
	CALL	decodeCard
	CALL	drawCard
	INC		HL
	POP		HL, BC
	LD		A,C
	ADD		VERT_STEP
	LD		C,A
	CP		0x0C
	JR		C,.nxtColumn
	POP		BC
	LD		A,B
	ADD		HORIZ_STEP
	LD		B,A
	CP		0x15
	JR		C,.nxtRow
	RET

cardHand
	DEFS	CARDS_PER_ROW * CARDS_PER_COLUMN, 0x00
	
