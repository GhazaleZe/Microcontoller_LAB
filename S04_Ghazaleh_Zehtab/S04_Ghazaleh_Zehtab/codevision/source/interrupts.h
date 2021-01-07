#ifndef _interrupts_INCLUDED_
#define _interrupts_INCLUDED_

interrupt [EXT_INT0] void ext_int0_isr(void);
interrupt [EXT_INT1] void ext_int1_isr(void);
interrupt [TIM0_OVF] void timer0_ovf_isr(void);

#endif
