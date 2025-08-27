List p=18f4520 ;???PIC18F4520
    ;???PIC18F
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; ???0x00???????
CLRF WREG
CLRF 0x000
CLRF 0x001
CLRF 0x002
CLRF 0x003
MOVLW b'00000001'
MOVWF 0x012
MOVLW 0x0F
MOVWF 0x011
MOVLW 0x00
MOVLW 0x010
MOVLW 0xFF
	MOVWF 0x000
	MOVWF 0x020
MOVLW 0xF1
	MOVWF 0x001
	MOVWF 0x021
MOVF 0x000, W
CPFSEQ 0x010
	GOTO ThreeOrFour
GOTO Loop2
ThreeOrFour:
MOVF 0x011, W
CPFSGT 0x000
    GOTO Three
GOTO Four
Three:
    MOVLW 0x08;2^8
    MOVWF 0x002
    MOVF 0x000, W
    CPFSEQ 0x012;if 1,      goto out
	GOTO LOOP
    INCF 0x013
    GOTO OUT
Four:

MOVLW 0x0C;2^12
MOVWF 0x002
BCF 0x020, 3;left the highes bit
BCF 0x020, 2
BCF 0x020, 1
BCF 0x020, 0
RRCF 0x020
RRCF 0x020
RRCF 0x020
RRCF 0x020
MOVF 0x012, W
CPFSEQ 0x020
    GOTO LOOP
GOTO OUT
LOOP:
MOVF 0x012, W
CPFSGT 0x020;til 00000001 bigger than 0x020
    GOTO OUT
    RLCF 0x012
    INCF 0x013;x
GOTO LOOP
OUT:
CPFSEQ 0x020;compare 0x020 with 0x012
    DECF 0x013
MOVF 0x013,   W
     ADDWF 0x002
BCF 0x000, 7
BCF 0x000, 6
BCF 0x000, 5
BCF 0x000, 4
MOVF 0x000, W
CPFSEQ 0x010;0 if the highest bit is three, if is goto next
    GOTO IfOneAndTwoEqual0
GOTO EndEnd
IfOneAndTwoEqual0:
MOVF 0x001, W
CPFSEQ 0x010; if 3 bit, compare 0x001 with 0 if not 0 than++
    INCF 0x002
GOTO EndEnd

Loop2:
    MOVF 0x012, W
    CPFSGT 0x021;0x012 is biigger, goto 
	GOTO Out2
    RLCF 0x012
    INCF 0x013;x
    GOTO Loop2
Out2:
    
    MOVF 0x001, W
    CPFSEQ 0x012;if 0x001 == 0x012
	DECF 0x013
    MOVF 0x013, W
    
    ADDWF 0x002, 1
    MOVF 0x011, W
    CPFSGT 0x001;if 0x001 is bigger than 0x011, keep goingon
        GOTO EndEnd
    
    BCF 0x001, 7;judge if first bit 0
    BCF 0x001, 6
    BCF 0x001, 5
    BCF 0x001, 4
    MOVF 0x001, W
    
    CPFSEQ  0x010
	INCF 0x002
EndEnd
end



