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

    LDA #$0D    ; using block 13 for sprite0
    STA $07F8
    
    LDA #$0C    ; using block 12 for sprite 1
    STA $07F9

; Enable sprite 0
    LDA #$01
    STA $d015
    
; Enable sprite 1
    LDA #$02
    ORA $d015  ; Keep sprite 0 enabled as well
    STA $d015

; Enable multicolor mode for sprite 1
    LDA #$02
    STA $d01c  ; Set bit 1 for multicolor sprite 1
    
; Build the first sprite
    LDX #0
BUILD_JAR
    LDA DATA_jar,X
    STA $0340,X
    INX
    CPX #64
    BNE BUILD_JAR

; Build the second sprite
    LDX #0
BUILD_WATER
    LDA DATA_water,X
    STA $0400,X   ; Use different memory location for the second sprite
    INX
    CPX #64
    BNE BUILD_WATER
    
; Set sprite 0 position
    LDA #$50          ; X position
    STA $D000
    LDA #$50          ; Y position
    STA $D001

; Set sprite 1 position
    LDA #$60          ; X position for sprite 1
    STA $D002         ; X position of sprite 1
    LDA #$60          ; Y position for sprite 1
    STA $D003         ; Y position of sprite 1

; Ensure MSB is 0
    LDA #$00
    STA $D010

; Set sprite 0 color
    LDA #$07          ; Color value (white)
    STA $D027

; Set sprite 1 colors
    LDA #$08          ; Main color (for example, light red)
    STA $D028
    LDA #$0C          ; Multicolor 1 (for example, blue)
    STA $D025
    LDA #$0E          ; Multicolor 2 (for example, green)
    STA $D026

    RTS               ; Return from subroutine

; DATA label included from the asm file below that contains the real data (include compatible with tmpx aka turbo macro pro
    .include "sprite-data.asm"
