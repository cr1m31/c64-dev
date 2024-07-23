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
	
	lda #$0C ; using block 12 for sprite 1
	sta $07F9

; enable sprite 0
    lda #$01
    sta $d015
	
; enable sprite 1 
	lda #$02
	sta $d015
    
   ;build the sprite
	LDX #0
BUILD_JAR	
	LDA DATA_jar,X
	STA $0340,X
	INX
	CPX #63
	BNE BUILD_JAR
	
BUILD_WATER
	lda DATA_water,X
	sta $0350,X
	INX
	cpx #064
	BNE BUILD_WATER
    
    ; Set sprite position
    LDA #$50          ; X position
    STA $D000
    LDA #$50          ; Y position
    STA $D000
    LDA #$00          ; Ensure MSB is 0
    STA $D001
	
	; set second sprite position
	lda #$060
	sta $D002
	lda #$060
	sta $D003
	
	; ensure MSB is 0
	lda #$00
	sta $D010
	
    ; Set sprite color
    LDA #$07          ; Color value (1 = white)
    STA $D027
	
	; set second sprite color
	lda #$08
	sta $D028
    
    RTS               ; Return from subroutine

	; DATA label included from the asm file below that contains the real data (include compatible with tmpx aka turbo macro pro
	.include "sprite-data.asm"
	