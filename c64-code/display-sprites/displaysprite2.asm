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

	LDA #$01	;using block n for sprite n
	STA $07F8 	; last 8 bytes of screen ram 
				; = $0400 + $03F8 = $07F8 
				; = 1024 (screen ram debut) + 1016 (end of screen ram) 
				; = 2040 = $07F8 

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

; Sprite data
DATA
    .byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$07,$e0,$00,$0f,$e0,$00,$33
	.byte $e0,$80,$23,$e2,$80,$3b,$fa,$80
	.byte $03,$fa,$80,$03,$fa,$80,$03,$fa
	.byte $00,$03,$f8,$00,$01,$f8,$00,$00
	.byte $f8,$00,$00,$f0,$00,$00,$70,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$07
