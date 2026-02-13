; initialise the new deck
;
; 1 byte per card
;
; high nibble:	card value (1 - Ace ... 13 King)
; low nibble:	suit  (1 -Diamonds, 2, Clubs, 3, Hearts, 4 Spades)
;
initialiseDeck
	LD		B,52
	LD		E,0x01
	LD		HL,cardDeck
.nxtSuit
	LD		D,0x01
.nxtCard
	CALL	encodeCard
	LD		(HL),A
	INC		HL
	INC		D
	LD		A,D
	CP		0x0E
	JR		NZ,.nxtCard
	INC		E
	LD		A,E
	CP		0x05
	JR		C,.nxtSuit
	RET

shuffleDeck
	LD		A,R
.nxtShuffle
	PUSH	BC
	CALL	doShuffleDeck
	POP		BC
	DJNZ	.nxtShuffle
	RET

doShuffleDeck
	LD		B,52
	LD		HL,cardDeck

.suffleNxtCard
	LD		C,B
.nxtRnd
	LD		A,R
	CP		52
	JR		NC,.nxtRnd
	;
	; attempt to randomize a little
	;
	;XOR		L
	;XOR		B
	;LD		B,A
;.rndDelay
;	DJNZ	.rndDelay
;	JR		.nxtRnd
.idxValid
	LD		B,C
	LD		DE,cardDeck		; point DE at random indexed card
	ADD		DE, A
	LD		C,(HL)			; now swap with current card
	LD		A,(DE)
	LD		(HL),A
	LD		A,C
	LD		(DE),A
	INC		HL
	DJNZ	.suffleNxtCard
	RET

encodeCard
	LD		A,D
	AND		%00001111
	SWAPNIB
	LD		C,A
	LD		A,E
	AND		%00001111
	OR		C
	RET

decodeCard
	LD		E,A
	AND		%11110000
	SWAPNIB
	LD		D,A
	LD		A,E
	AND		%00001111
	LD		E,A
	RET

cardDeck
	DEFS	52, 0x00