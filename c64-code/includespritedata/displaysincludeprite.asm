; ----------------------------------------------------------
; Basic header
; ----------------------------------------------------------
    *=$0801  ; org

    .byte $0c,$08,$0a,$00,$9e,$20,$32
    .byte $30,$36,$34,$00,$00,$00,$00,$00

; ----------------------------------------------------------
; Main program starts at $0810
; ----------------------------------------------------------

F_MAIN = $0810

	LDA #$0D	;using block 13 for sprite0
	STA $07F8

; enable sprite 0
    lda #$01
    sta $d015
    
   ;build the sprite
	LDX #0
BUILD	
	LDA DATA,X
	STA $0340,X
	INX
	CPX #63
	BNE BUILD
    
    ; Set sprite position
    LDA #$50          ; X position
    STA $D000
    LDA #$50          ; Y position
    STA $D001
    LDA #$00          ; Ensure MSB is 0
    STA $D010

    ; Set sprite color
    LDA #$07          ; Color value (1 = white)
    STA $D027
    
    RTS               ; Return from subroutine

	; DATA label included from the asm file below that contains the real data (include compatible with tmpx aka turbo macro pro
	.include "includespritedata.asm"
	