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

	; Set up initial sprite configuration
	lda #$03         ; Set sprite 0 color
	sta $D027        ; Sprite 0 color register

	lda #%00000001   ; Select sprite 0
	sta $D015        ; Activate sprites register

	; Sprite 0 initial position
	lda #$90
	sta $D000        ; Sprite 0 Horizontal Position X coordinate
	lda #$8F
	sta $D001        ; Sprite 0 Vertical Position Y coordinate
	
	lda #%00000001   ; Enable sprite vertical expansion
	sta $D017        ; Sprite Vertical Expansion Register

	lda #%00000001   ; Enable sprite horizontal expansion
	sta $D01D        ; Sprite Horizontal Expansion Register

	; Set sprite data pointers
	lda #$80
	sta $07F8        ; Set sprite data address

	; Load sprite data into memory
	ldx #$00         ; Set X=0
	jsr SPR0LOADLOOP ; Load initial sprite data

	; Main loop
MAIN_LOOP
	; Set sprite data to walk_sprite_anim01
	lda #$80
	sta $07F8        ; Set pointer to walk_sprite_anim01
	ldx #$00         ; Set X=0
	jsr SPR0LOADLOOP ; Load walk_sprite_anim01 data into sprite memory

	; Delay loop
	ldx #$FF
	ldy #$FF
DELAY
	; Simple delay
	dey
	bne DELAY
	dex
	bne DELAY

	; Set sprite data to stand_sprite_anim
	lda #$80
	sta $07F8        ; Set pointer to stand_sprite_anim
	ldx #$00         ; Set X=0
	jsr SPR0LOADLOOP ; Load stand_sprite_anim data into sprite memory

	; Delay loop
	ldx #$FF
	ldy #$FF
DELAY2
	; Simple delay
	dey
	bne DELAY2
	dex
	bne DELAY2

	; Repeat animation loop
	jmp MAIN_LOOP

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
