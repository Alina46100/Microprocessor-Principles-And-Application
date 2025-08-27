List p=18f4520
	#include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x0

MOVLW 0xFF
    MOVWF 0x000 ;first part
MOVLW 0xF1
    MOVWF 0x001 ;second part

MOVLW 0x08 ;Loop1 counter num
MOVWF 0x010 ;Loop1 counter

Loop1:
    BTFSC 0x000,7 ;test first bit, if 0 skip
	GOTO FirstBitis1
	RLNCF 0x000 ;rotate left
    DECFSZ 0x010 ;Loop1 counter -1
	GOTO Loop1
GOTO Loop2Counter
	
FirstBitis1:
    MOVLW 0x80
    CPFSEQ 0x000 ;test if other bits have 1
	GOTO FinishLoop1 ;other bits have 1
    DECFSZ 0x010 ;other bits don't have 1
GOTO NotFinishLoop1

Loop2Counter:
MOVLW 0x08 ;Loop2 counter num
MOVWF 0x011 ;Loop2 counter
    
Loop2:  
    BTFSC 0x001,7
	GOTO SecBitis1
	RLNCF 0x001
    DECFSZ 0x011
	GOTO Loop2
	
SecBitis1:
    MOVLW 0x80
    CPFSEQ 0x001
	GOTO FinishLoop2
    DECFSZ 0x011
    GOTO FinishLoop2

NotFinishLoop1: ;test second part have 1
    MOVLW 0x00
    CPFSEQ 0x001
	INCF 0x010 ;second part have 1
    
FinishLoop1:
    MOVLW 0x08
    ADDWF 0x010
    MOVFF 0x010,0x002 ;answer
    GOTO Finish

FinishLoop2:
    MOVFF 0x011,0x002 ;answer

Finish:
end


