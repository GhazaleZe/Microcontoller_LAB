/*
 * s02.c
 *
 * Created: 10/5/2020 8:56:50 PM
 * Author: Ghazaleh Zehtab
 * Subject: Working with header files
 * Each question has its own header and source file named questionx.
 * In question6.c all other files are called and this function called is main.
 */

#include <headers.h> 
unsigned char sevenseg[]=
    {  
        
        0b00111111,  //0   
        0b00000110,  //1
        0b01011011,  //2   
        0b01001111, //3  
        0b01100110, //4 
        0b01101101, //5
        0b01111101, //6  
        0b0000111,  //7       
        0b01111111, //8
        0b01101111 //9   
        
    };
void main(void)
{

    // Please write your application code here
   CallAll(); //question6
}
