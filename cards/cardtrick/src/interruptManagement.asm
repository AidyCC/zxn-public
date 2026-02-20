;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
INTCTL				EQU	0C0h	; Interrupt control
INTEN0				EQU	0C4h	; INT EN 0
INTEN1				EQU	0C5h	; INT EN 1
INTEN2				EQU	0C6h	; INT EN 2

CTC0				EQU	183Bh	; CTC channel 0 port
CTC1 				EQU	193Bh	; CTC channel 1 port
CTC2 				EQU	1A3Bh	; CTC channel 2 port
CTC3 				EQU	1B3Bh	; CTC channel 3 port

CTCTIMER_CONSTANT	EQU	0x0E	; Timer constant for CTC0 Driving Timing (28Mhz / 14 = 2Mhz)

	MACRO INIT_CTC CTC, cntrl, count
		LD		BC,CTC
		LD		A, cntrl
		OUT		(C),A
		LD		A, count
		OUT		(C),A
	ENDM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	CTC Setup
;
	ALIGN	0x20
	
vector_table:
	DEFW	0					; Line Interupt
	DEFW	0					; UART0 rx
	DEFW	0					; UART1 rx
	DEFW	sndHandler			; CTC0
	DEFW	chunkHandler		; CTC1
	DEFW	0					; CTC2
	DEFW	0					; CTC3
	DEFW	0					; CTC4
	DEFW	0					; CTC5
	DEFW	0					; CTC6
	DEFW	0					; CTC7
	DEFW	RST7				; ULA
	DEFW	0					; UART0 tx
	DEFW	0					; UART1 tx
	DEFW	0
	DEFW	0

ctc_init:
	NEXTREG INTCTL,(vector_table & %11100000) | 1		; Vector 0x00, stackless, IM2 --> isr is disabled without this
	NEXTREG INTEN0,%10000001                            ; Interrupts Enable ULA & Disable Line, Disable /INT
	NEXTREG INTEN2,%00000000                            ; Disable all other UART interupts
	
	IFDEF DISABLE_SOUND
		; Don't need CTC interrupts if no sound
		NEXTREG INTEN1,%00000000						; Disable CTC Interrupts
	ELSE
		NEXTREG INTEN1,%00000001						; Enable CTC Interrupt on Channel 0 Only
		;NEXTREG INTEN1,%00000011						; Enable CTC Interrupt on Channel 0 & 1
	
;---------------------------------------------------------------------------------------------------------
; CTC Control Word Bits
;
; 7: I - Interrupt			0 Disable											1 Enable
; 6: M - Mode				0 Timer Mode										1 Counter Mode
; 5: P - Prescaler			0 16												1 256
; 4: E - Edge				0 Falling Edge										1 Raising Edge
; 3: T - Timer Trigger		0 Automatic Trigger When Time Constant Is Loaded	1 CLK/TRG Pulse Starts Timer
; 2: C - Time Constant		0 No Time Constant Follows							1 Time Constant Follows
; 1: R - Reset				0 Continued Operaion								1 Software Reset
; 0: V - Control or Vector	0 Vector											1 Control Word
;----------------------------------------------------------------------------------------------------------
		; INT
		; Timer
		; 16 Prescaler
		; Falling Edge
		; Trigger On Count Load
		; Time Constraint Follows
		; Continued Operaion
		; Control Word
		INIT_CTC	CTC0, %10000101, 56	; Base Timer for Sound Tempo.  28Mhz / (16 * 56) = 31250Hz

		; INT
		; Timer
		; 256 Prescaler
		; Falling Edge
		; Trigger On Count Load
		; Time Constraint Follows
		; Continued Operaion
		; Control Word
		;INIT_CTC	CTC1, %10101101, 192

		LD      A,high vector_table
		LD      I,A
		IM      2
		EI
	ENDIF	; DISABLE_SOUND
    RET
