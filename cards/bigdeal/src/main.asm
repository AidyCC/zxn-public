;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	[mono] CSpect.exe -60 -vsync -fps carddemo.nex
;
	DEVICE		ZXSPECTRUM48
	CSPECTMAP	"./cards/obj/bigdeal.map"

	ORG	0x8000
codeStart
	; include the cards library code
	;
	include 	"./cards/lib/cards.asm"
codeEnd
	SAVEBIN		"./cards/bin/cards.bin",codeStart,codeEnd-codeStart
	SAVETAP		"./cards/bin/cards.tap",CODE,"cards.bin",codeStart,codeEnd-codeStart
