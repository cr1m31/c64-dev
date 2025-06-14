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

; ----------------------------------------------------------
; Define your colors
; ----------------------------------------------------------
; Color for bit pair "01"
lda #$0F         ; Example color (light gray)
sta $D025        ; Set color in register $D025

; Color for bit pair "11"
lda #$0C         ; Example color (light blue)
sta $D026        ; Set color in register $D026

; Color for bit pair "10" (individual for sprite 0)
lda #$02         ; Example color (red)
sta $D027        ; Set sprite 0 color in its color register

; Set background color (change this to your desired color)
; lda #$03         ; Example color
; sta $D021        ; Set background color in register $D021
; ----------------------------------------------------------

; Turn on multicolor mode for all sprites
lda #$FF
sta $d01c 

lda #%00000001 ; select sprite 0
sta $D015   ; Activate SPRITE 0 register

lda #$90   
sta $D000 ; Sprite 0 Horizontal Position X coordinate
lda #$8F
sta $D001 ; Sprite 0 Vertical Position Y coordinate

lda #%00000001  ; Only the bit for sprite 0 is set
sta $D017 ; Sprite Vertical Expansion Register

lda #%00000001  ; Only the bit for sprite 0 is set
sta $D01D ; Sprite Horizontal Expansion Register

lda #$80
sta $07F8   ; Set the location to find SPRITE0 Shape Data Pointers

SP0INIT
ldx #$00   ; SET X=0
jsr SPR0LOADLOOP ; Load SPRITE0 into memory

SPR0LOADLOOP
lda SPRITE0DATA,x
sta $2000,x ; Sprite 0 data start = $2000
inx
cpx #$40
bne SPR0LOADLOOP
rts

SPRITE0DATA
    .byte $03, $FF, $00, $07, $FF, $80, $0F, $FF, $80, $1F, $83, $80, $3E, $00, $80
    .byte $7C, $00, $7F, $78, $00, $7E, $F8, $00, $7C, $F0, $00, $78, $F0, $00, $70
    .byte $F0, $00, $00, $F0, $00, $70, $F0, $00, $78, $F8, $00, $7C, $78, $00, $7E 
    .byte $7C, $00, $7F, $3E, $00, $80, $1F, $83, $80, $0F, $FF, $80, $07, $FF, $80 
    .byte $03, $FF, $00, $00
