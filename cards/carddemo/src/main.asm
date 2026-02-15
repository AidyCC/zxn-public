;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	[mono] CSpect.exe -60 -vsync -fps carddemo.nex
;
	DEVICE		ZXSPECTRUMNEXT
	CSPECTMAP	"../obj/carddemo.map"
	
	ORG	0x8000
	
	; include the cards library code
	;

	DEFINE		ZXN_CARDS_LIB
	
	include 	"../lib/cards.asm"		; must be on a 0x20 Aligned Address

cardDemo
	XOR		A
	OUT		(0xFE),A
	LD		DE,0x4001
	LD		HL,0x4000
	LD		BC,0x1AFF
	LD		(HL),A
	LDIR
	CALL	drawAllValueCards
	CALL	drawBackAndJokers
	JR		$
	
drawAllValueCards
	LD		C,0x01
	LD		E,0x01
nxtSuit
	LD		B,0x00
	LD		D,0x0D
nxtCard
	PUSH	DE
	PUSH	BC
	LD		A,0x0E
	SUB		D
	LD		D,A
	CALL    drawCard
	POP		BC
	.2	INC 	B
	POP		DE
	DEC		D
	JR		NZ, nxtCard
	LD		A,C
	ADD		A,0x04
	LD		C,A
	INC		E
	LD		A,E
	CP		0x05
	JR		C,nxtSuit
	RET

drawBackAndJokers
	LD	DE,0x0000
	LD	BC,0x0102
nxtSpCard
	PUSH	BC
	PUSH	DE
	CALL    drawCard
	POP		DE
	POP		BC
	LD		A,B
	ADD		0x05
	LD		B,A
	LD		A,C
	ADD		0x03
	LD		C,A
	INC		E
	LD		A,E
	CP		0x03
	JR		NZ,nxtSpCard
	RET

	SAVENEX 	OPEN "../nex/carddemo.nex", cardDemo, 0xFFFF
	SAVENEX 	CORE 3, 0, 0
	SAVENEX 	AUTO
	SAVENEX 	CLOSE
