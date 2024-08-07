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

	; Sprite 0
	lda #$03         ; individual color 
	sta $D027        ; Set sprite 0 color in its color register

	lda #%00000001 ; select sprites 0 
	sta $D015   ; Activate sprites register

	; Sprite 0
	lda #$90   
	sta $D000 ; Sprite 0 Horizontal Position X coordinate
	lda #$8F
	sta $D001 ; Sprite 0 Vertical Position Y coordinate
	
	lda #%00000001  ; Only the bits for sprite 0 is set
	sta $D017 ; Sprite Vertical Expansion Register

	lda #%00000001  ; Only the bits for sprite 0 is set 
	sta $D01D ; Sprite Horizontal Expansion Register

	; Set sprite data pointers
	lda #$80
	sta $07F8   ; Set the location to find SPRITE0 Shape Data Pointers

	; Load sprite data into memory
	ldx #$00   ; SET X=0
	jsr SPR0LOADLOOP ; Load SPRITE0 into memory

SPR0LOADLOOP
	lda walk_sprite_anim01,x
	sta $2000,x ; Sprite 0 data start = $2000
	inx
	cpx #$40
	bne SPR0LOADLOOP
	rts

stand_sprite_anim
	.byte $01,$80,$00,$03,$c0,$00,$03,$e0
	.byte $00,$03,$c0,$00,$01,$00,$00,$03
	.byte $80,$00,$03,$c0,$00,$03,$e0,$00
	.byte $03,$e0,$00,$03,$e0,$00,$03,$e0
	.byte $00,$03,$e0,$00,$03,$c0,$00,$01
	.byte $80,$00,$01,$80,$00,$01,$80,$00
	.byte $01,$80,$00,$01,$80,$00,$01,$80
	.byte $00,$01,$80,$00,$01,$e0,$00,$0d

walk_sprite_anim01
	.byte $01,$80,$00,$03,$c0,$00,$03,$e0
	.byte $00,$03,$c0,$00,$01,$00,$00,$03
	.byte $80,$00,$07,$c0,$00,$0f,$e0,$00
	.byte $0b,$e0,$00,$0b,$e0,$00,$0b,$e0
	.byte $00,$0b,$e0,$00,$03,$c0,$00,$01
	.byte $80,$00,$01,$c0,$00,$03,$c0,$00
	.byte $03,$60,$00,$06,$34,$00,$06,$38
	.byte $00,$0c,$10,$00,$0f,$80,$00,$0d