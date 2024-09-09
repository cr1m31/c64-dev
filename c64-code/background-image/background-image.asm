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

    LDX #$00          ; Set X register to zero
    LDY #$00          ; Set Y register to zero

    ; Initialize VIC-II Registers
    LDA #$00
    STA $D011         ; Disable raster interrupt
    LDA #$1B
    STA $D016         ; Set bitmap mode

    ; Set the VIC-II to use bitmap graphics mode
    LDA #$00
    STA $D018         ; Screen control register

    ; Load bitmap data
    LDA #<Bitmap_data
    LDY #>Bitmap_data
    JSR CopyBitmapData

MainLoop:
    JMP MainLoop      ; Infinite loop to keep program running

; ----------------------------------------------------------
; Set up VIC-II registers for bitmap mode
; ----------------------------------------------------------
; This should be moved to initialization, already covered in the above section

; ----------------------------------------------------------
; Load bitmap data
; ----------------------------------------------------------
; No need to repeat here

; ----------------------------------------------------------
; CopyBitmapData routine
; ----------------------------------------------------------
CopyBitmapData:
    LDA #$00          ; Set source address low byte
    STA $0400         ; Start address for bitmap data
    LDA #$00          ; Set source address high byte
    STA $0401         ; High byte of start address
    LDX #$00          ; Zero page address low byte
    LDY #$00          ; Zero page address high byte
CopyLoop:
    LDA Bitmap_data, X ; Load byte from source
    STA $0400, X      ; Store byte in video memory
    INX
    BNE CopyLoop
    RTS

; ----------------------------------------------------------
; Include bitmap data
; ----------------------------------------------------------
.include "bitmap-data.asm"

