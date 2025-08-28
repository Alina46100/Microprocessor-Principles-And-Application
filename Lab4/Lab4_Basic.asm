List p=18f4520 ;???PIC18F4520
    ;???PIC18F
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; ???0x00???????

Sub_Mul macro xh, xl, yh, yl
    MOVLW xl
    MOVWF 0x010
    MOVLW yl       
    SUBWF 0x010, W
    MOVWF 0x001           
    ;MOVF yl, W     
    
    MOVLW xh
    MOVWF 0x011
    MOVLW yh
    SUBWFB 0x011, W        
    MOVWF 0x000       
    
MOVF 0x000, W
MULWF 0x001, W
MOVFF PRODH, 0x010
MOVFF PRODL, 0x011
ENDM
    
Sub_Mul 0x03, 0xA5, 0x02 , 0xA7
END

    


