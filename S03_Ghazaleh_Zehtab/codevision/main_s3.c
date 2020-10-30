/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 10/16/2020
Author  : Ghazaleh Zehtab
Company : 
Comments:  Micro Lab 3


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <headers.h>

// Declare your global variables here

unsigned char data_key[4][4]={
'0','1','2','3',
'4','5','6','7',
'8','9','A','B',
'C','D','E','F'};


unsigned char colloc,rowloc;


// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
    DDRB=0x0F;
    PORTB=0xF0;    
    MyKeypad();
}

//*********************************************************
void main(void)
{
    init_board ();
    question6();
    
}
