; routines to clear and print a characters to the zxn tilemap, taking care of conversion of HW addresses to ZXN tilemap addresses
;
IO_TileMapContr				equ 0x6B  		; Tile Map Control
IO_TileMapAttr				equ 0x6C  		; Default Tilemap Attribute

IO_TileMapBaseAdrr			equ 0x6E  		; Tilemap Base Address
IO_TileMapDefBaseAddr		equ 0x6F  		; Tile Definitions Base Address
IO_TileMapPaletteContr		equ 0x43  		; Palette Control

IO_TileMapClipWindow		equ 0x1B 		; Clip Window Tilemap
IO_TileMapTransparency		equ 0x4C 		; Transparency index for the tilemap
IO_ULAControl				equ 0x68		; ULA Control

IO_TileMapOffSetXMSB		equ 0x2F  		; Tilemap Offset X MSB		
IO_TileMapOffSetXLSB		equ 0x30  		; Tilemap Offset X LSB		         		         
IO_TileMapOffsetY			equ 0x31  		; Tilemap Offset Y

tileMapInitialise
	; GET MSB for port write of tileMapDefinitions base address

	;********
	
	; Note! 
	; As the documentation says, bits 7,6 are ignored, first 5 bits
	; are writtedn to the port, so no processing has to be done.
	; here I load the values from the defined variables, and data file for tile defs

	;********
;*___________________________________________________________________________________________________________________________________
	CALL	clearAllTileMap
	NEXTREG IO_TileMapBaseAdrr, high TILEMAP_START & 0x3F
	NEXTREG IO_TileMapDefBaseAddr, high TILEMAP_DEFS_START & 0x3F
;*___________________________________________________________________________________________________________________________________
	; TILE MAP CONTROL 
	; bit 7    = 1 to enable the tilemap
  	; bit 6    = 0 for 40x32, 1 for 80x32
  	; bit 5    = 1 to eliminate the attribute entry in the tilemap
  	; bit 4    = palette select
  	; bits 3-2 = Reserved set to 0
  	; bit 1    = 1 to activate 512 tile mode
  	; bit 0    = 1 to force tilemap on top of ULA
	IFNDEF	DISABLE_TILEMAP
		NEXTREG IO_TileMapContr, %10000011			; tile map with  attribute byte eliminated is selected, (bit 5 is 1)
	ENDIF
	;nextreg IO_TileMapContr, %00000000			; tile map with  attribute byte eliminated is selected, (bit 5 is 1)
;*___________________________________________________________________________________________________________________________________
	; only used if no tile attrs in the tile map
	; (R/W) 0x6C (108) => Default Tilemap Attribute			
	; bits 7-4 = Palette Offset
	; bit 3    = X mirror
	; bit 2    = Y mirror
	; bit 1    = Rotate
	; bit 0    = ULA over tilemap
	; bit 8 of the tile number if 512 tile mode is enabled)

	NEXTREG IO_TileMapAttr,  %00000000
;*___________________________________________________________________________________________________________________________________
	; (R/W) 0x4C (76) => Transparency index for the tilemap
	; bits 7-4 = Reserved, must be 0
	; bits 3-0 = Set the index value (0xF after reset)

	NEXTREG IO_TileMapTransparency, %00000000 ; bits 0-3 (0-15)
;*___________________________________________________________________________________________________________________________________
	;(R/W) 0x43 (67) => Palette Control
	; bit 7 = '1' to disable palette write auto-increment.
	; bits 6-4 = Select palette for reading or writing:
     	; 000 = ULA first palette
     	; 100 = ULA second palette
	; 001 = Layer 2 first palette
	; 101 = Layer 2 second palette
	; 010 = Sprites first palette 
	; 110 = Sprites second palette
	; 011 = Tilemap first palette
	; 111 = Tilemap second palette
    	; bit 3 = Select Sprites palette (0 = first palette, 1 = second palette)
  	; bit 2 = Select Layer 2 palette (0 = first palette, 1 = second palette)
 	; bit 1 = Select ULA palette (0 = first palette, 1 = second palette)
  	; bit 0 = Enabe ULANext mode if 1. (0 after a reset)

	NEXTREG IO_TileMapPaletteContr, %000110000
;*___________________________________________________________________________________________________________________________________

	; (R/W) 0x68 (104) => ULA Control
 	 ; bit 7 = 1 to disable ULA output
  	 ; bit 6 = 0 to select the ULA colour for blending in SLU modes 6 & 7
      	 ;       = 1 to select the ULA/tilemap mix for blending in SLU modes 6 & 7
  	 ; bits 5-1 = Reserved must be 0
 	 ; bit 0 = 1 to enable stencil mode when both the ULA and tilemap are enabled 
 	 ; (if either are transparent the result is transparent otherwise the result is a logical AND of both colours)

	NEXTREG IO_ULAControl, %10000000
;*___________________________________________________________________________________________________________________________________

	IFDEF	LEFTX_MARGIN
		NEXTREG IO_TileMapClipWindow, LEFTX_MARGIN
	ENDIF
	
	IFDEF	RIGHTX_MARGIN
		NEXTREG IO_TileMapClipWindow, RIGHTX_MARGIN
	ENDIF
	
	IFDEF	TOPY_MARGIN
		NEXTREG IO_TileMapClipWindow, TOPY_MARGIN
	ELSE
		NEXTREG IO_TileMapClipWindow, 0x00
	ENDIF
	
	IFDEF	BOTTOMY_MARGIN
		NEXTREG IO_TileMapClipWindow, BOTTOMY_MARGIN
	ELSE
		NEXTREG IO_TileMapClipWindow, 0xFF
	ENDIF

	NEXTREG IO_TileMapOffSetXMSB, 0
	NEXTREG IO_TileMapOffSetXLSB, 0
	NEXTREG IO_TileMapOffsetY,    0
	CALL	setUpPalette
	RET

setUpPalette
; ----------------------------------------
; Set Tilemap Palette 0 to ZX default colours
; ZX Spectrum Next
; ----------------------------------------

NEXTREG     EQU $243B   ; NextReg select port
NEXTREGDAT  EQU $253B   ; NextReg data port


PALETTE_IDX EQU 0x40    ; Palette index register
PALETTE_VAL EQU 0x41    ; Palette value register
PALETTE_SEL	EQU	0x43	; Palette Select register
PALETTE_SET	EQU	0x44	; Palette set register

        ; Select palette 0 (tilemap default)
		NEXTREG		PALETTE_SEL, %00110000

        ; Write 16 colours
        ld  hl,ZXPalette
        ld  b,0x10 * 2
LoadPalette:
		LD			A,0x10 * 2
		SUB			B
		NEXTREG		PALETTE_IDX, A

        ; write low byte
        ld  A,(hl)
        INC	HL
		NEXTREG	PALETTE_SET, A

        ; write high byte
        ld  A,(HL)
        INC	HL
		NEXTREG	PALETTE_SET, A

        djnz LoadPalette
        ret

; ----------------------------------------
; ZX Spectrum default palette (9-bit RGB)
; ----------------------------------------
ZXPalette:
	; swapped black / red version
	DEFB 0x00, 0x00	; Black
	DEFB 0xC0, 0x00	; Red
	DEFB 0x03, 0x00 ; Blue
	DEFB 0x03, 0x01 ; Bright Blue
	DEFB 0x00, 0x00	; Black
	DEFB 0xE0, 0x00 ; Bright Red
	DEFB 0xC3, 0x00 ; Magenta
	DEFB 0xE3, 0x01 ; Bright Magenta
	DEFB 0x18, 0x00 ; Green
	DEFB 0x1C, 0x00 ; Bright Green
	DEFB 0x1B, 0x00 ; Cyan
	DEFB 0x1F, 0x01 ; Bright Cyan
	DEFB 0xD8, 0x00 ; Yellow
	DEFB 0xFC, 0x00 ; Bright Yellow
	DEFB 0xDB, 0x00 ; White
	DEFB 0xFF, 0x01 ; Bright White

	; default palette
	DEFB 0x00, 0x00	; Black
	DEFB 0x00, 0x00	; Black
	DEFB 0x03, 0x00 ; Blue
	DEFB 0x03, 0x01 ; Bright Blue
	DEFB 0xC0, 0x00	; Red
	DEFB 0xE0, 0x00 ; Bright Red
	DEFB 0xC3, 0x00 ; Magenta
	DEFB 0xE3, 0x01 ; Bright Magenta
	DEFB 0x18, 0x00 ; Green
	DEFB 0x1C, 0x00 ; Bright Green
	DEFB 0x1B, 0x00 ; Cyan
	DEFB 0x1F, 0x01 ; Bright Cyan
	DEFB 0xD8, 0x00 ; Yellow
	DEFB 0xFC, 0x00 ; Bright Yellow
	DEFB 0xDB, 0x00 ; White
	DEFB 0xFF, 0x01 ; Bright White

clearAllTileMap
	LD		HL,TILEMAP_START
	LD		BC,40*32
.clrNxtTile
	LD		(HL),low CARD_BLANK_TILE
	INC 	HL
	LD		(HL),high CARD_BLANK_TILE
	INC 	HL
	DEC		BC
	LD		A,B
	OR		C
	JR		NZ,.clrNxtTile
	RET
