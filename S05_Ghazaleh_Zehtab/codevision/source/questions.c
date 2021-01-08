#include <headers.h>

void question1(void){
    OCR0=0xE5 ;// change ;
}

void question3(void){
    //float cal=0;
    //char * t=" ";
    duty=15;
    delay_ms(1000);
    DDRA=0x00;
    duty= PINA;
    duty = ((duty*90)/255) + 5; 
    duty = floor((duty * 255)/100);
    //sprintf(t,"%d",duty);
    //lcd_clear();   
    //lcd_puts(t);
    //delay_ms(1000);
    OCR0= duty; 
}

void question4(void){
    /*DDRB.4=0x1;
    DDRB.5=0x1;
    DDRB.6=0x1;
    DDRB.7=0x1;*/
    if (handl_count<=100){
        if (IsRight == 1 ){ 
            if (counter == 1) {
                PORTB.4 = 1;  //A
                PORTB.5 = 0;  //B
                PORTB.6 = 0;  //C
                PORTB.7 = 0;  //D
                counter ++ ;
            }
            if (counter == 2) {
                PORTB.4 = 0;  //A
                PORTB.5 = 1;  //B
                PORTB.6 = 0;  //C
                PORTB.7 = 0;  //D 
                counter ++ ;
            }
            if (counter == 3) {
                PORTB.4 = 0;  //A
                PORTB.5 = 0;  //B
                PORTB.6 = 1;  //C
                PORTB.7 = 0;  //D
                counter ++ ;
            }
            if (counter == 4) {
                PORTB.4 = 0;  //A
                PORTB.5 = 0;  //B
                PORTB.6 = 0;  //C
                PORTB.7 = 1;  //D
                counter ++ ;
            } 
            
            if (counter > 4){
                counter=1;
            }
        }
        handl_count++;  
    }
    
    
    if (handl_count==100){ 
           PORTB.4 = 0;  //A
           PORTB.5 = 0;  //B
           PORTB.6 = 0;  //C
           PORTB.7 = 0;  //D
           IsRight=0;
           delay_ms(50);
           handl_count++;
    }
     
    if (handl_count >100 &&  handl_count<=200){ 
        if (IsRight == 0 ){ //Left
            if (counter == 1) {
                PORTB.4 = 0;  //A
                PORTB.5 = 0;  //B
                PORTB.6 = 0;  //C
                PORTB.7 = 1;  //D
                counter ++ ;
            }
            if (counter == 2) {
                PORTB.4 = 0;  //A
                PORTB.5 = 0;  //B
                PORTB.6 = 1;  //C
                PORTB.7 = 0;  //D
                counter ++ ;
            }
            if (counter == 3) {
                PORTB.4 = 0;  //A
                PORTB.5 = 1;  //B
                PORTB.6 = 0;  //C
                PORTB.7 = 0;  //D 
                counter ++ ;
            }
            if (counter == 4) {
                PORTB.4 = 1;  //A
                PORTB.5 = 0;  //B
                PORTB.6 = 0;  //C
                PORTB.7 = 0;  //D
                counter ++ ;
            }
            
            if (counter > 4){
                counter=1;
            }
            
        }
        handl_count++; 
    }
      
    if (handl_count>200){
        handl_count=0; 
        IsRight=1;
    }
 
    s= 1/((0.01)*4);  
    sprintf(sp,"%d",s); 
    lcd_gotoxy(0,0);
    lcd_puts(sp);
    lcd_gotoxy(5,0);
    lcd_puts("cycle/s");   
}

