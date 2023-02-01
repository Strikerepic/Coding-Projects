PORTB = $6000
PORTA = $6001
DATADIRB = $6002
DATADRIA = $6003

ENABLE = %10000000
RW = %0100000
REGISTERSELECT = %00100000    ; when register select is high, we are writting to the display 
  
  .org $8000

reset:

  ldx #$ff
  txs

  lda #%11111111 ; Data Direction for port b is now all output
  sta DATADIRB

  lda #%11100000 ; 3 MSBs are now configured for output everything else is input
  sta DATADRIA


  lda #%00111000 ; Set 8 bit mode, 2 line display and 5x8 sized font
  jsr LCD_COMMAND


  lda #%00001110 ; Display control, display on + cursor on + cursor blink is off  
  jsr LCD_COMMAND


  lda #%00000110 ; Increments the address allows text to be printed left to right. Otherwise right to left
  jsr LCD_COMMAND
  


HELLO:
  lda #%00000001 ; Clears Display 
  jsr LCD_COMMAND

  lda #%00000010 ; Returns home
  jsr LCD_COMMAND


  lda #"H"
  jsr LCD_WRITE_LETTER

  lda #"E"
  jsr LCD_WRITE_LETTER

  lda #"L"
  jsr LCD_WRITE_LETTER

  lda #"L"
  jsr LCD_WRITE_LETTER

  lda #"O"
  jsr LCD_WRITE_LETTER

  lda #" "
  jsr LCD_WRITE_LETTER

  lda #"W"
  jsr LCD_WRITE_LETTER

  lda #"O"
  jsr LCD_WRITE_LETTER

  lda #"R"
  jsr LCD_WRITE_LETTER

  lda #"L"
  jsr LCD_WRITE_LETTER

  lda #"D"
  jsr LCD_WRITE_LETTER

  lda #"!"
  jsr LCD_WRITE_LETTER

  lda #$ff
  lda #$ff
  lda #$ff
  lda #$ff
  lda #$ff
  lda #$ff
  lda #$ff
  lda #$ff
  lda #$ff
  lda #$ff
  lda #$ff
  lda #$ff
  
  jmp HELLO



loop:
  jmp loop


LCD_DELAY:
  pha
  lda #%00000000 ; DATADIRB is now input to read state of busy flag
  sta DATADIRB
LCD_LOOP:
  lda #RW
  sta PORTA
  lda #(RW || ENABLE)
  sta PORTA
  lda PORTB
  and #%10000000
  bne LCD_LOOP

  lda #RW
  sta PORTA
  lda #%11111111 ; DATADIRB is now output
  sta DATADIRB
  pla
  rts

LCD_COMMAND:
  jsr LCD_DELAY
  sta PORTB
  lda #0         ; clears RS E & RW
  sta PORTA
  lda #ENABLE    ; Read below to follow
  sta PORTA
  lda #0
  sta PORTA      ; in combo with above, flashes enable bit high telling display to accept instruction above
  rts

  LCD_WRITE_LETTER:
  sta PORTB
  lda #REGISTERSELECT        ; Setting Register select high to tell it were writting data this time
  sta PORTA
  lda #%10100000             ; Bootleg bitwise or for RegisterSlect and Enable
  sta PORTA
  lda #REGISTERSELECT
  sta PORTA                  ; in combo with above, flashes enable bit high telling display to accept instruction above
  rts



  .org $fffc
  .word reset
  .word $cbcb
