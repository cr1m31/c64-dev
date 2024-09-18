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

    ; Set up VIC-II for bitmap mode
    LDA #$00
    STA $D011        ; Disable raster interrupt
    LDA #$3B         ; Set bitmap mode
    STA $D011
    LDA #$18         ; Screen at $0400, bitmap at $2000
    STA $D018

    ; Copy bitmap data
    LDA #<Bitmap_data
    LDY #>Bitmap_data
    JSR CopyBitmapData

MainLoop
    JMP MainLoop     ; Infinite loop

CopyBitmapData
    LDX #$00
CopyLoop
    LDA Bitmap_data, X
    STA $2000, X
    INX
    BNE CopyLoop
    RTS

    ; Include bitmap data
.include "bitmap-data.asm"

