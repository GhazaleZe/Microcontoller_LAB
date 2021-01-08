#include <headers.h>


unsigned int read_adc(unsigned char adc_input)
{
    ADMUX=adc_input | ADC_VREF_TYPE;
    delay_us(10);
    ADCSRA|=(1<<ADSC);
    while ((ADCSRA & (1<<ADIF))==0);
    ADCSRA|=(1<<ADIF);
    return ADCW;
}

void question1(void){
   data=0;
   i=0; 
   mat=0;
   pat=0; 
   init_timer_q1_q2();
   init_Interrupt();
   init_ADC_q1_q3();   
   lcd_clear();
   lcd_puts("This is Q1");
   for(i=0;i<8;i++){ 
        data = read_adc(i);
        pat = data * 5;
        mat = pat / 1023;
        mat = mat * 1000;
        data = floor(mat);
        sprintf(stringdata,"ADC%d: %d mV",i,data);
        lcd_gotoxy(0,1);
        lcd_puts("                 ");
        lcd_gotoxy(0,1);
        lcd_puts(stringdata);
        delay_ms(1500);
   }
}

void question2(void){
    lcd_init(16);
    init_timer_q1_q2();
    init_Interrupt();
    init_ADC_q2();
    i = 0;
    #asm("sei")
}

void question3(void){
    init_Interrupt();
    init_timer_q3(); 
    init_ADC_q1_q3();
    #asm("sei")   
}

void question4(void){
    question1();
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_puts("This is Question3");
    question3();
    delay_ms(10000);
    lcd_clear();
    lcd_gotoxy(0,0);
    question2();
}