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
	IFNDEF	DISABLE_SOUND
		LD		A, B
		NEXTREG	0x56, A
		LD		(sndBank), A
		LD		A, C
		LD		(lastSndBank), A
		LD		(sndEndOffset), HL
		LD		HL, 0xC000
		LD		(sndDataPtr),HL
	ENDIF
	RET

playDrumRoll
	IFNDEF	DISABLE_SOUND
		LD			BC, SNDDRBANK << 8 | SNDDRBANK + 0x1B
		LD			HL, SNDDREND
		CALL		initSound
	ENDIF
	RET

playTada
	IFNDEF	DISABLE_SOUND
		LD			BC, SNDTADABANK << 8 | SNDTADABANK + 0x1A
		LD			HL, SNDTADAEND
		CALL		initSound
	ENDIF
	RET

waitWhileSoundBusy
	IFNDEF	DISABLE_SOUND
		LD		DE, (sndDataPtr)
		LD		A, D
		OR		E
		JR		NZ, waitWhileSoundBusy
	ENDIF
	RET

	IFNDEF	DISABLE_SOUND
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
	ENDIF
	