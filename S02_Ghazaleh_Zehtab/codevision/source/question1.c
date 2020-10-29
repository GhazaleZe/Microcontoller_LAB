#include <headers.h>
//question 1 
void LED_ON_OFF(unsigned int NumberOfOn,char OutPort,unsigned int timer){

    unsigned int i; //integer as counter 
    switch(OutPort){ 
    
        case 0:
            DDRA=0xFF;       // define port A as output 
            for(i=0;i<NumberOfOn;i++)
            {        
                PORTA=0xFF;      //turn on all portA
                delay_ms(timer);  //delay         
                PORTA=0x00;     //turn off the portA
                delay_ms(timer);       
            }
             
        case 1: 
            DDRB=0xFF;       // define port B as output
            for(i=0;i<NumberOfOn;i++)
            {        
                PORTB=0xFF;      //turn on all portB
                delay_ms(timer);  //delay         
                PORTB=0x00;     //turn off the portB
                delay_ms(timer);       
            }
        case 2:
            DDRC=0xFF;       // define port C as output
            for(i=0;i<NumberOfOn;i++)
            {        
                PORTC=0xFF;      //turn on all portC
                delay_ms(timer);  //delay         
                PORTC=0x00;     //turn off the portC
                delay_ms(timer);       
            }
        case 3:
            DDRD=0xFF;       // define port D as output 
            for(i=0;i<NumberOfOn;i++)
            {        
                PORTD=0xFF;      //turn on all portD
                delay_ms(timer);  //delay         
                PORTD=0x00;     //turn off the portD
                delay_ms(timer);       
            }
        default:
            DDRB=0xFF;       // define port B as output
            for(i=0;i<NumberOfOn;i++)
            {        
                PORTB=0xFF;      //turn on all portB
                delay_ms(timer);  //delay         
                PORTB=0x00;     //turn off the portB
                delay_ms(timer);       
            }
    }
    
}