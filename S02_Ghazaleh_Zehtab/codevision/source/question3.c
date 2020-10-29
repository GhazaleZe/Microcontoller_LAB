#include <headers.h>

void DiplayPortx_onLEDs(unsigned int inport, unsigned int outport){

    unsigned int Myinport=0;
    unsigned int p=0;
    switch(inport){ 
    
        case 0: 
            DDRA=0x00;
            Myinport = PINA;
            break;
                     
        case 1: 
        
            DDRB=0x00;       // define port B as input 
            Myinport = PINB;
            break;
            
        case 2: 
            DDRC=0x00;       // define port C as output  
            Myinport = PINC;
            break;

        case 3:  
            DDRD=0x00;       // define port D as output 
            Myinport = PIND;
            break;
        default: 
        
            DDRB=0x00;       // define port B as output
            Myinport=PINB;
            break;
    }
    switch(outport){ 
    
        case 0:
            DDRA=0xFF;
            while(p<3000){   
                PORTA=Myinport; 
                p++;
                delay_ms(1);
            } 
            p=0;
            break; 
        case 1: 
            DDRB=0xFF;
            while(p<3000){   
                PORTB=Myinport; 
                p++;
                delay_ms(1);
            }  
            break;
        case 2:
            DDRC=0xFF;
            while(p<3000){   
                PORTC=Myinport; 
                p++;
                delay_ms(1);
            }
            break;
        case 3:
            DDRD=0xFF;
            while(p<3000){   
                PORTD=Myinport; 
                p++;
                delay_ms(1);
            } 
            break;
        default:
            DDRB=0xFF;
            while(p<3000){   
                PORTB=Myinport; 
                p++;
                delay_ms(1);
            } 
            break;
    }
} 