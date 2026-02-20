;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	[mono] CSpect.exe -w4 -zxnext -nextrom -s28 -fps -60 -brk -map=../../cardTrick/bin/cardTrick.map ../../cardTrick/bin/cardTrick.nex
;
	DEVICE		ZXSPECTRUMNEXT
	CSPECTMAP	"./cards/obj/cardTrick.map"
	
CODEBANK		EQU 0x10

	ORG	0x8000

	DEFINE	ZXN_CARDS_LIB
	
	include 	"./cards/lib/cards.asm"		; must be on a 0x0100 Aligned Address

bootStrap:   
	DI
	NEXTREG		0x50, CODEBANK
	RST			RST0

CARDS_PER_ROW		EQU	0x07
CARDS_PER_COLUMN	EQU	0x03
NUMBER_OF_DEALS		EQU	0x03
MAGIC_CARD_OFFSET	EQU	0x0A
HORIZ_STEP			EQU	(18-10)/(CARDS_PER_ROW-1)
VERT_STEP			EQU	(30-8)/(CARDS_PER_COLUMN-1)
CARD_START_X		EQU	16 - ((HORIZ_STEP*CARDS_PER_ROW)/2)

entryPoint
	CALL		initialise
	EI
	CALL		runCardTrick
	DI
	NEXTREG		0x50, 0xFF
	RST			RST0

	include		"./utils/src/utils.asm"
	include		"./cards/cardtrick/src/animationManagement.asm"
	include		"./cards/cardtrick/src/openingSequenceManagement.asm"
	include 	"./cards/cardtrick/src/trickManagement.asm"
	include 	"./cards/cardtrick/src/initManagement.asm"
	include 	"./cards/cardtrick/src/inputManagement.asm"
	include 	"./cards/cardtrick/src/cardManagement.asm"
	include 	"./cards/cardtrick/src/interruptManagement.asm"
	include 	"./cards/cardtrick/src/soundManagement.asm"

	MMU 0, CODEBANK, 0x0000
RST0:
		DI
		JP 		entryPoint
		DEFS	4,0xff

RST1:
		RET
		DEFS	7, 0xff

RST2:
		RET
		DEFS	7, 0xff

RST3:
		RET
		DEFS	7, 0xff

RST4:
		RET
		DEFS 	7, 0xff

RST5:
		RET
		DEFS 7, 0xff

RST6:
		RET
		DEFS 7, 0xff

RST7:
		EXX
		EX		AF,AF'
		CALL	scanKeyboard
		CALL	animateBorder
		CALL	animateCard
		LD		HL,frames
		INC		(HL)
		EX		AF,AF'
		EXX
		EI
		RETI
frames
		DEFB	0x00

	SAVENEX 	OPEN "./cards/nex/cardtrick.nex", bootStrap, 0xFFFF
	SAVENEX 	CORE 3, 0, 0
	SAVENEX 	AUTO
	SAVENEX 	CLOSE
