; ----------------------------------------------------------
; Basic header
; ----------------------------------------------------------
	*=$0801 ; org

	.byte $0c,$08,$0a,$00,$9e,$20,$32
	.byte $30,$36,$34,$00,$00,$00,$00,$00


F_MAIN ; $810
	
    ; set sprite pointer index
    ; this, multiplied by $40, is the address
    ; in this case, the address is $2000
    ; $80 * $40 = $2000
    lda #$80
    sta $07f8

    ; enable sprite 0
    lda #$01
    sta $d015

    ; set x and y position
    lda #$80
    sta $d000
    sta $d001

loop
    jmp loop

    .byte $0B, $08, $06, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $E0, $00, $0F
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	
	