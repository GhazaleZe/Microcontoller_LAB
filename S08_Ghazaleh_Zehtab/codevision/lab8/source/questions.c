#include <headers.h>

void question1(){
    int r = 0;
    int c = 0;
    int max_column = 8;
    int min_column = 0; 
    int i=0;  
    while(1){
        for(i=0;i<150;i++){
                PORTD = 0x80;
                PORTB = GZ16x8[r];
                PORTA = 1<<c;

                delay_ms(3);

                PORTD = 0x00;
                PORTB = GZ16x8[r+8];
                PORTA = 1<<c;

                r++;
                if (r == max_column)
                {
                    r = min_column;   
                }
                c = (c+1)%8;
                delay_ms(3);
                
          } 
                 
          if (max_column == 248)
          {
            max_column = 8;
            min_column = 0;
            r=0;
            c=0;
                    //break;
          }
                 
          else
          { 
             max_column =  max_column + 16;
             min_column = min_column + 16;
          }

    }        
}

void question2(){
    glcd_putimagef(0,0,images_gh,GLCD_PUTCOPY); 
}

void question3(){
	
	s++;
        if(s == 60)
        {
            m++;
            s = 0;  
        }
        if(m == 60)
        {
            h++;
            m = 0;
        }
        if(h == 12){
            h = 0;  
            
        }
        
        glcd_clear();
       
        glcd_circle(63, 31, 30);
        glcd_setlinestyle(3,4);
        glcd_circle(63, 31, 2);
        glcd_setlinestyle(1,GLCD_LINE_SOLID); 

        x = 25*cos(s*6);
        y = 25*sin(s*6);
      
        glcd_line(63,31,x+63,31-y); 
        
        x = 20*cos(m*6);
        y = 20*sin(m*6);
        
        glcd_line(63,31,x+63,31-y); 
        
        x = 15*cos(h*6);
        y = 15*sin(h*6);
        
        glcd_line(63,31,x+63,31-y);
	
   
}