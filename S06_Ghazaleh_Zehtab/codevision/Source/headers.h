#ifndef _headers_INCLUDED_
#define _headers_INCLUDED_
#include <mega16.h>

#include <delay.h>

// Alphanumeric LCD functions
#include <alcd.h>
#include <math.h>
#include <stdio.h>
#include <init_board.h>
#include <questions.h>
#define FIRST_ADC_INPUT 0
#define LAST_ADC_INPUT 7
extern unsigned int adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
// Voltage Reference: AREF pin
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
extern long int data,help_data;
extern   int i; 
extern   float mat;
extern   float pat;
extern   char stringdata[8]; 
#endif