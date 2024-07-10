; ----------------------------------------------------------
; Basic header
; ----------------------------------------------------------
	*=$0801 ; org

	.byte $0c,$08,$0a,$00,$9e,$20,$32
	.byte $30,$36,$34,$00,$00,$00,$00,$00

; ----------------------------------------------------------
; Program
; ----------------------------------------------------------

main ; $0810
	ldx #0
	ldy #0
	jmp set_border_color
	
set_border_color
	lda #$04
	sta $d020
	jmp display_char
	
set_lowercase
	lda #$17
	sta $d018
	rts
	
display_char
	tya
	sta $0400, x
	jmp display_char_2
	
display_char_2
	tya
	sta $0500, x
	jmp increase_x
	
increase_x
	inx
	cpx #$ff
	bne increase_y
	
increase_y
	iny
	cpy #$ff
	bne display_char
	
loop_
	jmp loop_
	