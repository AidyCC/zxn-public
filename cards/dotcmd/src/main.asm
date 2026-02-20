;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	[mono] CSpect.exe -60 -vsync -fps carddemo.nex
;
	SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
	DEVICE		ZXSPECTRUMNEXT
	CSPECTMAP	"./cards/obj/cardcmd.map"
	
	ORG	0x2000

entryPoint:   
	; header data 
    jr      startUp
	db      "card"
    db      "AidyC"

startUp:  
	LD      A,H
	OR      L								; check if a command line is empty 
	JP      NZ,commandLinePresent			; get hl if = 0 then no command line given, else jump to commandlineOK
show_usage
	LD      HL,helpMessage					; show help text 
	call    printRST16						; print message 
	jp      abortOut			
	
	DEFINE		NO_FRAMES
	include 	"./utils/src/utils.asm"	

commandLinePresent: 
	CALL	readArgument					; read x
	JR		C,abortOut
	LD		B,E								; save x in B
	CALL	readArgument					; read y
	JR		C,abortOut
	LD		C,E
	PUSH    BC								; save y in C
	CALL	readArgument					; read v
	JR		C,abortOut
	LD		B,E								; save v in D
	CALL	readArgument					; read s
	JR		C,abortOut
	LD		D,B
	POP	 	BC
	LD		A,B
	CP		0x19
	LD		HL,xOutOfRangeMessage
	JR		NC,argumentOutOfRange
	LD		A,C
	CP		0x0F
	LD		HL,yOutOfRangeMessage
	JR		NC,argumentOutOfRange
	LD		A,D
	LD		HL,valueOutOfRangeMessage
	CP		0x0E
	JR		NC,argumentOutOfRange	
	LD		A,E
	LD		HL,suitOutOfRangeMessage
	CP		0x05
	JR		C,argumentsValid
argumentOutOfRange
	CALL	printRST16
	JR		abortOut
argumentsValid
	CALL	drawCard						; draw the card
abortOut:
	RET										; exit 

readArgument
	CALL	readInteger						; read x
	CP		","
	RET		Z
	CP		0x0D
	RET		Z
	CP		"0"
	JR		C,invalidInteger
	CP		"9"+1
	JR		NC,invalidInteger
	LD		HL,notEnoughArgumentsMessage
	CALL	printRST16
	SCF
	RET
invalidInteger
	LD		HL,invalidNumberMessage
	CALL	printRST16
	SCF
	RET

readInteger
	LD		DE,0x0000
.readNxtDigit
	LD		A,(HL)
	INC		HL
	AND		A
	RET		Z
	CP		0x20
	JR 		Z,.readNxtDigit	; skip spaces
	CP		0x0D
	RET		Z
	CP		","
	RET		Z
	CP		"0"
	RET		C
	CP		"9"+1
	RET		NC
	CP		":"
	RET		Z
	SUB		"0"
	LD		D, 0x0A
	MUL		D, E
	ADD		E
	LD		E, A
	JR		.readNxtDigit
	
helpMessage
	DEFM	"card - v1.0 by AidyC",13
	DEFM	"Draws A Playing Card.",13,13
	DEFM	"Usage : ",13
	DEFM	" .card x, y, v, s",13,13
	DEFM	"  x=Top Left Corner X position",13
	DEFM	"  y=Top Left Corner Y position",13
	DEFM	"  v=value (1 [Ace] .. 13 [King]",13
	DEFM	"  s=card suit",13
	DEFM	"   1 (Diamonds)", 13
	DEFM	"   2 (Clubs),",13
	DEFM	"   3 (Hearts),",13
	DEFM	"   4 (Spades)",13,13
	DEFM	" When v & s are 0 the card back",13
	DEFM	"  is drawn.",13,13
	DEFM	" For Jokers use v=0 and s=",13
	DEFM	"  1 (Red Joker), or",13
	DEFM	"  2 (Black Joker).",13
	DEFM    0 
notEnoughArgumentsMessage
	DEFM	"Not Enough Arguments.",13,13
	DEFM    0
xOutOfRangeMessage
	DEFM	"X Position Out Of Range.",13,0
yOutOfRangeMessage
	DEFM	"Y Position Out Of Range.",13,0
valueOutOfRangeMessage
	DEFM	"Card Value Out Of Range (1-13).",13,0
suitOutOfRangeMessage
	DEFM	"Card Suit Out Of Range (1-4).",13,0
invalidNumberMessage
	DEFM	"Invalid Number.",13,0
;------------------------------------------------------------------------------

	; include the cards library code
	;
	DEFINE		ZXN_CARDS_DOT_CMD
	ALIGN		0x0100
	
	include 	"./cards/lib/cards.asm"		; must be on a 0x0100 Aligned Address
endOfCode
	SAVEBIN "./cards/dot/CARD",entryPoint,endOfCode-entryPoint