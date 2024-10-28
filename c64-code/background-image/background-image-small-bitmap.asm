; ----------------------------------------------------------
; Basic header
; ----------------------------------------------------------
*=$0801  ; org

.byte $0c,$08,$0a,$00,$9e,$20,$32
.byte $30,$36,$34,$00,$00,$00,$00,$00 ; 15 bytes

; ----------------------------------------------------------
; Main program starts at $0810
; ----------------------------------------------------------

F_MAIN = $0810

    LDX #$00
    LDY #$00

    ; Set up VIC-II for high-resolution bitmap mode
    LDA #$1B         ; Set bitmap mode and high-resolution (Bit 5 set)
    STA $D011        ; Enable bitmap mode
    LDA #$18         ; Screen at $0400, bitmap at $2000
    STA $D018

    ; Copy bitmap data
    LDA #<Bitmap_data
    LDY #>Bitmap_data
    JSR CopyBitmapData

    ; Set colors for the bitmap
    LDX #$00
SetColors
    LDA Color_data, X ; Load color data
    STA $D800, X       ; Set color for the first pixel
    INX
    CPX #40            ; Assuming 40 bytes for width (320 pixels)
    BNE SetColors

MainLoop
    JMP MainLoop       ; Infinite loop

CopyBitmapData
    LDX #$00
CopyLoop
    LDA Bitmap_data, X
    STA $2000, X       ; Store bitmap data to the bitmap area
    INX
    CPX #<Bitmap_data_end - Bitmap_data  ; Adjust for the size of your bitmap data
    BNE CopyLoop
    RTS

; Bitmap data for the checkerboard pattern
Bitmap_data
    .byte $AA, $55, $AA, $55, $AA, $55, $AA, $55   ; 8x8 checkerboard row
    .byte $55, $AA, $55, $AA, $55, $AA, $55, $AA   ; Repeat for 8 rows to form an 8x8 checkerboard
    .byte $AA, $55, $AA, $55, $AA, $55, $AA, $55
    .byte $55, $AA, $55, $AA, $55, $AA, $55, $AA
    .byte $AA, $55, $AA, $55, $AA, $55, $AA, $55
    .byte $55, $AA, $55, $AA, $55, $AA, $55, $AA
    .byte $AA, $55, $AA, $55, $AA, $55, $AA, $55
    .byte $55, $AA, $55, $AA, $55, $AA, $55, $AA
Bitmap_data_end

; Color data for the checkerboard pattern (avoid dark/light blue)
Color_data
    .byte $0E, $0D, $0E, $0D, $0E, $0D, $0E, $0D   ; Alternating orange and brown
    .byte $0D, $0E, $0D, $0E, $0D, $0E, $0D, $0E   ; More rows
    .byte $0E, $0D, $0E, $0D, $0E, $0D, $0E, $0D
    .byte $0D, $0E, $0D, $0E, $0D, $0E, $0D, $0E
    .byte $0E, $0D, $0E, $0D, $0E, $0D, $0E, $0D
    .byte $0D, $0E, $0D, $0E, $0D, $0E, $0D, $0E
    .byte $0E, $0D, $0E, $0D, $0E, $0D, $0E, $0D
    .byte $0D, $0E, $0D, $0E, $0D, $0E, $0D, $0E
