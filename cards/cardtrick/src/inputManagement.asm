	MACRO SCAN_FOR_KEY port, bitToCheck, settingAddress, bitToSet
			LD HL,settingAddress
			LD BC, port << 8 | 0xFE
			IN A, (C)
			BIT bitToCheck, A
			LD A,(HL)
			RES bitToSet,(HL) ; clear pressed state flag
			JR Z,1F
			BIT bitToSet,A		; was it previously pressed?
			JR Z,2F
			INC HL			; yes, move to released state flag
1:
			SET bitToSet,(HL) ; set state flag
2:
		ENDM


KEY_1			EQU	0x00
KEY_2			EQU	0x01
KEY_3			EQU	0x02
KEY_SPACE		EQU 0x03
KEY_ENTER		EQU 0x04
KEY_Y			EQU 0x05
KEY_N			EQU	0x06

scanKeyboard
	SCAN_FOR_KEY 0xF7, 0x00, keyPressedStatus, KEY_1		; "1" Key
	SCAN_FOR_KEY 0xF7, 0x01, keyPressedStatus, KEY_2		; "2" Key
	SCAN_FOR_KEY 0xF7, 0x02, keyPressedStatus, KEY_3		; "3" Key
	SCAN_FOR_KEY 0x7F, 0x00, keyPressedStatus, KEY_SPACE	; "Space" Key
	SCAN_FOR_KEY 0xBF, 0x00, keyPressedStatus, KEY_ENTER	; "Enter" Key
	SCAN_FOR_KEY 0xDF, 0x04, keyPressedStatus, KEY_Y		; "Y" Key
	SCAN_FOR_KEY 0x7F, 0x03, keyPressedStatus, KEY_N		; "N" Key
	RET

keyPressedStatus
	DEFB	0x00

keyReleasedStatus
	DEFB	0x00
