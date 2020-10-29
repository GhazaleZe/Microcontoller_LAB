#include <headers.h>

//when AcOrDec is 1 means nine to zero when it's 0 mean zero to 1

void  NineToZero(unsigned int descent){
    if(descent==0){ 
        DDRC=0xFF;
        DDRD=0x0F;
        DDRD.0=1;
        DDRD.1=1;
        DDRD.2=1;
        DDRD.3=1;
        PORTC=0b00111111;    //0
        delay_ms(500); 
        PORTC=0b00000110;    //1
        delay_ms(500);
        PORTC=0b01011011;    //2
        delay_ms(500); 
        PORTC=0b01001111;   //3
        delay_ms(500);
        PORTC=0b01100110;   //4
        delay_ms(500);
        PORTC=0b01101101;    //5
        delay_ms(500);
        PORTC=0b01111101;   //6
        delay_ms(500);
        PORTC=0b0000111;   //7
        delay_ms(500);
        PORTC=0b01111111;    //8
        delay_ms(500);
        PORTC=0b01101111; //9
        delay_ms(500);
    }
    else  { 
        DDRC=0xFF;
        DDRD=0x0F;
        DDRD.0=1;
        DDRD.1=1;
        DDRD.2=1;
        DDRD.3=1;
        PORTC=0b01101111; //9
        delay_ms(500);
        PORTC=0b01111111;    //8
        delay_ms(500);
        PORTC=0b0000111;   //7
        delay_ms(500);
        PORTC=0b01111101;   //6
        delay_ms(500);
        PORTC=0b01101101;    //5
        delay_ms(500);
        PORTC=0b01100110;   //4
        delay_ms(500);
        PORTC=0b01001111;   //3
        delay_ms(500);
        PORTC=0b01011011;    //2
        delay_ms(500); 
        PORTC=0b00000110;    //1
        delay_ms(500);
        PORTC=0b00111111;    //0
        delay_ms(500);
    }
}