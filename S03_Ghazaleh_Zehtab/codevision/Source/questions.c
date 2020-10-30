#include <headers.h>


void question1(void){
    char *str = "Ghazale Zehtab";
    char *std_num = "961234";
    lcd_init(16);
    lcd_puts(str);
    lcd_gotoxy(0,1);
    lcd_puts(std_num);
    delay_ms(2000);
    lcd_clear();
}

void question2 (void){
    
    char pat[57] = "Welcome to the online lab classes due to Corona disease."; 
    unsigned int i=0;
    unsigned int j=0;
    unsigned int k=0; 
    lcd_init(16); 
    lcd_clear();
    lcd_gotoxy(0,0);
    for(i=0;i<56;i++) {
        lcd_clear();
        lcd_gotoxy(0,0);
        k= i+16;
        if(i+16>=56){
          k= 56-i-1;  
        }      
        for (j=i;j<k;j++){
          lcd_putchar(pat[j]);  
        }      
        delay_ms(120);
    } 
    
}

void question3(void){
    unsigned int counter=0; 
    lcd_init(16);
    lcd_clear(); 
    lcd_gotoxy(0,0);
    lcd_puts("Q3 Starts");
    delay_ms(1000);
    lcd_clear(); 
    lcd_gotoxy(0,0);  
    while(counter<20){ 
        MyKeypad();
        counter++;
        delay_ms(100);   
    }
    lcd_clear();
    lcd_puts("Q3 Ended");
    delay_ms(2000);
    lcd_clear();
}


void question4(void){
    
    lcd_clear();
    lcd_puts("Q4 Starts");
    delay_ms(200);
    lcd_clear();
    lcd_gotoxy(0,0);
    DDRB=0x0F;
    PORTB=0xF0;
    #asm("sei")
    delay_ms(3000);
}

void question5(void){

    unsigned char input1, input2;

    while(1)
    {
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_puts("Speed??(00-50r)");
        lcd_gotoxy(0, 1);
        input1 = MyKeypad();
        input2 = MyKeypad();
        
        if ((input1 == '5' && input2 != '0')|| input1>'5' || input2>'9')
        {
            lcd_clear();
            lcd_puts("EE");
            delay_ms(2000);
        }
        else
        {
            delay_ms(1000);
            break;
        }
    }

    while(1)
    {
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_puts("Time:??(00-99s)");
        lcd_gotoxy(0, 1);
        input1 = MyKeypad();
        input2 = MyKeypad();

        if (input1>'9' || input2>'9')
        { 
            lcd_clear();
            lcd_puts("EE");
            delay_ms(2000);
        }
        else
        {
            delay_ms(1000);
            break;
        }
    }

    while(1)
    {
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_puts("Weight??(00-99F)");
        lcd_gotoxy(0, 1);


        input1 = MyKeypad();
        input2 = MyKeypad();

        if (input1>'9' || input2>'9')
        { 
            lcd_clear();
            lcd_puts("EE");
            delay_ms(2000);
        }
        else
        {
            delay_ms(2000);
            break;
        }
    }

    while(1)
    {
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_puts("Temp??(20-80C)");
        lcd_gotoxy(0, 1);

        input1 = MyKeypad();
        input2 = MyKeypad();

        if ((input1 == '8' && input2 != '0') || input1<'2' || input1>'8' || input2>'9')
        {  
            lcd_clear();
            lcd_puts("EE");
            delay_ms(2000);
        }
        else
        {
            delay_ms(2000);
            break;
        }
    }
}

void question6(void){
    lcd_init(16);
    question1(); 
    question2(); 
    question3(); 
    question4();
    question5(); 
    lcd_clear();
    lcd_puts("The End");
    delay_ms(2000);
}