
; Microprocessors_Project.asm
; Author : Benjamin Palay
; Student Number: 1815593

.include "./m328Pdef.inc"
.def loader = r25                     ;temporary register for loading other registers
.org 0x0000
rjmp Reset
.org 0x0016
rjmp  timer_compara
.org 0x002A
rjmp ADC_interrupt
.org 0x0368
jumptable:                            ;realistic environmental range of 0 to 40 degrees celcius
rjmp output0                          ;outputs 0 when zl is 104(dec) or 0x68
rjmp output1                          ;(adc value*5/1024 -0.5)/0.01 (sensor calibration)
rjmp output1                          ;outputs 1 when zl is 0x70 and so on
rjmp output2
rjmp output2
rjmp output3
rjmp output3
rjmp output4
rjmp output4
rjmp output5
rjmp output5
rjmp output6
rjmp output6
rjmp output7
rjmp output7
rjmp output8
rjmp output8
rjmp output9
rjmp output9
rjmp output10
rjmp output10
rjmp output11
rjmp output11
rjmp output12
rjmp output12
rjmp output13
rjmp output13
rjmp output14
rjmp output14
rjmp output15
rjmp output15
rjmp output16
rjmp output16
rjmp output17
rjmp output17
rjmp output17
rjmp output18
rjmp output18
rjmp output19
rjmp output19
rjmp output20
rjmp output20
rjmp output21
rjmp output21
rjmp output22
rjmp output22
rjmp output23
rjmp output23
rjmp output24
rjmp output24
rjmp output25
rjmp output25
rjmp output26
rjmp output26
rjmp output27
rjmp output27
rjmp output28
rjmp output28
rjmp output29
rjmp output29
rjmp output30
rjmp output30
rjmp output31
rjmp output31
rjmp output32
rjmp output32
rjmp output33
rjmp output33
rjmp output34
rjmp output34
rjmp output35
rjmp output35
rjmp output36
rjmp output36
rjmp output37
rjmp output37
rjmp output38
rjmp output38
rjmp output39
rjmp output39
rjmp output40


Reset:

ldi loader,(1<<CS12)|(1<<CS10)|(1<<WGM12)
sts TCCR1B,loader                        ;clock/1024 mode, reset clock at the top of the OCR1A register
ldi loader,0x3D
sts OCR1AH, loader
ldi loader,0x09
sts OCR1Al, loader                       ;interrupt every second: 16MHz/1024 = 15625. 64us per tick therefore need 15625 = 0x3D09 cycles for one second.                    
ldi loader, 1<<OCIE1A
sts TIMSK1, loader                       ;compare register A interrupt enabled

lds loader,PRR     
andi loader,0b11111110  
sts PRR,loader                           ;clears PRADC bit and therefore enables ADC

ldi loader,1<<REFS0                      ;clears REFS1, set RES0, read adcl, avcc with external capacitor at AREF pin
sts ADMUX,loader         
  
lds loader,DIDR0                        
ori loader,(1<<ADC0D)                   
sts DIDR0,loader                        ;disables digital input on PC0 and therefore saves power
  
ldi loader, 0b11111110
out ddrc, loader
ldi loader, 0b11111111
out ddrb, loader
out ddrd, loader                        ;all ports are set to write except for PINC0(ADC0)
ldi loader,(1<<ADEN)|(1<<ADIE)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0)
sts ADCSRA,loader                       ;set up ADC interrupt enable and set adc clock to 125kHz
   
sei                                     ;turn on global interrupts

ldi loader,low(RAMEND)                  ;initialize stack pointer
out SPL,loader
ldi loader,high(RAMEND)
out SPL,loader

ldi loader, (1<<SE)|(1<<SM0)
sts smcr, loader                        ;enable sleep in ADC noise reduction mode, thus saving power and reducing noise


  main: sleep
   rjmp main


ADC_interrupt:
 in r30, sreg
 push r30
 lds r18, ADCL
 lds r19, ADCH
 ldi zh, high(jumptable)
 mov zl, r18
 icall                                  ;calls code at location 0x03xx where xx is the hex value of adcl(r18) which then outputs the corresponding temperature. 
 pop r30
 out sreg, r30
reti

timer_compara:
 in r30, sreg
 push r30
 lds loader,ADCSRA
 ori loader,(1<<ADSC)
 sts ADCSRA,loader                      ;set up single ADC conversion 
 pop r30
 out sreg, r30
reti
  

    output0:
  ldi r28, 0b11101111
  out portb, r28
  ldi r29, 0b00010000
  out portc, r29
  ret
    output1:
  ldi r28, 0b11100110
  out portb, r28
  ret
    output2:
  ldi r28, 0b11111011
  out portb, r28
  ldi r29, 0b00100000
  out portc, r29
  ret
    output3:
  ldi r28, 0b11101111
  out portb, r28
  ldi r29, 0b00100000
  out portc, r29
  ret
    output4:
  ldi r28, 0b11101110
  out portb, r28
  ldi r29, 0b00110000
  out portc, r29
  ret
    output5:
  ldi r28, 0b11101101
  out portb, r28
  ldi r29, 0b00110000
  out portc, r29
  ret
    output6:
  ldi r28, 0b11111101
  out portb, r28
  ldi r29, 0b00110000
  out portc, r29
  ret
    output7:
  ldi r28, 0b11100111
  out portb, r28
  ret
    output8:
  ldi r28, 0b11111111
  out portb, r28
  ldi r29, 0b00110000
  out portc, r29
  ret
    output9:
  ldi r28, 0b11100111
  out portb, r28
  ldi r29, 0b00110000
  out portc, r29
  ret
    output10:
  ldi r28, 0b11101111
  out portb, r28
  ldi r29, 0b00011010
  out portc, r29
  ret
    output11:
  ldi r28, 0b11100110
  out portb, r28
  ldi r29, 0b00001010
  out portc, r29
  ret
    output12:
  ldi r28, 0b11111011
  out portb, r28
  ldi r29, 0b00101010
  out portc, r29
  ret
     output13:
  ldi r28, 0b11101111
  out portb, r28
  ldi r29, 0b00101010
  out portc, r29
  ret
     output14:
  ldi r28, 0b11100110
  out portb, r28
  ldi r29, 0b00111010
  out portc, r29
  ret
    output15:
  ldi r27, 0b00000110
  out portd, r27
  ldi r28, 0b11101101
  out portb, r28
  ldi r29, 0b00111010
  out portc, r29
  ret
   output16:
  ldi r27, 0b00000110
  out portd, r27
  ldi r28, 0b11111101
  out portb, r28
  ldi r29, 0b00111010
  out portc, r29
  ret
   output17: 
  ldi r27, 0b00000110
  out portd, r27
  ldi r28, 0b00000111
  out portb, r28
  ldi r29, 0b00001010
  out portc, r29
  ret
    output18: 
  ldi r27, 0b00000110
  out portd, r27
  ldi r28, 0b00011111
  out portb, r28
  ldi r29, 0b00111010
  out portc, r29
  ret
    output19: 
  ldi r27, 0b00000110
  out portd, r27
  ldi r28, 0b00000111
  out portb, r28
  ldi r29, 0b00111010
  out portc,r29
  ret
    output20: 
  ldi r27, 0b01011011
  out portd, r27
  ldi r28, 0b00011111
  out portb, r28
  ldi r29, 0b00011100
  out portc, r29
  ret
    output21: 
  ldi r27, 0b01011011
  out portd, r27
  ldi r28, 0b00000110
  out portb, r28
  ldi r29, 0b00001100
  out portc, r29
  ret
    output22: 
  ldi r27, 0b01011011
  out portd, r27
  ldi r28, 0b00011011
  out portb, r28
  ldi r29, 0b00101100
  out portc, r29
  ret
    output23:
  ldi r27, 0b01011000
  out portd, r27
  ldi r28, 0b0001111
  out portb, r28
  ldi r29, 0b00101100
  out portc, r29
  ret
    output24:
  ldi r27, 0b01011011
  out portd, r27
  ldi r28, 0b00000110
  out portb, r28
  ldi r29, 0b00111100
  out portc, r29
  ret
    output25:
  ldi r27, 0b01011011
  out portd, r27
  ldi r28, 0b00011101
  out portb, r28
  ldi r29, 0b00111100
  out portc, r29
  ret
    output26:
  ldi r27, 0b01011011
  out portd, r27
  ldi r28, 0b00011101
  out portb, r28
  ldi r29, 0b00111100
  out portc, r29
  ret
    output27:
  ldi r27, 0b01011000
  out portd, r27
  ldi r28, 0b00000111
  out portb, r28
  ldi r29, 0b00001100
  out portc, r29
  ret
     output28:
  ldi r27, 0b01011000
  out portd, r27
  ldi r28, 0b00011111
  out portb, r28
  ldi r29, 0b00111100
  out portc, r29
  ret
     output29:
  ldi r27, 0b01011000
  out portd, r27
  ldi r28, 0b00000111
  out portb, r28
  ldi r29, 0b00111100
  out portc, r29
  ret
     output30:
  ldi r27, 0b01001000
  out portd, r27
  ldi r28, 0b00011111
  out portb, r28
  ldi r29, 0b00011110
  out portc, r29
  ret
     output31:
  ldi r27, 0b01001000
  out portd, r27
  ldi r28, 0b00000110
  out portb, r28
  ldi r29, 0b00001110
  out portc, r29
  ret
     output32:
  ldi r27, 0b01001000
  out portd, r27
  ldi r28, 0b00011011
  out portb, r28
  ldi r29, 0b00101110
  out portc, r29
  ret
     output33:
  ldi r27, 0b01001000
  out portd, r27
  ldi r28, 0b00001111
  out portb, r28
  ldi r29, 0b00101110
  out portc, r29
  ret
     output34:
  ldi r27, 0b01001000
  out portd, r27
  ldi r28, 0b00000110
  out portb, r28
  ldi r29, 0b00111110
  out portc, r29
  ret
     output35:
  ldi r27, 0b01001000
  out portd, r27
  ldi r28, 0b00001101
  out portb, r28
  ldi r29, 0b00111110
  out portc, r29
  ret
     output36:
  ldi r27, 0b01001000
  out portd, r27
  ldi r28, 0b00011101
  out portb, r28
  ldi r29, 0b00111110
  out portc, r29
  ret
     output37:
  ldi r27, 0b01001000
  out portd, r27
  ldi r28, 0b00000111
  out portb, r28
  ldi r29, 0b00001110
  out portc, r29
  ret
     output38:
  ldi r27, 0b01001000
  out portd, r27
  ldi r28, 0b00011111
  out portb, r28
  ldi r29, 0b00111110
  out portc, r29
  ret
     output39:
  ldi r27, 0b01001000
  out portd, r27
  ldi r28, 0b00000111
  out portb, r28
  ldi r29, 0b00111110
  out portc, r29
  ret
     output40:
  ldi r27, 0b01100000
  out portd, r27
  ldi r28, 0b00011111
  out portb, r28
  ldi r29, 0b00011010
  out portc, r29
  ret
