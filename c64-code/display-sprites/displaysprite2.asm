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

	LDA #$0D	;using block n for sprite n
	STA $07F8 	; sprite pointer last 8 bytes of screen ram 
				; = $0400 + $03F8 = $07F8 
				; = 1024 (screen ram debut) + 1016 (end of screen ram) 
				; = 2040 = $07F8 
				
	; sprite 2 pointer
	LDA #$0E
	STA $07F9
			
	; enable sprite 1 and 2
    lda #$03 ; hex 03 = 0011 in binary
    sta $d015
	
   ;build the sprite 1 ---------------------
	LDX #0
BUILD_SPRITE_1	
	LDA DATA_SPRITE_1,X
	STA $0340,X	; warning, need to give it the same address obtained by 
				; the value in the corresponding 
				; sprite pointer  ($07F8 = sprite 1)
				; so the value is $0D = 13 (13 * 64 = 832) = ($0D * $40)
				; and 832 in decimal = $0340 in hex so
				; the sprite DATA_SPRITE_1 is stored in address $0340
	INX
	CPX #63
	BNE BUILD_SPRITE_1
	
	;build the sprite 2 --------------------
	LDX #0
BUILD_SPRITE_2	
	LDA DATA_SPRITE_2,X
	STA $0380,X	; warning, need to give it the same address obtained by 
				; the value in the corresponding 
				; sprite pointer  ($07F8 = sprite 1)
				; so the value is $0D = 13 (13 * 64 = 832) = ($0D * $40)
				; and 832 in decimal = $0340 in hex so
				; the sprite DATA_SPRITE_1 is stored in address $0340
	INX
	CPX #63
	BNE BUILD_SPRITE_2
    
    ; Set sprite 1 position
    LDA #$50          ; X position
    STA $D000
    LDA #$50          ; Y position
    STA $D001
	
	; set sprite 2 position
	LDA #$80
	STA $D002
	LDA #$050
	STA $D003
	
	
    LDA #$00          ; Ensure MSB is 0
    STA $D010

    ; Set sprite 1 color
    LDA #$07          ; Color value (1 = white)
    STA $D027
	
	; set sprite 2 color
	LDA #$01
	STA $D028
    
    RTS               ; Return from subroutine

; Sprite DATA_SPRITE1
DATA_SPRITE_1
    .byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$07,$e0,$00,$0f,$e0,$00,$33
	.byte $e0,$80,$23,$e2,$80,$3b,$fa,$80
	.byte $03,$fa,$80,$03,$fa,$80,$03,$fa
	.byte $00,$03,$f8,$00,$01,$f8,$00,$00
	.byte $f8,$00,$00,$f0,$00,$00,$70,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$07
	
DATA_SPRITE_2
    .byte $10,$00,$00,$18,$00,$00,$0C,$06
	.byte $78,$07,$07,$84,$01,$FC,$04,$04
	.byte $DC,$00,$06,$F8,$02,$06,$A8,$01
	.byte $0E,$E0,$01,$18,$E0,$00,$18,$FF
	.byte $F0,$0F,$70,$18,$0C,$30,$08,$02
	.byte $78,$0B,$01,$56,$B4,$00,$D8,$04
	.byte $00,$CC,$0C,$00,$07,$D8,$00,$00
	.byte $70,$00,$00,$00,$00,$00,$00