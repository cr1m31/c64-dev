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
    
    LDA #$0E    ; using block 14 for sprite 1 (changed from $0C to $0E)
    STA $07F9

; Enable sprite 0
    LDA #$01
    STA $d015
    
; Enable sprite 1
    LDA #$02
    ORA $d015  ; Keep sprite 0 enabled as well
    STA $d015

; Enable multicolor mode for sprite 1
    LDA $D01C      ; Load current value of the sprite multicolor mode register
    ORA #$02       ; Set bit 1 to enable multicolor mode for sprite 1
    STA $D01C      ; Store the modified value back to the register
    
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
    STA $0380,X   ; Use different memory location for the second sprite
    INX
    CPX #64
    BNE BUILD_WATER
    
; Set sprite 0 position
    LDA #$50          ; X position
    STA $D000
    LDA #$50          ; Y position
    STA $D001

; Set sprite 1 position
    LDA #$80          ; X position for sprite 1
    STA $D002         ; X position of sprite 1
    LDA #$80          ; Y position for sprite 1
    STA $D003         ; Y position of sprite 1

; Ensure MSB is 0
    LDA #$00
    STA $D010

; Set sprite 0 color (single color mode)
    LDA #$07          ; Color value (example: white)
    STA $D027

; Set sprite 1 colors (multicolor mode)
    
    LDA #$08 
	STA $D025
	
	
	

    RTS               ; Return from subroutine

; DATA label included from the asm file below that contains the real data
; (include compatible with tmpx aka turbo macro pro)
    .include "sprite-data.asm"
