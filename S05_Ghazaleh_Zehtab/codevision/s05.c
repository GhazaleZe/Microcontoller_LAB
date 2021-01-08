/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 11/2/2020
Author  : Ghazaleh Zehtab
Company : IUT
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <headers.h>
int counter=1;
int handl_count=0;
int IsRight=1;
char* sp=" ";
int s=0;
int mydcr =0;
int duty=0;
int my_dc[2] = {0};
unsigned char temptc = 0;
unsigned char Over_Flow_timer1 = 0;
// Declare your global variables here
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here
    question1();
    //question3();
}
// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Place your code here
   Over_Flow_timer1 = 1;
}

// Timer1 input capture interrupt service routine
interrupt [TIM1_CAPT] void timer1_capt_isr(void)
{
    int myrpm;
    char outputstring[20];
// Place your code here
    if(Over_Flow_timer1 == 0)
    {
        my_dc[0] = ICR1L;
        my_dc[0] = my_dc[0] + ICR1H * 256;
        myrpm = my_dc[0] - my_dc[1];
        my_dc[1] = my_dc[0];
        myrpm = 60/(myrpm * 5 * 0.00008);
        if(myrpm - mydcr > 5 || myrpm - mydcr < -5)
            temptc++;
        if(myrpm - mydcr > 5 || mydcr - myrpm > 5 && temptc == 5)
        {
			
            sprintf(outputstring, "DC motor: %d", myrpm);
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts(outputstring);
            mydcr = myrpm;
            temptc = 0;
        } 
    
		}
	else
	{
	    Over_Flow_timer1 = 0;
		my_dc[1] = ICR1L;
		my_dc[1] = my_dc[1] + ICR1H * 128;
	}
}

// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
// Reinitialize Timer2 value
    TCNT2=0xB2;
    question4();

}

void main(void)
{
// Declare your local variables here
    question1();
    init_ports();
    timer_init();
    lcd_init(16);
    
// Global enable interrupts
#asm("sei")

while (1)
      {
      //question3();
      }
}
