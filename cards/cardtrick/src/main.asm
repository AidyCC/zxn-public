;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	[mono] CSpect.exe -w4 -zxnext -nextrom -s28 -fps -60 -brk -map=../../cardTrick/bin/cardTrick.map ../../cardTrick/bin/cardTrick.nex
;
	DEVICE		ZXSPECTRUMNEXT
	CSPECTMAP	"../obj/cardTrick.map"
	
CODEBANK		EQU 0x10

	ORG	0x8000

	include 	"../lib/cards.asm"		; must be on a 0x0100 Aligned Address

bootStrap:   
	DI
	NEXTREG		0x50, CODEBANK
	RST			RST0

entryPoint	
	CALL	initialise
	EI
	JP		runCardTrick

	include		"../../utils/src/utils.asm"
	include 	"./src/trickManagement.asm"
	include 	"./src/initManagement.asm"
	include 	"./src/inputManagement.asm"
	include 	"./src/cardManagement.asm"

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
		LD		HL,frames
		INC		(HL)
		EX		AF,AF'
		EXX
		EI
		RETI
frames
		DEFB	0x00

	SAVENEX 	OPEN "../nex/cardtrick.nex", bootStrap, 0xFFFF
	SAVENEX 	CORE 3, 0, 0
	SAVENEX 	AUTO
	SAVENEX 	CLOSE
