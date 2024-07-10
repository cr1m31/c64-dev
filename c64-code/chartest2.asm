; ----------------------------------------------------------
; Basic header
; ----------------------------------------------------------
	*=$0801 ; org

	.byte $0c,$08,$0a,$00,$9e,$20,$32
	.byte $30,$36,$34,$00,$00,$00,$00,$00


F_MAIN ; $810
	lda #1
	sta $0400
	
	jmp F_LOOP_CHARS


F_LOOP_CHARS
	ldx #0
	sta $0600,x
	inx
	cpx #$ff
	bne F_DISPLAY_SPRITE
	
	
F_DISPLAY_SPRITE
	LDA #44
	STA $D00A       ; X position sprite #5 set on 44

	LDA $D010       ; load X-MSB
	ORA #%00100000  ; set extra bit for sprite #5
	STA $D010       ; write X-MSB register
	jsr SET_BORDER_COLOR
	
SET_BORDER_COLOR
	lda #$04
	sta $d020
	jmp SET_BORDER_COLOR
