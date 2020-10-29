#include <headers.h>

void Reduce(float reducer){
    unsigned int number=0; 
    unsigned int numberCopy=0; 
    unsigned int FirstDigit=0;
    unsigned int SecondDigit=0;
    unsigned int ThirdDigit=0;
    unsigned int Deci=0;        // after point
    DDRA=0x00;
    DDRC=0xFF;
    DDRD=0x00;  
    number= PINA;
    numberCopy = number  *10;   //FOR making decimal easier 
    reducer *=10; 
    while(numberCopy>0){ 
        delay_ms(50); 
        number=numberCopy; 
        Deci=number%10;
        number= number /10;
        FirstDigit=number%10;
        number= number /10; 
        SecondDigit = number %10;  
        number= number /10;
        ThirdDigit= number; 
        DDRD.2=1;
        PORTC= sevenseg[FirstDigit]+ 0b10000000;   //point on
        delay_ms(1); 
        DDRD.2=0;
        DDRD.1=1;
        PORTC= sevenseg[SecondDigit];
        delay_ms(1); 
        DDRD.1=0;
        DDRD.0=1;
        PORTC= sevenseg[ThirdDigit]; 
        delay_ms(1); 
        DDRD.0=0;
        DDRD.3=1;
        PORTC= sevenseg[Deci];
        delay_ms(1); 
        DDRD.3=0;
        numberCopy = numberCopy - reducer ;
        //delay_ms(200);
        
          
        
    }
}