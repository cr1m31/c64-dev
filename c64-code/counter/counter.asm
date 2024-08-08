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

        SEI             ; Disable interrupts
        LDA #$35        ; Set interrupt to start on line 245
        STA $D012       ; Write to VIC-II raster line register

        LDA #$00        ; Initialize frame counter
        STA framecounter

        LDX #$00        ; Initialize color index
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
        JSR DOSOMETHING  ; Perform the action
        RTS

DOSOMETHING
        LDA colorIndex  ; Change border color
        STA $D020
        INX
        CPX #16
        BNE SKIP_COLOR
        LDX #$00
SKIP_COLOR
        STX colorIndex
        RTS

framecounter
        .byte $00

colorIndex
        .byte $00

colorDelay
        .byte $40
