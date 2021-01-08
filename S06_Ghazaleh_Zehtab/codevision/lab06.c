/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 11/28/2020
Author  : 
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <headers.h>

// Declare your global variables here
long int data,help_data=0;
int i=0; 
float mat=0;
float pat=0;
float myocr,duty_cycle=0;
//char* stringdata=" "; 
char stringdata[8]; 
unsigned int adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
unsigned int predata[8] = {0};
// ADC interrupt service routine
// with auto input scanning
interrupt [ADC_INT] void adc_isr(void)
{
    static unsigned char input_index=0;  
    float more,less= 0;
    data,help_data = 0;
    pat,mat = 0;  
    lcd_clear();
    // Read the AD conversion result
    adc_data[input_index]=ADCW;
    // Select next ADC input   
    if (++input_index > (LAST_ADC_INPUT-FIRST_ADC_INPUT))
       input_index=0;
    ADMUX=(FIRST_ADC_INPUT | ADC_VREF_TYPE)+input_index;
    // Delay needed for the stabilization of the ADC input voltage
    delay_us(10);
    //************************************  
    data = adc_data[i];
    help_data = data;
    pat = ((data * 5)/100);
    more = data + pat;
    less = data - pat;  
    if (more < predata[i] || less > predata[i]){
        lcd_clear();  
        predata[i] = help_data;
        lcd_gotoxy(0,0);
        lcd_puts("This is Q2");
        mat = ((data * 5)/1023)*1000;
        data = floor(mat);
        sprintf(stringdata,"ADC %d: %d mV",i,data);
        lcd_gotoxy(0,1);
        lcd_puts("                            ");
        lcd_gotoxy(0,1);       
        lcd_puts(stringdata);
        delay_ms(1500);
        //stringdata= NULL; 
    }   
    i++;
    if (i > 7){
     i = 0;
     }

    //***********************************
    // Start the AD conversion
    ADCSRA|=(1<<ADSC);
}
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{

    data = read_adc(0);
    duty_cycle = ((data*90)/1024) + 5;
    myocr = (2.55 * duty_cycle) + 0.5;
    OCR0 = floor(myocr);
}

void main(void)
{
    // Declare your local variables here

    init_board();
    // Global enable interrupts
    //#asm("sei")
    //question1();
    //question2();
    //question3();
    question4();
    while(1){   
      //question3();
    }
}
