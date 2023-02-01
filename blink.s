PORTB = $6000
PORTA = $6001
DATADIRB = $6002
DATADRIA = $6003

ENABLE = %10000000
RW = %0100000
REGISTERSELECT = %00100000
  
  .org $8000



reset:
  lda #%11111111 ; Data Direction for port b is now all output
  sta DATADIRB

  lda #%11100000 ; 3 MSBs are now configured for output everything else is input
  sta DATADRIA

  lda #%00111000 ; Set 8 bit mode, 2 line display and 5x8 sized font
  sta PORTB

  lda #0         ; clears RS E & RW
  sta PORTA

  lda #ENABLE    ; Read below to follow
  sta PORTA

  lda #0
  sta PORTA      ; in combo with above, flashes enable bit high telling display to accept instruction above






  lda #%00001110 ; Display control, display on + cursor on + cursor blink is off  
  sta PORTB

  lda #0         ; clears RS E & RW
  sta PORTA

  lda #ENABLE    ; Read below to follow
  sta PORTA

  lda #0
  sta PORTA      ; in combo with above, flashes enable bit high telling display to accept instruction above







  lda #%00000110 ; Increments the address allows text to be printed left to right. Otherwise right to left
  sta PORTB      ; This also turns off display shift. Basicly scroll or not. Its set to scroll off.

  lda #0         ; clears RS E & RW
  sta PORTA

  lda #ENABLE    ; Read below to follow
  sta PORTA

  lda #0
  sta PORTA      ; in combo with above, flashes enable bit high telling display to accept instruction above




  lda #"H"
  sta PORTB

  lda #RS        ; clears RS E & RW
  sta PORTA

  lda #(RS | ENABLE)    ; Read below to follow
  sta PORTA

  lda #RS
  sta PORTA      ; in combo with above, flashes enable bit high telling display to accept instruction above





  
  
  


loop:
  jmp loop

  .org $fffc
  .word reset
  .word $cbcb
