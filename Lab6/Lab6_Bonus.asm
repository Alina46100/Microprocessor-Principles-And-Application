    LIST p=18f4520
    #include <p18f4520.inc>

    CONFIG OSC = INTIO67 ; ???????
    CONFIG WDT = OFF     ; ????????
    CONFIG LVP = OFF     ; ???????

    ORG 0x00             ; ????????
    L1 EQU 0x14         ; Define L1 memory location
    L2 EQU 0x15         ; Define L2 memory location
    L3 EQU 0x16         ; Define L1 memory location
    L4 EQU 0x17         ; Define L2 memory location
    L5 EQU 0x18         ; Define L1 memory location
    L6 EQU 0x19         ; Define L2 memory location

; instruction frequency = 1 MHz / 4 = 0.25 MHz
; instruction time = 1/0.25 = 4 ?s
; Total_cycles = 2 + (2 + 8 * num1 + 3) * num2 cycles
; num1 = 111, num2 = 70, Total_cycles = 62512 cycles
; Total_delay ~= Total_cycles * instruction time = 0.25 s
DELAY1 macro num3, num4
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
    ;BTFSS PORTB, 0       ; ????(RB0)????
    ;BRA State0
    DECFSZ L3, 1        
    BRA LOOP3           ; BRA instruction spends 2 cycles
    
    ; 3 cycles
    DECFSZ L4, 1        ; Decrement L2, skip if zero
    BRA LOOP4           
endm 
 
DELAY macro num1, num2
    local LOOP1         ; Inner loop
    local LOOP2         ; Outer loop
    
    ; 2 cycles
    MOVLW num2          ; Load num2 into WREG
    MOVWF L2            ; Store WREG value into L2
    
    ; Total_cycles for LOOP2 = 2 cycles
    LOOP2:
    MOVLW num1          
    MOVWF L1  
    
    ; Total_cycles for LOOP1 = 8 cycles
    LOOP1:
    NOP                 ; busy waiting
    NOP
    NOP
    NOP
    NOP
    BTFSS PORTB, 0       ; ????(RB0)????
    BRA State4
    DECFSZ L1, 1        
    BRA LOOP1           ; BRA instruction spends 2 cycles
    
    ; 3 cycles
    DECFSZ L2, 1        ; Decrement L2, skip if zero
    BRA LOOP2           
endm

DELAY2 macro num5, num6
    local LOOP5         ; Inner loop
    local LOOP6         ; Outer loop
    
    ; 2 cycles
    MOVLW num6          ; Load num2 into WREG
    MOVWF L6            ; Store WREG value into L2
    
    ; Total_cycles for LOOP2 = 2 cycles
    LOOP6:
    MOVLW num5          
    MOVWF L5  
    
    ; Total_cycles for LOOP1 = 8 cycles
    LOOP5:
    NOP                 ; busy waiting
    NOP
    NOP
    NOP
    NOP
    BTFSS PORTB, 0       ; ????(RB0)????
    BRA State0
    DECFSZ L5, 1        
    BRA LOOP5           ; BRA instruction spends 2 cycles
    
    ; 3 cycles
    DECFSZ L6, 1        ; Decrement L2, skip if zero
    BRA LOOP6           
endm    
    
start:
    MOVLW 0x0F           ; ?ADCON1??????
    MOVWF ADCON1         
    CLRF PORTB           ; ??PORTB
    BSF TRISB, 0         ; ??RB0???
    CLRF LATA           ; ??PORTA
    BCF TRISA, 0         ; ??RA0???
    BCF TRISA, 1         ; ??RA1???
    BCF TRISA, 2         ; ??RA2???


check_process:
    BCF TRISA, 0         ; ??RA0???
    BCF TRISA, 1         ; ??RA1???
    BCF TRISA, 2         ; ??RA2???
    BTFSC PORTB, 0       ; ????(RB0)????
    BRA check_process    ; ?????????


    ; ??LED??
    BRA update_led

release_wait:
    BTFSS PORTB, 0       ; ??????
    BRA release_wait

    ; ??????
    BRA check_process

update_led:
    State1:
    BSF LATA, 0          ; ??1?RA0?
    BCF LATA, 1
    BCF LATA, 2
    DELAY1 d'111', d'70'
    DELAY d'111', d'70'
    
    
    State2:
    ;CPFSEQ 0x02
    BCF LATA, 0
    BSF LATA, 1          ; ??2?RA1?
    BCF LATA, 2
    DELAY1 d'111', d'70'
    DELAY d'111', d'70'
    
    
    State3:
    ;CPFSEQ 0x03
    BCF LATA, 0
    BCF LATA, 1
    BSF LATA, 2          ; ??3?RA2?
    
    DELAY1 d'111', d'70'
    DELAY d'111', d'70'
    
BRA State1
    State4:
    MOVLW 0x05
    MOVWF 0x000
    BSF LATA, 0          ; ??1?RA0?
    BCF LATA, 1
    BCF LATA, 2
    DELAY1 d'111', d'70'
    DELAY2 d'111', d'70'
    DELAY2 d'111', d'70'
    DELAY2 d'111', d'70'
    
    State5:
    ;CPFSEQ 0x02
    BSF LATA, 0
    BSF LATA, 1          ; ??2?RA1?
    BCF LATA, 2
    DELAY1 d'111', d'70'
    DELAY2 d'111', d'70'
    DELAY2 d'111', d'70'
    DELAY2 d'111', d'70'
    
    State6:
    ;CPFSEQ 0x03
    BCF LATA, 0
    BCF LATA, 1
    BSF LATA, 2
    
    DELAY1 d'111', d'70'
    DELAY2 d'111', d'70'
    DCFSNZ 0x000
    BRA State4
    BCF LATA, 0
    BCF LATA, 1
    BCF LATA, 2
    
    DELAY1 d'111', d'70'
    DELAY2 d'111', d'70'
    DECF 0x000
    BRA State6
    
    
    
    
    
    State0:
    BCF LATA, 0
    BCF LATA, 1
    BCF LATA, 2          ; ??3?RA2?
    
    DELAY1 d'111', d'70'
    DELAY d'111', d'70'
    DELAY d'111', d'70'
    
    check0:
    BTFSC PORTB, 0       ; ????(RB0)????
    BRA check0    ; ?????????
    BRA State1

    END









