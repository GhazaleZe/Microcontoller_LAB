#include <headers.h>

//question2

void DancingLight(unsigned int StartPoint,unsigned int timer){

    unsigned int i; //integer as counter
    unsigned int j;
    unsigned int num;
    num=1;
    DDRB=0xFF;       // define port B as output  
    timer /= 20;
    for(j=0;j<StartPoint;j++){  
        num=num*2;
    }
    for(i=0;i<20;i++)
    {        
       PORTB=num;      //turn on all portB  
       delay_ms(timer);   
       num = num * 2;    // turn on next LED
       if (num > 128){    //if last on in ON back to the beginig
        num= 1;
       } 
    }
}