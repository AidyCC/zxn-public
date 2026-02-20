;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
SNDDRBANK		EQU CODEBANK + 0x01
SNDTADABANK		EQU SNDDRBANK + 0x1C
SNDDREND		EQU	0xCBA0
SNDTADAEND		EQU	0xDF2E

DAC_B_MIRROR_NR_2C	EQU	0x2C
DAC_AD_MIRROR_NR_2D	EQU	0x2D
DAC_C_MIRROR_NR_2E	EQU	0x2E

initSound
	LD		A, B
	NEXTREG	0x56, A
	LD		(sndBank), A
	LD		A, C
	LD		(lastSndBank), A
	LD		(sndEndOffset), HL
	LD		HL, 0xC000
	LD		(sndDataPtr),HL
	RET

playDrumRoll
	LD			BC, SNDDRBANK << 8 | SNDDRBANK + 0x1B
	LD			HL, SNDDREND
	CALL		initSound
	RET

playTada
	CALL		waitWhileSoundBusy
	LD			BC, SNDTADABANK << 8 | SNDTADABANK + 0x1A
	LD			HL, SNDTADAEND
	CALL		initSound
	RET

waitWhileSoundBusy
	LD		DE, (sndDataPtr)
	LD		A, D
	OR		E
	JR		NZ, waitWhileSoundBusy
	RET

sndHandler
	EXX
	EX		AF,AF'
	LD		DE, (sndDataPtr)
	LD		A, D
	OR		E
	JR		Z, .silence
	LD		HL,sndBank
	LD		A,(lastSndBank)
	CP		(HL)
	JR		NZ,.notLastBank
	LD		HL,(sndEndOffset)
	AND		A
	SBC		HL, DE
	JR		NZ,.notLastBank
	LD		(sndDataPtr),HL
	JR		.silence
.notLastBank
	LD		A, D
	CP		0xE0
	JR		NZ,.noNextChunk

	INC		(HL)
	LD		A, (HL)
	NEXTREG	0x56, A
	LD		DE, 0xC000

.noNextChunk
	LD      A,(DE)                          ; grab sample 
	NEXTREG DAC_C_MIRROR_NR_2E, A           ; send to left channel 
	INC     DE      

	LD		A,(DE)                        ; grab sample 
	NEXTREG DAC_B_MIRROR_NR_2C, A           ; send to right channel 
    INC     DE  

	LD		(sndDataPtr),DE 
.silence
	EX		AF,AF'
	EXX
	EI
	RETI

chunkHandler
	EXX
	EX		AF,AF
;	LD		A,(loadNextChunkFlag)
;	AND		A
;	JR		Z, .noAction
;	XOR		A
;	LD		(loadNextChunkFlag), A

	;LD		HL,sndBank
	;LD		A,(lastSndBank)
	;CP		(HL)
	;JR		NC,.okToIncBank
	;LD		HL,sndEndOffset
	;AND 	A
	;SBC		HL, DE

	;JR		C,.okToIncBank
	;EX		DE, HL

;	LD		HL,sndBank
;	INC		(HL)
;	LD		A, (HL)
;	NEXTREG	0x56, A
;	LD		HL, 0xC000
;	LD		(sndDataPtr), HL
;.noAction
	EX		AF,AF'
	EXX
	EI
	RETI

loadNextChunkFlag
	DEFB	0x00
sndBank
	DEFB	0x00
lastSndBank
	DEFB	0x00
sndEndOffset
	DEFW	0x0000
sndDataPtr
	DEFW	0x0000
