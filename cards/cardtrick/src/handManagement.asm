selectHand
	LD		DE,cardHand
	LD		HL,cardDeck
	LD		BC,21
	LDIR
	RET

dealHand
	LD		B,0x02
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
	ADD		0x06
	LD		C,A
	CP		0x0C
	JR		C,.nxtColumn
	POP		BC
	LD		A,B
	ADD		0x04
	LD		B,A
	CP		0x15
	JR		C,.nxtRow
	RET

cardHand
	DEFS	21, 0x00
	
