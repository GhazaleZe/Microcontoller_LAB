/*******************************************************
Project :  
Version : 
Date    : 10/24/2020
Author  : Ghazaleh Zehtab
Company : 
Comments:   Lab 04


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <headers.h>

// Declare your global variables here
int ms=0;
int sec=0;
int min=0;
int hour=0;
int Empty=1000;
unsigned char* ms_char="00";
unsigned char* sec_char="00";
unsigned char* min_char="00";
unsigned char* hour_char="00";
unsigned char* blank = "           ";
int flag=1;
unsigned char* em =" ";


void main(void)
{
    initial();
    lcd_init(16);

    // Global enable interrupts
    #asm("sei")
    DDRB = 0x00;
    while (1)
          {
          }
}
