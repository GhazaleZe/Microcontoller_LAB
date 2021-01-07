#include <mega16.h>

// Alphanumeric LCD functions
#include <alcd.h>

#include <timer_init.h> 

#include <initial.h>

#include <interrupts.h>

#include <stdio.h>

#include <delay.h>


extern int ms;
extern int sec;
extern int min;
extern int hour;
extern int Empty;

extern unsigned char* ms_char;
extern unsigned char* sec_char;
extern unsigned char* min_char;
extern unsigned char* hour_char;
extern unsigned char* blank;
extern int flag;
extern unsigned char* em;