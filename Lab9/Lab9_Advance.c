#include <xc.h>
#include <pic18f4520.h>
#include <stdio.h>
#define _XTAL_FREQ 1000000
#pragma config OSC = INTIO67 // Oscillator Selection bits
#pragma config WDT = OFF     // Watchdog Timer Enable bit
#pragma config PWRT = OFF    // Power-up Enable bit
#pragma config BOREN = ON    // Brown-out Reset Enable bit
#pragma config PBADEN = OFF  // Watchdog Timer Enable bit
#pragma config LVP = OFF     // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF     // Data EEPROM?Memory Code Protection bit (Data EEPROM code protection off)
uint8_t sequenceOdd[] = {1, 3, 5, 7, 9, 11, 13, 15};
uint8_t sequenceEven[] = {0, 2, 4, 6, 8, 10, 12, 14};
uint8_t seqIndex = 0;
int valueLast = 0;

void __interrupt(high_priority)H_ISR(){
    
    //step4
    int valueNow = (ADRESH << 8) | ADRESL;
    
    if(valueNow > valueLast + 32){
        LATA = sequenceOdd[valueNow / 128]*2;
        valueLast = valueNow;
    }
    else if(valueNow < valueLast - 32){
        LATA = sequenceEven[valueNow / 128]*2;
        valueLast = valueNow;
    }
    
    //do things
    
   
    
    
    
    
    
    
    
    
    
    
    //clear flag bit
    PIR1bits.ADIF = 0;
    
    
    //step5 & go back step3
    /*
    delay at least 2tad
     */
     __delay_us(4);
    ADCON0bits.GO = 1;
    
    
    return;
}

void main(void) 
{
    
    
    //configure OSC and port
    OSCCONbits.IRCF = 0b100; //1MHz
    TRISAbits.RA0 = 1;       //analog input port
    TRISAbits.RA1 = 0;
    TRISAbits.RA2 = 0;
    TRISAbits.RA3 = 0;
    TRISAbits.RA4 = 0;
    //step1
    ADCON1bits.VCFG0 = 0;
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.PCFG = 0b1110; //AN0 ?analog input,???? digital
    ADCON0bits.CHS = 0b0000;  //AN0 ?? analog input
    ADCON2bits.ADCS = 0b000;  //????000(1Mhz < 2.86Mhz)
    ADCON2bits.ACQT = 0b001;  //Tad = 2 us acquisition time?2Tad = 4 > 2.4
    ADCON0bits.ADON = 1;
    ADCON2bits.ADFM = 1;    //left justified 
    
    
    //step2
    PIE1bits.ADIE = 1;
    PIR1bits.ADIF = 0;
    INTCONbits.PEIE = 1;
    INTCONbits.GIE = 1;


    //step3
    ADCON0bits.GO = 1;
    
    while(1);
    
    return;
}