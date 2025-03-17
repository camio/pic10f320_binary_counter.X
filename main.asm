; Count a binary number using a shift register

PROCESSOR 10F320
    
; CONFIG
  CONFIG  FOSC = INTOSC         ; Oscillator Selection bits (INTOSC oscillator: CLKIN function disabled)
  CONFIG  BOREN = OFF           ; Brown-out Reset Enable (Brown-out Reset disabled)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable (WDT disabled)
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  MCLRE = OFF           ; MCLR Pin Function Select bit (MCLR pin function is digital input, MCLR internally tied to VDD)
  CONFIG  CP = OFF              ; Code Protection bit (Program memory code protection is disabled)
  CONFIG  LVP = OFF             ; Low-Voltage Programming Enable (High-voltage on MCLR/VPP must be used for programming)
  CONFIG  LPBOR = OFF           ; Brown-out Reset Selection bits (BOR disabled)
  CONFIG  BORV = LO             ; Brown-out Reset Voltage Selection (Brown-out Reset Voltage (Vbor), low trip point selected.)
  CONFIG  WRT = OFF             ; Flash Memory Self-Write Protection (Write protection off)

#include <xc.inc>

; Reset vector
PSECT resetVec,class=CODE
resetVec:
    goto    main

PSECT udata
counter:
    DS 1
x:
    DS 1    
bit:
    DS 1

#define LAT_SER   LATA0
#define LAT_RCLK  LATA1
#define LAT_SRCLK LATA2

#define TRIS_SER  TRISA0
#define TRIS_RCLK TRISA1
#define TRIS_SRCLK TRISA2

PSECT code
; Sets the shift register's value to W
setOutput:
    MOVWF x
    ; set bit to 7
    MOVLW 0x08
    MOVWF bit
    ; loop over the bit
setOutput_loop:
    BSF LAT_SER
    RLF x,F
    BTFSS CARRY
    BCF LAT_SER
    BSF LAT_SRCLK ; Tick SRCLK
    BCF LAT_SRCLK
    DECFSZ bit,F
    GOTO setOutput_loop
        
    BSF LAT_RCLK ; Tick RCLK
    BCF LAT_RCLK
    
    RETURN

PSECT code
main:
    BCF IRCF0 ; Set frequency to 31 kHz
    BCF IRCF1
    BCF IRCF2
        
    BCF T0CS   ; Enable timer 0
    BCF TMR0IE ; Disable timer 0 interrupt
    BCF PS0    ; Set prescaler to 1:2
    BCF PS1
    BCF PS2
    BCF PSA    ; Enable prescaler
    CLRF TMR0  ; clear the timer
    
    BCF TRIS_SER ; Set RA's 0-2 to output mode
    BCF TRIS_RCLK
    BCF TRIS_SRCLK
    
    CLRF counter
loop:
    BTFSS TMR0IF
    GOTO loop
    BCF TMR0IF
 
    ; call setOutput with counter
    MOVF counter,W
    CALL setOutput
    
    INCF counter, F
    GOTO loop
    
END resetVec