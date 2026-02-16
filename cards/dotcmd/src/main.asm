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
	jp      endOut			
	
	DEFINE		NO_FRAMES
	include 	"./utils/src/utils.asm"	
	DEFINE		ARG_PARAMS_DEHL
	include 	"./utils/src/arguments.asm"											

commandLinePresent: 
	PUSH    AF, BC, DE, HL, IX				; save std regs 
	;BREAK
	;ld      de,varname
	;LD		(CH_ADD),HL
    ;call    get_sizedarg     
	;ld      (var_len),bc 
       
	;CALL48K	0x24FB       
	;CALL48K	0x2DD5    
	BREAK
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
	POP     IX, HL, DE, BC, AF				; restore std regs    
endOut: 
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
readNxtDigit
	LD		A,(HL)
	INC		HL
	AND		A
	RET		Z
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
	JR		readNxtDigit
	
		ld      de,filename
        call    get_sizedarg            ; get first argument to filename
        JP      nc,show_usage           ; if none, just go to show usage
        ld      (command_len),bc        ; store command length
        ld      de,varname
        call    get_sizedarg            ; get second argument to varname
        JP      nc,show_usage           ; if none, just go to show usage
        ld      (var_len),bc            ; store variable name length
        ld      de,varname
        ex      de,hl
        add     hl,bc
        dec     hl
        ex      de,hl
        ld      a,(de)
        cp      '$'                     ; last char must be '$'
        JP      nz,show_usage
        ld      de,0                    ; further args to ROM
        call    get_sizedarg            ; check if any further args
        JP		C,show_usage
		jr      nc,string_start         ; okay if not

string_start:
        ld      bc,(var_len)
        inc     bc
        CALL48K EXPT_1NUM            ; reserve space for variable name
        dec     bc
        ld      hl,varname
        push    de
        ldir                            ; copy name to workspace
        ld      a,','                   ; append a delimiter
        ld      (de),a
        ld      hl,(CH_ADD)
        ex      (sp),hl
        ld      (CH_ADD),hl             ; set var name as interpretation pointer
        CALL48K LOOK_VARS_r3            ; search for the variable
        pop     de
        ld      (CH_ADD),de             ; restore interpretation pointer
        jr      nc,var_found
        CALL48K REPORT_2_r3             ; 2 Variable not found
var_found:
        ld      a,b
        and     %11100000
        cp      %01000000               ; must be a simple string
        jr      z,string_found
        CALL48K REPORT_A_r3             ; A Invalid argument
string_found:
        inc     hl
        ld      c,(hl)
        inc     hl
        ld      b,(hl)                  ; BC=string length
        inc     hl                      ; HL=string address
trimstring:
        ld      a,b
        or      c
        jr      z,gotstring
        ld      a,(hl)
        cp      ' '
        jr      nz,gotstring            ; on when non-space encountered
        inc     hl                      ; trim the space
        dec     bc
        jr      trimstring
gotstring:
        ld      (string_len),bc         ; save string length
        inc     bc                      ; increment length for terminator
        ld      (string_addr),de        ; save start of string in workspace
        ldir                            ; copy string+1 byte
        RET


; ***************************************************************************
; * Custom error generation                                                 *
; ***************************************************************************

err_custom:
        xor     a                       ; A=0, custom error
        scf                             ; Fc=1, error condition
        ; fall through to exit_error

; ***************************************************************************
; * Close file and exit with any error condition                            *
; ***************************************************************************

exit_error:
        ret

;------------------------------------------------------------------------------
; Data 

command_len
	DEFW	0x00
var_len
	DEFW	0x00
string_len
	DEFW	0x00
string_addr
	DEFW	0x0000
varname
	DEFS	0x20, 0x00
filename
	DEFS	0x20, 0x00
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