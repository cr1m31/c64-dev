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

    ; Set initial sprite data pointer
    lda #<walk_sprite_anim01  ; Low byte of address for walk_sprite_anim01
    sta $FB          ; Store in zero-page location
    lda #>walk_sprite_anim01  ; High byte of address for walk_sprite_anim01
    sta $FC          ; Store in zero-page location

    ; Load initial sprite data
    ldx #$00         ; Set X=0
    jsr SPR0LOADLOOP ; Load sprite data into sprite memory

    ; Main loop
MAIN_LOOP
    ; Switch to walk_sprite_anim01
    lda #<walk_sprite_anim01  ; Low byte of address
    sta $FB          ; Set pointer to walk_sprite_anim01 low byte
    lda #>walk_sprite_anim01  ; High byte of address
    sta $FC          ; Set pointer to walk_sprite_anim01 high byte
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

    ; Switch to stand_sprite_anim
    lda #<stand_sprite_anim  ; Low byte of address
    sta $FB          ; Set pointer to stand_sprite_anim low byte
    lda #>stand_sprite_anim  ; High byte of address
    sta $FC          ; Set pointer to stand_sprite_anim high byte
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
    ; Load sprite data into sprite memory
    ldy #$00         ; Start from the beginning of the sprite data
    lda $FB          ; Load the low byte of the pointer from zero-page
    ldx $FC          ; Load the high byte of the pointer from zero-page
    lda ($FB),y      ; Load sprite data from the address pointed to by $FB
    sta $2000,y      ; Store it in sprite memory (increment by Y each loop)
    iny              ; Increment Y (next byte of sprite data)
    cpy #$40         ; Check if all 64 bytes are processed (64 bytes per sprite)
    bne SPR0LOADLOOP ; Continue if not done
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
