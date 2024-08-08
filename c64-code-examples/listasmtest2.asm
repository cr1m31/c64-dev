; ----------------------------------------------------------
; Basic header
; ----------------------------------------------------------
	*=$0801 ; org

	.byte $0c,$08,$0a,$00,$9e,$20,$32
	.byte $30,$36,$34,$00,$00,$00,$00,$00


F_MAIN ; $810
	lda #1
	sta $0400
	
	jmp DisplayChar

DisplayChar
	ldx #0
	sta $0600,x
	inx
	cpx #$ff
	bne SET_BORDER_COLOR
	
SET_BORDER_COLOR
	lda #$04
	sta $d020
	
Loop_
	jmp Loop_