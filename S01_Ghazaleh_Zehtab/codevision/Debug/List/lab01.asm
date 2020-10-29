
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x3:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7D,0x7
	.DB  0x7F,0x6F
_0x29:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  _sevenseg
	.DW  _0x3*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*
; * lab01.c
; *
; * Created: 10/1/2020 1:32:13 PM
; * Author: Ghazaleh Zehtab
; */
;
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;
;unsigned char sevenseg[]=
;    {
;
;        0b00111111,  //0
;        0b00000110,  //1
;        0b01011011,  //2
;        0b01001111, //3
;        0b01100110, //4
;        0b01101101, //5
;        0b01111101, //6
;        0b0000111,  //7
;        0b01111111, //8
;        0b01101111 //9
;
;    } ;

	.DSEG
;
;//question 1
;void AllLedON_4Times(void){
; 0000 001D void AllLedON_4Times(void){

	.CSEG
_AllLedON_4Times:
; .FSTART _AllLedON_4Times
; 0000 001E 
; 0000 001F     unsigned int i; //integer as counter
; 0000 0020     DDRB=0xFF;       // define port B as output
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0021     for(i=0;i<4;i++)
	__GETWRN 16,17,0
_0x5:
	__CPWRN 16,17,4
	BRSH _0x6
; 0000 0022     {
; 0000 0023        PORTB=0xFF;      //turn on all portB
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0024        delay_ms(500);  //delay
	RCALL SUBOPT_0x0
; 0000 0025        PORTB=0x00;     //turn off the portB
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0026        delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 0027     }
	__ADDWRN 16,17,1
	RJMP _0x5
_0x6:
; 0000 0028 }
	RJMP _0x2000001
; .FEND
;//question 2
;void DancingLight(void){
; 0000 002A void DancingLight(void){
_DancingLight:
; .FSTART _DancingLight
; 0000 002B 
; 0000 002C     unsigned int i; //integer as counter
; 0000 002D     unsigned int num;
; 0000 002E     num=1;
	CALL __SAVELOCR4
;	i -> R16,R17
;	num -> R18,R19
	__GETWRN 18,19,1
; 0000 002F     DDRB=0xFF;       // define port B as output
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0030     for(i=0;i<20;i++)
	__GETWRN 16,17,0
_0x8:
	__CPWRN 16,17,20
	BRSH _0x9
; 0000 0031     {
; 0000 0032        PORTB=num;      //turn on all portB
	OUT  0x18,R18
; 0000 0033        delay_ms(150);
	LDI  R26,LOW(150)
	LDI  R27,0
	CALL _delay_ms
; 0000 0034        num = num * 2;    // turn on next LED
	__MULBNWRU 18,19,2
	MOVW R18,R30
; 0000 0035        if (num > 128){    //if last on in ON back to the beginig
	__CPWRN 18,19,129
	BRLO _0xA
; 0000 0036         num= 1;
	__GETWRN 18,19,1
; 0000 0037        }
; 0000 0038     }
_0xA:
	__ADDWRN 16,17,1
	RJMP _0x8
_0x9:
; 0000 0039 }
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;//question 3
;void DiplayPortA_onLEDs(void){
; 0000 003B void DiplayPortA_onLEDs(void){
_DiplayPortA_onLEDs:
; .FSTART _DiplayPortA_onLEDs
; 0000 003C     unsigned int i=0;
; 0000 003D     DDRA=0x00;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 003E     DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 003F     while(i<3000){
_0xB:
	__CPWRN 16,17,3000
	BRSH _0xD
; 0000 0040         PORTB=PINA;
	IN   R30,0x19
	OUT  0x18,R30
; 0000 0041         i++;
	__ADDWRN 16,17,1
; 0000 0042         delay_ms(1);
	RCALL SUBOPT_0x1
; 0000 0043     }
	RJMP _0xB
_0xD:
; 0000 0044 }
_0x2000001:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;//question 4
;void NineToZero(void){
; 0000 0046 void NineToZero(void){
_NineToZero:
; .FSTART _NineToZero
; 0000 0047     DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0048     DDRD=0x0F;
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0000 0049     DDRD.0=1;
	SBI  0x11,0
; 0000 004A     DDRD.1=1;
	SBI  0x11,1
; 0000 004B     DDRD.2=1;
	SBI  0x11,2
; 0000 004C     DDRD.3=1;
	SBI  0x11,3
; 0000 004D     PORTC=0b01101111; //9
	LDI  R30,LOW(111)
	OUT  0x15,R30
; 0000 004E     delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 004F     PORTC=0b01111111;    //8
	LDI  R30,LOW(127)
	OUT  0x15,R30
; 0000 0050     delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 0051     PORTC=0b0000111;   //7
	LDI  R30,LOW(7)
	OUT  0x15,R30
; 0000 0052     delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 0053     PORTC=0b01111101;   //6
	LDI  R30,LOW(125)
	OUT  0x15,R30
; 0000 0054     delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 0055     PORTC=0b01101101;    //5
	LDI  R30,LOW(109)
	OUT  0x15,R30
; 0000 0056     delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 0057     PORTC=0b01100110;   //4
	LDI  R30,LOW(102)
	OUT  0x15,R30
; 0000 0058     delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 0059     PORTC=0b01001111;   //3
	LDI  R30,LOW(79)
	OUT  0x15,R30
; 0000 005A     delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 005B     PORTC=0b01011011;    //2
	LDI  R30,LOW(91)
	OUT  0x15,R30
; 0000 005C     delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 005D     PORTC=0b00000110;    //1
	LDI  R30,LOW(6)
	OUT  0x15,R30
; 0000 005E     delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 005F     PORTC=0b00111111;    //0
	LDI  R30,LOW(63)
	OUT  0x15,R30
; 0000 0060     delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 0061 
; 0000 0062 
; 0000 0063 }
	RET
; .FEND
;// question 5
;
;void Reduce(void){
; 0000 0066 void Reduce(void){
_Reduce:
; .FSTART _Reduce
; 0000 0067 
; 0000 0068     unsigned int number=0;
; 0000 0069     unsigned int numberCopy=0;
; 0000 006A     unsigned int FirstDigit=0;
; 0000 006B     unsigned int SecondDigit=0;
; 0000 006C     unsigned int ThirdDigit=0;
; 0000 006D     unsigned int Deci=0;        // after point
; 0000 006E     DDRA=0x00;
	SBIW R28,6
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	STD  Y+5,R30
	RCALL SUBOPT_0x2
;	number -> R16,R17
;	numberCopy -> R18,R19
;	FirstDigit -> R20,R21
;	SecondDigit -> Y+10
;	ThirdDigit -> Y+8
;	Deci -> Y+6
; 0000 006F     DDRC=0xFF;
; 0000 0070     DDRD=0x00;
; 0000 0071     number= PINA;
; 0000 0072     numberCopy = number  *10;   //FOR making decimal easier
; 0000 0073     while(numberCopy>0){
_0x16:
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRSH _0x18
; 0000 0074         delay_ms(50);
	RCALL SUBOPT_0x3
; 0000 0075         number=numberCopy;
; 0000 0076         Deci=number%10;
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0077         number= number /10;
	RCALL SUBOPT_0x4
; 0000 0078         FirstDigit=number%10;
	MOVW R20,R30
; 0000 0079         number= number /10;
	RCALL SUBOPT_0x4
; 0000 007A         SecondDigit = number %10;
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 007B         number= number /10;
	RCALL SUBOPT_0x5
; 0000 007C         ThirdDigit= number;
	__PUTWSR 16,17,8
; 0000 007D         DDRD.2=1;
	RCALL SUBOPT_0x6
; 0000 007E         PORTC= sevenseg[FirstDigit]+ 0b10000000;   //point on
	SUBI R30,-LOW(128)
	OUT  0x15,R30
; 0000 007F         delay_ms(1);
	RCALL SUBOPT_0x1
; 0000 0080         DDRD.2=0;
	CBI  0x11,2
; 0000 0081         DDRD.1=1;
	SBI  0x11,1
; 0000 0082         PORTC= sevenseg[SecondDigit];
	RCALL SUBOPT_0x7
; 0000 0083         delay_ms(1);
; 0000 0084         DDRD.1=0;
	CBI  0x11,1
; 0000 0085         DDRD.0=1;
	SBI  0x11,0
; 0000 0086         PORTC= sevenseg[ThirdDigit];
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RCALL SUBOPT_0x8
; 0000 0087         delay_ms(1);
; 0000 0088         DDRD.0=0;
	CBI  0x11,0
; 0000 0089         DDRD.3=1;
	SBI  0x11,3
; 0000 008A         PORTC= sevenseg[Deci];
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL SUBOPT_0x8
; 0000 008B         delay_ms(1);
; 0000 008C         DDRD.3=0;
	CBI  0x11,3
; 0000 008D         numberCopy = numberCopy - 2 ;
	__SUBWRN 18,19,2
; 0000 008E 
; 0000 008F 
; 0000 0090     }
	RJMP _0x16
_0x18:
; 0000 0091 
; 0000 0092 
; 0000 0093 }
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
;
;// question 6
;void reset7seg(void){
; 0000 0096 void reset7seg(void){
_reset7seg:
; .FSTART _reset7seg
; 0000 0097 
; 0000 0098     unsigned int number=0;
; 0000 0099     unsigned int numberCopy=0;
; 0000 009A     unsigned int FirstDigit=0;
; 0000 009B     unsigned int SecondDigit=0;
; 0000 009C     unsigned int ThirdDigit=0;
; 0000 009D     unsigned int Deci=0;        // after point
; 0000 009E     unsigned int fib=0;
; 0000 009F     unsigned int foo=0;
; 0000 00A0     DDRA=0x00;
	SBIW R28,10
	LDI  R24,10
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x29*2)
	LDI  R31,HIGH(_0x29*2)
	CALL __INITLOCB
	RCALL SUBOPT_0x2
;	number -> R16,R17
;	numberCopy -> R18,R19
;	FirstDigit -> R20,R21
;	SecondDigit -> Y+14
;	ThirdDigit -> Y+12
;	Deci -> Y+10
;	fib -> Y+8
;	foo -> Y+6
; 0000 00A1     DDRC=0xFF;
; 0000 00A2     DDRD=0x00;
; 0000 00A3     number= PINA;
; 0000 00A4     numberCopy = number  *10;   //FOR making decimal easier
; 0000 00A5     while(numberCopy>0){
_0x2A:
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRLO PC+2
	RJMP _0x2C
; 0000 00A6 
; 0000 00A7         delay_ms(50);
	RCALL SUBOPT_0x3
; 0000 00A8         number=numberCopy;
; 0000 00A9         Deci=number%10;
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 00AA         number= number /10;
	RCALL SUBOPT_0x4
; 0000 00AB         FirstDigit=number%10;
	MOVW R20,R30
; 0000 00AC         number= number /10;
	RCALL SUBOPT_0x4
; 0000 00AD         SecondDigit = number %10;
	STD  Y+14,R30
	STD  Y+14+1,R31
; 0000 00AE         number= number /10;
	RCALL SUBOPT_0x5
; 0000 00AF         ThirdDigit= number;
	__PUTWSR 16,17,12
; 0000 00B0         DDRD.2=1;
	RCALL SUBOPT_0x6
; 0000 00B1         PORTC= sevenseg[FirstDigit];   //point off
	OUT  0x15,R30
; 0000 00B2         delay_ms(1);
	RCALL SUBOPT_0x1
; 0000 00B3         DDRD.2=0;
	CBI  0x11,2
; 0000 00B4         DDRD.1=1;
	SBI  0x11,1
; 0000 00B5         PORTC= sevenseg[SecondDigit];
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	RCALL SUBOPT_0x8
; 0000 00B6         delay_ms(1);
; 0000 00B7         DDRD.1=0;
	CBI  0x11,1
; 0000 00B8         DDRD.0=1;
	SBI  0x11,0
; 0000 00B9         PORTC= sevenseg[ThirdDigit];
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	RCALL SUBOPT_0x8
; 0000 00BA         delay_ms(1);
; 0000 00BB         DDRD.0=0;
	CBI  0x11,0
; 0000 00BC         DDRD.3=1;
	SBI  0x11,3
; 0000 00BD         PORTC= sevenseg[Deci];
	RCALL SUBOPT_0x7
; 0000 00BE         delay_ms(1);
; 0000 00BF         DDRD.3=0;
	CBI  0x11,3
; 0000 00C0         numberCopy = numberCopy - 2 ;
	__SUBWRN 18,19,2
; 0000 00C1 
; 0000 00C2          if (PIND.7==0){               //reduce that number from main number in all 4 if
	SBIC 0x10,7
	RJMP _0x3D
; 0000 00C3              foo= numberCopy / 10;           //fib and foo are temp
	RCALL SUBOPT_0x9
; 0000 00C4              foo = foo/10;
; 0000 00C5              foo = foo/10;
	RCALL SUBOPT_0xA
; 0000 00C6              fib= foo % 10;
; 0000 00C7              fib = fib *1000;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12U
	RCALL SUBOPT_0xB
; 0000 00C8              numberCopy= numberCopy - fib;
	__SUBWRR 18,19,26,27
; 0000 00C9              SecondDigit= 0 ;
	LDI  R30,LOW(0)
	STD  Y+14,R30
	STD  Y+14+1,R30
; 0000 00CA              ThirdDigit= 0;
	STD  Y+12,R30
	STD  Y+12+1,R30
; 0000 00CB 
; 0000 00CC             //delay_ms(1000);
; 0000 00CD         }
; 0000 00CE         if (PIND.6==0){
_0x3D:
	SBIC 0x10,6
	RJMP _0x3E
; 0000 00CF              foo= numberCopy / 10;
	RCALL SUBOPT_0x9
; 0000 00D0              foo = foo/10;
; 0000 00D1              fib= foo % 10;
	CALL __MODW21U
	RCALL SUBOPT_0xB
; 0000 00D2              fib = fib *100;
	LDI  R30,LOW(100)
	CALL __MULB1W2U
	RCALL SUBOPT_0xB
; 0000 00D3              numberCopy= numberCopy - fib;
	__SUBWRR 18,19,26,27
; 0000 00D4              SecondDigit= 0 ;
	LDI  R30,LOW(0)
	STD  Y+14,R30
	STD  Y+14+1,R30
; 0000 00D5         }
; 0000 00D6         if (PIND.5==0){
_0x3E:
	SBIC 0x10,5
	RJMP _0x3F
; 0000 00D7              foo= numberCopy / 10;
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0xA
; 0000 00D8              fib= foo % 10;
; 0000 00D9              fib = fib *10;
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(10)
	CALL __MULB1W2U
	RCALL SUBOPT_0xB
; 0000 00DA              numberCopy= numberCopy - fib;
	__SUBWRR 18,19,26,27
; 0000 00DB              FirstDigit= 0;
	__GETWRN 20,21,0
; 0000 00DC         }
; 0000 00DD         if (PIND.4==0){
_0x3F:
	SBIC 0x10,4
	RJMP _0x40
; 0000 00DE              //delay_ms(1000);
; 0000 00DF              fib= numberCopy % 10;
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	RCALL SUBOPT_0xB
; 0000 00E0              numberCopy= numberCopy - fib;
	__SUBWRR 18,19,26,27
; 0000 00E1              Deci= 0;
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
; 0000 00E2 
; 0000 00E3         }
; 0000 00E4 
; 0000 00E5     }
_0x40:
	RJMP _0x2A
_0x2C:
; 0000 00E6 
; 0000 00E7 
; 0000 00E8 }
	CALL __LOADLOCR6
	ADIW R28,16
	RET
; .FEND
;
;void main(void)
; 0000 00EB {
_main:
; .FSTART _main
; 0000 00EC     // Please write your application code here
; 0000 00ED     AllLedON_4Times();   // call function of question 1
	RCALL _AllLedON_4Times
; 0000 00EE     DancingLight(); //call function for question 2
	RCALL _DancingLight
; 0000 00EF     NineToZero();      //call function for question 4
	RCALL _NineToZero
; 0000 00F0     while(1){
_0x41:
; 0000 00F1         DiplayPortA_onLEDs(); //  call function for question 3
	RCALL _DiplayPortA_onLEDs
; 0000 00F2         Reduce();   //call function for question 5
	RCALL _Reduce
; 0000 00F3         reset7seg(); //call function for question 6
	RCALL _reset7seg
; 0000 00F4     }
	RJMP _0x41
; 0000 00F5 
; 0000 00F6 
; 0000 00F7 
; 0000 00F8 }
_0x44:
	RJMP _0x44
; .FEND

	.DSEG
_sevenseg:
	.BYTE 0xA

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2:
	CALL __SAVELOCR6
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	LDI  R30,LOW(255)
	OUT  0x14,R30
	LDI  R30,LOW(0)
	OUT  0x11,R30
	IN   R16,25
	CLR  R17
	__MULBNWRU 16,17,10
	MOVW R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
	MOVW R16,R18
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x4:
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOVW R16,R30
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	SBI  0x11,2
	LDI  R26,LOW(_sevenseg)
	LDI  R27,HIGH(_sevenseg)
	ADD  R26,R20
	ADC  R27,R21
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUBI R30,LOW(-_sevenseg)
	SBCI R31,HIGH(-_sevenseg)
	LD   R30,Z
	OUT  0x15,R30
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	SUBI R30,LOW(-_sevenseg)
	SBCI R31,HIGH(-_sevenseg)
	LD   R30,Z
	OUT  0x15,R30
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x9:
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	CALL __DIVW21U
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
