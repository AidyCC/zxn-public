; ***************************************************************************
; * Spectrum 48K standard addresses                                         *
; ***************************************************************************

GET_CHAR_r3             equ     $0018           ; get current character
NEXT_CHAR_r3            equ     $0020           ; get next character
BC_SPACES_r3            equ     $0030           ; allocate workspace
CLS_r3                  equ     $0d6b           ; CLS (for layer 0)
OUT_CODE_r3             equ     $15ef           ; digit output
CHAN_OPEN_r3            equ     $1601           ; open channel to stream
CALL_JUMP_r3            equ     $162c           ; execute routine at HL
MAKE_ROOM               equ     $1655
SET_MIN                 equ     $16b0
OUT_SP_NO_r3            equ     $192a           ; numeric place output
EACH_STMT_r3            equ     $198b           ; search statements
RECLAIM_2               equ     $19e8           ; reclaim BC bytes at HL
CLASS_01_r3             equ     $1c1f           ; class 01, variable to assign
REPORT_2_r3             equ     $1c2e           ; "2 Variable not found"
FREE_MEM_r3             equ     $1f1a           ; BASIC workspace memory
PR_STRING_r3            equ     $203c           ; print string
LOOK_VARS_r3            equ     $28b2           ; find variable
STK_STO_S_r3            equ     $2ab2           ; store string on calc stack
LET_r3                  equ     $2aff           ; LET
ALPHANUM_r3             equ     $2c88           ; test if char is alphanumeric
STACK_A_r3              equ     $2d28           ; push A to calculator stack
PRINT_FP_r3             equ     $2de3           ; print floating-point number
STACK_NUM_r3            equ     $33b4           ; stack floating-point number
LDIR_RET_r3             equ     $33c3           ; address of LDIR, RET
REPORT_A_r3             equ     $34e7           ; "A Invalid argument"
CHAR_SET_r3             equ     $3d00           ; address of charset
EXPT_1NUM				equ     $1c82           ; single numeric expression to be evaluated
; ***************************************************************************
; * System variables                                                        *
; ***************************************************************************

CACHEBK equ     $5b33
RETVARS equ     $5b58
RAMRST  equ     $5b5d
RAMERR  equ     $5b5e
KSTATE  equ     $5c00
LAST_K  equ     $5c08
REPDEL  equ     $5c09
REPPER  equ     $5c0a
K_DATA  equ     $5c0d
TVDATA  equ     $5c0e
STRMS   equ     $5c10
CHARS   equ     $5c36
RASP    equ     $5c38
PIP     equ     $5c39
ERR_NR  equ     $5c3a
FLAGS   equ     $5c3b
TV_FLAG equ     $5c3c
ERR_SP  equ     $5c3d
MODE    equ     $5c41
NEWPPC  equ     $5c42
PPC     equ     $5c45
SUBPPC  equ     $5c47
BORDCR  equ     $5c48
E_PPC   equ     $5c49
VARS    equ     $5c4b
DEST    equ     $5c4d
CHANS   equ     $5c4f
CURCHL  equ     $5c51
PROG    equ     $5c53
NXTLIN  equ     $5c55
DATADD  equ     $5c57
E_LINE  equ     $5c59
K_CUR   equ     $5c5b
CH_ADD  equ     $5c5d
X_PTR   equ     $5c5f
WORKSP  equ     $5c61
STKBOT  equ     $5c63
STKEND  equ     $5c65
BREG    equ     $5c67
MEM     equ     $5c68
FLAGS2  equ     $5c6a
DF_SZ   equ     $5c6b
OLDPPC  equ     $5c6e
OSPCC   equ     $5c70
FLAGX   equ     $5c71
STRLEN  equ     $5c72
T_ADDR  equ     $5c74
SEED    equ     $5c76
FRAMES  equ     $5c78
UDG     equ     $5c7b
COORDS  equ     $5c7d
GMODE   equ     $5c7f
PR_CC   equ     $5c80
STIMEOUT equ    $5c81
ECHO_E  equ     $5c82
DF_CC   equ     $5c84
DF_CCL  equ     $5c86
S_POSN  equ     $5c88
SPOSNL  equ     $5c8a
SCR_CT  equ     $5c8c
ATTR_P  equ     $5c8d
MASK_P  equ     $5c8e
ATTR_T  equ     $5c8f
MASK_T  equ     $5c90
P_FLAG  equ     $5c91
MEMBOT  equ     $5c92
RAMTOP  equ     $5cb2
P_RAMT  equ     $5cb4

; As offsets from ERR_NR (usually held in IY)
; NOTE: Negative offsets must be used with iy- rather than iy+
;       These are indicated with the naming convention iy_mVARNAME

iy_mKSTATE      equ     ERR_NR-KSTATE
iy_mKSTATE_4    equ     ERR_NR-(KSTATE+4)
iy_mREPPER      equ     ERR_NR-REPPER
iy_mK_DATA      equ     ERR_NR-K_DATA
iy_mPIP         equ     ERR_NR-PIP
iy_mRASP        equ     ERR_NR-RASP

iy_ERR_NR       equ     ERR_NR-ERR_NR

iy_FLAGS        equ     FLAGS-ERR_NR
iy_TVFLAG       equ     TV_FLAG-ERR_NR
iy_MODE         equ     MODE-ERR_NR
iy_PPC          equ     PPC-ERR_NR
iy_SUBPPC       equ     SUBPPC-ERR_NR
iy_BORDCR       equ     BORDCR-ERR_NR
iy_E_PPC        equ     E_PPC-ERR_NR
iy_K_CUR        equ     K_CUR-ERR_NR
iy_X_PTR        equ     X_PTR-ERR_NR
iy_BREG         equ     BREG-ERR_NR
iy_FLAGS2       equ     FLAGS2-ERR_NR
iy_DFSZ         equ     DF_SZ-ERR_NR
iy_OLDPPC       equ     OLDPPC-ERR_NR
iy_OSPCC        equ     OSPCC-ERR_NR
iy_FLAGX        equ     FLAGX-ERR_NR
iy_STRLEN       equ     STRLEN-ERR_NR
iy_FRAMES       equ     FRAMES-ERR_NR
iy_PR_CC        equ     PR_CC-ERR_NR
iy_S_POSN       equ     S_POSN-ERR_NR
iy_SPOSNL       equ     SPOSNL-ERR_NR
iy_SCR_CT       equ     SCR_CT-ERR_NR
iy_PFLAG        equ     P_FLAG-ERR_NR
iy_MEMBOT       equ     MEMBOT-ERR_NR

BLACK_INK			EQU %00000000
BLUE_INK			EQU %00000001
RED_INK				EQU %00000010
MAGENTA_INK			EQU %00000011
GREEN_INK			EQU %00000100
CYAN_INK 			EQU %00000101
YELLOW_INK 			EQU %00000110
WHITE_INK 			EQU %00000111

BLACK_PAPER			EQU BLACK_INK << 3
BLUE_PAPER			EQU BLUE_INK << 3
RED_PAPER			EQU RED_INK << 3
MAGENTA_PAPER		EQU MAGENTA_INK << 3
GREEN_PAPER			EQU GREEN_INK << 3
CYAN_PAPER			EQU CYAN_INK << 3
YELLOW_PAPER		EQU YELLOW_INK << 3
WHITE_PAPER			EQU WHITE_INK << 3

BRIGHT				EQU %01000000
FLASH				EQU %10000000

	MACRO CALL48K address
        RST     $18
        DEFW	address
	ENDM

printRST16
	LD		A,(HL)
	AND 	A
	RET		Z
	RST		0x10
	INC		HL
	JR		printRST16

computeCharAddress
	LD			L,A
	LD			H,0
	.3			ADD HL,HL
	ADD			HL,0x3C00
	RET

prntChar
	CALL		computeCharAddress
	PUSH		DE
	.8			LDWS
	POP			DE
	LD			L,E
	LD			A,D
	.3			RRCA
	AND			%00000011
	OR			%01011000
	LD			H,A
	LD			(HL),C
	INC			E
	RET

prntCharDblHgt
	CALL		computeCharAddress
	PUSH		DE
	EX DE,HL
	DUP 8
		LD		A,(DE)
		LD		(HL),A
		PIXELDN
		LD		(HL),A
		PIXELDN
		INC		DE
	EDUP
	EX DE,HL

	POP			DE
	LD			L,E
	LD			A,D
	.3			RRCA
	AND			%00000011
	OR			%01011000
	LD			H,A
	LD			(HL),C
	ADD			HL,0x0020
	LD			(HL),C
	INC			E
	RET

prntString:
	LD			C,(HL)
	INC			HL
.prntString
	PUSH		HL
	LD			A,(HL)
	CALL		prntChar
	POP			HL
	INC			HL
	DJNZ		.prntString
	RET

prntStringDblHgt:
	LD			C,(HL)
	INC			HL
.prntStringDblHgt
	PUSH		HL
	LD			A,(HL)
	CALL		prntCharDblHgt
	POP			HL
	INC			HL
	DJNZ		.prntStringDblHgt
	RET

	IFNDEF NO_FRAMES
; requires a frames counter intremented every interrupt
;
waitForFrames
		PUSH	BC
		PUSH	HL
		LD		B,A
		LD		HL,frames
.waitNxtInt
		LD		C,(HL)
.waitForFrame
		LD		A,(HL)
		SUB		C
		CP		5
		JR		C,.waitForFrame
		DJNZ	.waitNxtInt
		POP		HL
		POP		BC
		RET
	ENDIF

	IFNDEF NO_FRAMES
prntFadingString
		PUSH	BC
		PUSH	DE
		CALL	prntStringDblHgt
		POP		DE
		POP		BC
		LD		A,3
		CALL	waitForFrames

		LD		A,D
		.3		RRCA
		AND		%00000011
		OR		%01011000
		LD		D,A

		LD		HL,fadeAttrSequence
		LD		C,5
.nxtInSequence
		PUSH	BC
		PUSH	DE
		LD		A,3
		CALL	waitForFrames
.nxtByte
		LD		A,(HL)
		LD		(DE),A
		ADD		DE,0x0020
		LD		(DE),A
		ADD		DE,-0x001F
		DJNZ	.nxtByte
		POP		DE
		POP		BC
		INC		HL
		DEC		C
		JR		NZ,.nxtInSequence
		RET
	
fadeAttrSequence
		DEFB BRIGHT | BLACK_PAPER | WHITE_INK
		DEFB BLACK_PAPER | WHITE_INK
		DEFB BLACK_PAPER | CYAN_INK
		DEFB BLACK_PAPER | BLUE_INK
		DEFB BLACK_PAPER | BLACK_INK
	ENDIF

	MACRO	INC_RAW fn, sb, n
COUNT = n
BNK_OFFSET = 0x00
ADDR_OFFSET = 0x0000
		WHILE COUNT > 0
			MMU 6, sb + BNK_OFFSET, 0xC000
			IF COUNT > 1
				INCBIN fn, ADDR_OFFSET, 0x2000
			ELSE
				INCBIN fn, ADDR_OFFSET
			ENDIF
ADDR_OFFSET=ADDR_OFFSET + 0x2000
BNK_OFFSET=BNK_OFFSET+0x01
COUNT=COUNT-1
		ENDW
	ENDM