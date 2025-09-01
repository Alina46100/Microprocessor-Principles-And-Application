#include <xc.h>
#include <pic18f4520.h>
#define _XTAL_FREQ 1000000
    
#pragma config OSC = INTIO67    // Oscillator Selection bits
#pragma config WDT = OFF        // Watchdog Timer Enable bit 
#pragma config PWRT = OFF       // Power-up Enable bit
#pragma config BOREN = ON       // Brown-out Reset Enable bit
#pragma config PBADEN = OFF     // Watchdog Timer Enable bit 
#pragma config LVP = OFF        // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF        // Data EEPROM?Memory Code Protection bit (Data EEPROM code protection off)

    int clockwise = 0;
    void __interrupt(high_priority) H_ISR() {
    if (INTCONbits.INT0IF) { // ?????? (INT0)
        // ?????? (?????????90??0?)
    if (CCPR1L == 0x03 && CCP1CONbits.DC1B == 0b11){//-90
	    CCPR1L = 0x0b;
            CCP1CONbits.DC1B = 0b01;
	    clockwise = 0;
        }
	else if(CCPR1L == 0x0b && CCP1CONbits.DC1B == 0b01 && clockwise == 0){
            CCPR1L = 0x12;
            CCP1CONbits.DC1B = 0b11;
	    clockwise = 0;
        }
	else if(CCPR1L == 0x12 && CCP1CONbits.DC1B == 0b11){//90
            CCPR1L = 0x0b;
            CCP1CONbits.DC1B = 0b01;
	    clockwise = 1;
        }
        else if(CCPR1L == 0x0b && CCP1CONbits.DC1B == 0b01&& clockwise==1){
            CCPR1L = 0x03;
            CCP1CONbits.DC1B = 0b11;
	    clockwise = 1;
        }
    }
        __delay_ms(100);
        // ??????
        INTCONbits.INT0IF = 0;
}
    
    
    
    
    
void main(void)
{
    // Timer2 -> On, prescaler -> 4
    T2CONbits.TMR2ON = 0b1;
    T2CONbits.T2CKPS = 0b01;

    // Internal Oscillator Frequency, Fosc = 125 kHz, Tosc = 8 탎
    OSCCONbits.IRCF = 0b001;
    
    // PWM mode, P1A, P1C active-high; P1B, P1D active-high
    CCP1CONbits.CCP1M = 0b1100;
    
    // CCP1/RC2 -> Output
    TRISC = 0;
    LATC = 0;
    
    // Set up PR2, CCP to decide PWM period and Duty Cycle
    /** 
     * PWM period
     * = (PR2 + 1) * 4 * Tosc * (TMR2 prescaler)
     * = (0x9b + 1) * 4 * 8탎 * 4
     * = 0.019968s ~= 20ms
     */
    PR2 = 0x9b;
    
    /**
     * Duty cycle
     * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
     * = (0x0b*4 + 0b01) * 8탎 * 4
     * = 0.00144s ~= 1450탎
     */
    CCPR1L = 0x03;
    CCP1CONbits.DC1B = 0b11;
    INTCONbits.INT0IE = 1;   // ?? INT0 ??
    INTCONbits.INT0IF = 0;   // ?? INT0 ????
    INTCONbits.GIE = 1;      // ??????
    INTCON2bits.INTEDG0 = 0;
    while(1);
    return;
}


