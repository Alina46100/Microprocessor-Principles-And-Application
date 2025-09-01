    LIST p=18f4520
    #include <p18f4520.inc>

; CONFIG1H
  CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 3              ; Brown Out Reset Voltage bits (Minimum setting)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = PORTC        ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = ON           ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)

    ORG 0x00             ; ????????
    L3 EQU 0x16         ; Define L1 memory location
    L4 EQU 0x17         ; Define L2 memory location

; instruction frequency = 1 MHz / 4 = 0.25 MHz
; instruction time = 1/0.25 = 4 ?s
; Total_cycles = 2 + (2 + 8 * num1 + 3) * num2 cycles
; num1 = 111, num2 = 70, Total_cycles = 62512 cycles
; Total_delay ~= Total_cycles * instruction time = 0.25 s
DELAY macro num3, num4
    local LOOP3         ; Inner loop
    local LOOP4         ; Outer loop
    
    ; 2 cycles
    MOVLW num4          ; Load num2 into WREG
    MOVWF L4            ; Store WREG value into L2
    
    ; Total_cycles for LOOP2 = 2 cycles
    LOOP4:
    MOVLW num3          
    MOVWF L3  
    
    ; Total_cycles for LOOP1 = 8 cycles
    LOOP3:
    NOP                 ; busy waiting
    NOP
    NOP
    NOP
    NOP
    DECFSZ L3, 1        
    BRA LOOP3           ; BRA instruction spends 2 cycles
    
    ; 3 cycles
    DECFSZ L4, 1        ; Decrement L2, skip if zero
    BRA LOOP4           
endm 

BRA start
    
ISR:				; Interrupt????????????
    org 0x08		
    BTFSC INTCON, INT0IF  ; ?? INT0 ????
    GOTO HandleButton     ; ???????????????
    GOTO ti
    HandleButton:
    MOVLW 0x03
    CPFSEQ 0x000
        GOTO plus1
    MOVLW 0x01
    MOVWF 0x000
    GOTO b
    plus1:
    INCF 0x000
    b:
    BCF INTCON, INT0IF
    
    
    
    ti:
    
    
    BCF PIR1, TMR2IF        ; ??????TMR2IF?? (??flag bit)
    BSF INTCON, GIE
    GOTO State1
      
    RETFIE                    ; ??ISR?????????????????GIE??1??????interrupt????
    
start:
    MOVLW 0x0F           ; ?ADCON1??????
    MOVWF ADCON1         
    CLRF PORTB           ; ??PORTB
    BSF TRISB, 0         ; ??RB0???
    CLRF LATA           ; ??PORTA
    BCF TRISA, 0         ; ??RA0???
    BCF TRISA, 1         ; ??RA1???
    BCF TRISA, 2         ; ??RA2???
    BCF TRISA, 3         ; ??RA2???
    BCF RCON, IPEN
    BCF INTCON, INT0IF		; ??Interrupt flag bit??
    BSF INTCON, GIE		; ?Global interrupt enable bit??
    BSF INTCON, INT0IE		; ?interrupt0 enable bit ?? (INT0?RB0 pin?????)


main:
    BCF TRISA, 0         ; ??RA0???
    BCF TRISA, 1         ; ??RA1???
    BCF TRISA, 2         ; ??RA2???
    BTFSC PORTB, 0       ; ????(RB0)????
    MOVLW 0x01
    CPFSEQ 0x000
        BRA main
    BRA update_led

update_led:
    State1:
    BCF LATA, 0          ; ??1?RA0?
    BCF LATA, 1
    BCF LATA, 2
    BCF LATA, 3
    DELAY  d'350' , d'180'
    
    State1_2:
    ;CPFSEQ 0x02
    BCF LATA, 0
    BCF LATA, 1          ; ??2?RA1?
    BCF LATA, 2
    BSF LATA, 3
    DELAY  d'350' , d'180'
    
    
    State1_3:
    ;CPFSEQ 0x03
    BCF LATA, 0
    BCF LATA, 1
    BSF LATA, 2          ; ??3?RA2?
    BCF LATA, 3
    DELAY  d'350' , d'180'
    
    State1_4:
    ;CPFSEQ 0x03
    BCF LATA, 0
    BCF LATA, 1
    BSF LATA, 2          ; ??3?RA2?
    BSF LATA, 3
    DELAY  d'350' , d'180'
    MOVLW 0x01
    CPFSGT 0x000
    BRA end1
    
    State2_5:
    BCF LATA, 0          ; ??1?RA0?
    BSF LATA, 1
    BCF LATA, 2
    BCF LATA, 3
    DELAY  d'350' , d'180'
    
    
    State2_6:
    ;CPFSEQ 0x02
    BCF LATA, 0
    BSF LATA, 1          ; ??2?RA1?
    BCF LATA, 2
    BSF LATA, 3
    DELAY  d'350' , d'180'

    
    
    State2_7:
    ;CPFSEQ 0x03
    BCF LATA, 0
    BSF LATA, 1
    BSF LATA, 2          ; ??3?RA2?
    BCF LATA, 3
    DELAY  d'350' , d'180'
    
    State2_8:
    ;CPFSEQ 0x03
    BCF LATA, 0
    BSF LATA, 1
    BSF LATA, 2          ; ??3?RA2?
    BSF LATA, 3    
    DELAY  d'350' , d'180'
    MOVLW 0x02
    CPFSGT 0x000
    GOTO end1
    GOTO State3_9
        
    State3_9:
    BSF LATA, 0          ; ??1?RA0?
    BCF LATA, 1
    BCF LATA, 2
    BCF LATA, 3
    DELAY  d'350' , d'180'
    
    State3_10:
    ;CPFSEQ 0x02
    BSF LATA, 0
    BCF LATA, 1          ; ??2?RA1?
    BCF LATA, 2
    BSF LATA, 3
    DELAY  d'350' , d'180'
    
    
    State3_11:
    ;CPFSEQ 0x03
    BSF LATA, 0
    BCF LATA, 1
    BSF LATA, 2          ; ??3?RA2?
    BCF LATA, 3
    DELAY  d'350' , d'180'
    
    State3_12:
    ;CPFSEQ 0x03
    BSF LATA, 0
    BCF LATA, 1
    BSF LATA, 2          ; ??3?RA2?
    BSF LATA, 3

    State3_13:
    BSF LATA, 0          ; ??1?RA0?
    BSF LATA, 1
    BCF LATA, 2
    BCF LATA, 3
    DELAY  d'350' , d'180'
    
    
    State3_14:
    ;CPFSEQ 0x02
    BSF LATA, 0
    BSF LATA, 1          ; ??2?RA1?
    BCF LATA, 2
    BSF LATA, 3
    DELAY  d'350' , d'180'

    
    
    State3_15:
    ;CPFSEQ 0x03
    BSF LATA, 0
    BSF LATA, 1
    BSF LATA, 2          ; ??3?RA2?
    BCF LATA, 3
    DELAY  d'350' , d'180'
    
    State3_16:
    ;CPFSEQ 0x03
    BSF LATA, 0
    BSF LATA, 1
    BSF LATA, 2          ; ??3?RA2?
    BSF LATA, 3
    DELAY  d'350' , d'180'
end1:
    CLRF LATA            ; ????LED
    END






