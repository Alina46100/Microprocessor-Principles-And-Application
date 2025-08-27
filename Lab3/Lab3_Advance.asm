List p=18f4520 ;???PIC18F4520
    ;???PIC18F
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; ???0x00???????
MOVLW 0x77
MOVWF 0x000
MOVLW 0x77;12CBx0935
MOVWF 0x001
MOVLW 0x56
MOVWF 0x010
MOVLW 0x78
MOVWF 0x011
	
MULWF 0x001;multiple CBx35 from 12CBx0935
BTFSC STATUS, 0;if status's zero bit equal 0
    INCF 0x022;if status's zero bit equal 1than carry
MOVF PRODL, W           
    MOVWF 0x031; put the lower 2 bit to 0x031
    MOVF PRODH, W; put the higher 2 bit to 0x30
    MOVWF 0x030

 

MOVF 0x000, W
MULWF 0x011;12x35
MOVF PRODL, W           
    MOVWF 0x041             ; ?? PROD_L
    MOVF PRODH, W           
    MOVWF 0x040
MOVF 0x001, W
MULWF 0x010;CBx09
MOVF PRODL, W           
    MOVWF 0x051             
    MOVF PRODH, W           
    MOVWF 0x050
MOVF 0x000, W
MULWF 0x010;12x09
MOVF PRODL, W           
    MOVWF 0x061             
    MOVF PRODH, W           
    MOVWF 0x060

MOVFF 0x031, 0x023

MOVF 0x030, W
ADDWF 0x041, 1
BTFSC STATUS, 0
    INCF 0x021
MOVF 0x041, W
ADDWF 0x051, 1
BTFSC STATUS, 0
    INCF 0x021
MOVF 0x051, W
ADDWF 0x022, 1
BTFSC STATUS, 0
    INCF 0x021
    
MOVF 0x040,  W
ADDWF 0x050, W
BTFSC STATUS, 0
    INCF 0x020
ADDWF 0x061, W
BTFSC STATUS, 0
    INCF 0x020
ADDWF 0x021, 1

BTFSC STATUS, 0
    INCF 0x020
MOVF 0x060, W
ADDWF 0x020, 1




end





