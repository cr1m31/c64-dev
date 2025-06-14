; ANIM SPRITES -----------------------------------

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

    lda #%00000001   ; select sprite 0 
    sta $D015        ; Activate sprites register

    ; Sprite 0
    lda #$90   
    sta $D000        ; Sprite 0 Horizontal Position X coordinate
    lda #$8F
    sta $D001        ; Sprite 0 Vertical Position Y coordinate
    
    lda #%00000001   ; Only the bit for sprite 0 is set
    sta $D017        ; Sprite Vertical Expansion Register

    lda #%00000001   ; Only the bit for sprite 0 is set 
    sta $D01D        ; Sprite Horizontal Expansion Register

    ; Set sprite data pointers
    lda #$80
    sta $07F8        ; Set the location to find SPRITE0 Shape Data Pointers

    ; Load initial sprite data into memory
    ldx #$00         ; SET X=0
    jsr SPR0LOADLOOP ; Load SPRITE0 into memory

; Load Sprite 0 data into memory ------------------------------

SPR0LOADLOOP
    ; Load the first sprite (Sprite 0) into memory
    ldx #$00         ; Reset X register for the first sprite
loop1
    lda stand_sprite_anim,x
    sta $2000,x      ; Load data into Sprite 0 memory ($2000)
    inx
    cpx #$40
    bne loop1

    jsr STARTCOUNTER

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

; COUNTER ----------------------------------------
STARTCOUNTER
    SEI             ; Disable interrupts
    LDA #$35        ; Set interrupt to start on line 245
    STA $D012       ; Write to VIC-II raster line register

    LDA #$00        ; Initialize frame counter
    STA framecounter

    LDA #$00        ; Initialize color index
    STA colorIndex

    LDA #$40        ; Initialize delay (number of frames)
    STA colorDelay

    CLI             ; Enable interrupts
MAINLOOP
    JSR WAITFRAME   ; Wait for the next frame
    JSR HANDLEFRAME ; Handle frame-specific logic
    JMP MAINLOOP    ; Loop forever

WAITFRAME
    LDA #$F8        ; Wait until raster line $F8
WAITLINE
    CMP $D012
    BNE WAITLINE
    RTS

HANDLEFRAME
    DEC framecounter
    BEQ RESET_COUNTER
    RTS

RESET_COUNTER
    LDA colorDelay
    STA framecounter  ; Reset frame counter
    JSR CHANGEBORDERCOLOR  ; Perform the action
    JSR SWITCHSPRITEDATA
    RTS

CHANGEBORDERCOLOR
    LDX colorIndex  ; Load the current colorIndex into the X register
    INX             ; Increment the X register
    STX colorIndex  ; Store the incremented value back into colorIndex
    TXA             ; Transfer the X register into the accumulator
    CMP #$10        ; Compare the accumulator with 16
    BNE SKIP_COLOR_RESET
    LDX #$00        ; Reset X register to 0 if it reached 16
    STX colorIndex  ; Store 0 back into colorIndex
SKIP_COLOR_RESET
    LDA colorIndex  ; Load the colorIndex into the accumulator
    STA $D020       ; Change the border color
    RTS             ; Return from the subroutine


SWITCHSPRITEDATA
    ; Load different sprite data based on spriteIndex
    lda spriteIndex
    beq LOAD_STAND_SPRITE

    ldx #$00
    jmp LOAD_WALK_SPRITE

LOAD_STAND_SPRITE
    ldx #$00
store_stand_sprite
    lda stand_sprite_anim,x
    sta $2000,x
    inx
    cpx #$40
    bne store_stand_sprite
    lda #$01      ; Set spriteIndex to 1 to load walk_sprite_anim01 next
    sta spriteIndex
    rts

LOAD_WALK_SPRITE
store_walk_sprite
    lda walk_sprite_anim01,x
    sta $2000,x
    inx
    cpx #$40
    bne store_walk_sprite
    lda #$00      ; Set spriteIndex to 0 to load stand_sprite_anim next
    sta spriteIndex
    rts

framecounter
    .byte $00

colorIndex
    .byte $00

colorDelay
    .byte $40

spriteIndex
    .byte $00      ; Variable to keep track of which sprite to load next
