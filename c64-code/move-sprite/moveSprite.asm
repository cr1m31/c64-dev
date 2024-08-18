; ----------------------------------------------------------
; Basic header
; ----------------------------------------------------------
    *=$0801  ; org

    .byte $0c,$08,$0a,$00,$9e,$20,$32
    .byte $30,$36,$34,$00,$00,$00,$00,$00 ; 15 bytes

; ----------------------------------------------------------
; Main program starts at $0810
; ----------------------------------------------------------

F_MAIN = $0810 ; $0801 + 15 bytes = $0810 (1 i hex = 1 byte)

; enabling blocks and sprite pointers -------------------------------------
	LDA #$0D	;using block 13 for sprite 1
	STA $07F8 	; sprite 1 official pointer address, last 8 bytes of screen ram 
				; = $0400 + $03F8 = $07F8 
				; = 1024 (screen ram debut) + 1016 (end of screen ram) 
				; = 2040 = $07F8 
				
	; sprite 2 pointer
	LDA #$0E 	; $0E = 14 so block 14 for sprite 2
	STA $07F9	; sprite 2 official pointer address
			
	; enable sprite 1 and 2
    lda #%00000011 	; hex 03 = 0000 0011 in binary = 8 bits = 1 byte
    sta $d015 	; sta stores the value $03 that was loaded into the accumulator
				; at the 16 bit address d015
	
;build all high resolution sprites -----------------------------------------
	LDX #0
BUILD_SPRITES
	LDA DATA_SPRITE_1,X
	STA $0340,X	; warning, block value * 64 = (13 * 64 = 832) = $0340 (hex) 
				; sprite pointer  ($07F8 = sprite 1)
				; the sprite DATA_SPRITE_1 is stored in address $0340
				
	; build sprite 2
	LDA DATA_SPRITE_2,X
	STA $0380,X			
	
	INX
	CPX #63
	BNE BUILD_SPRITES
    
    ; Set sprites position -------------------------------------------------
    LDA #$50          ; X position
    STA $D000
    LDA #$50          ; Y position
    STA $D001
	
	; set sprite 2 position
	LDA #$80		; x position
	STA $D002
	LDA #$50
	STA $D003
	
    LDA #%00000000          ; Ensure MSB is 0 !! a sprite that have a vertical position
    STA $D010		; greater than 255 needs to have the corresponding sprite's bit value set to 1

    ; Set sprites colors ---------------------------------------------------
    LDA #$07          ; Color value (1 = white)
    STA $D027
	
	; set sprite 2 color
	LDA #$0D
	STA $D028
    
	; clear the screen characters
	jsr $E544
	
	jsr move_down
	
    ;RTS               ; Return from subroutine
	
; 	sprite movement ------------------------------
	
 ; Wait Subroutine
  ;; This will make the c64 wait for roughly one frame
wait
  lda #$FF    ; load 255 into A
  cmp $D012   ; look if current rasterline equals 255
  bne wait    ; if no, goto wait
  ;rts         ; if yes, return from subroutine
  
  
move_down
  iny                       ; increment y position  
  sty $D001   ; move sprite 0 to y position
  jsr wait                  ; call wait subroutine
  cpy #$C8                  ; are we at y=200?
  bne move_down             ; if no, go to move_down


; Sprite DATA_SPRITE1 ------------------------------------
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
    .byte $08,$0D,$80,$06,$0E,$10,$03,$1F
	.byte $FE,$01,$FF,$EC,$02,$FF,$F8,$00
	.byte $FF,$F0,$05,$3F,$FC,$0F,$3F,$FC
	.byte $07,$3F,$30,$07,$3E,$36,$16,$38
	.byte $11,$0E,$7A,$70,$36,$FC,$F6,$9F
	.byte $FE,$E0,$D7,$FE,$FB,$0B,$FF,$30
	.byte $17,$FF,$58,$25,$FE,$22,$00,$FC
	.byte $01,$02,$18,$21,$25,$00,$40
