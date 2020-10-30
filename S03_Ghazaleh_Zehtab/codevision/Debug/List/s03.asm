
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
;Global 'const' stored in FLASH: Yes
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  _ext_int1_isr
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
	.DB  0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37
	.DB  0x38,0x39,0x41,0x42,0x43,0x44,0x45,0x46
_0x40004:
	.DB  0x57,0x65,0x6C,0x63,0x6F,0x6D,0x65,0x20
	.DB  0x74,0x6F,0x20,0x74,0x68,0x65,0x20,0x6F
	.DB  0x6E,0x6C,0x69,0x6E,0x65,0x20,0x6C,0x61
	.DB  0x62,0x20,0x63,0x6C,0x61,0x73,0x73,0x65
	.DB  0x73,0x20,0x64,0x75,0x65,0x20,0x74,0x6F
	.DB  0x20,0x43,0x6F,0x72,0x6F,0x6E,0x61,0x20
	.DB  0x64,0x69,0x73,0x65,0x61,0x73,0x65,0x2E
	.DB  0x0
_0x40000:
	.DB  0x47,0x68,0x61,0x7A,0x61,0x6C,0x65,0x20
	.DB  0x5A,0x65,0x68,0x74,0x61,0x62,0x0,0x39
	.DB  0x36,0x32,0x39,0x31,0x36,0x33,0x0,0x51
	.DB  0x33,0x20,0x53,0x74,0x61,0x72,0x74,0x73
	.DB  0x0,0x51,0x33,0x20,0x45,0x6E,0x64,0x65
	.DB  0x64,0x0,0x51,0x34,0x20,0x53,0x74,0x61
	.DB  0x72,0x74,0x73,0x0,0x53,0x70,0x65,0x65
	.DB  0x64,0x3F,0x3F,0x28,0x30,0x30,0x2D,0x35
	.DB  0x30,0x72,0x29,0x0,0x45,0x45,0x0,0x54
	.DB  0x69,0x6D,0x65,0x3A,0x3F,0x3F,0x28,0x30
	.DB  0x30,0x2D,0x39,0x39,0x73,0x29,0x0,0x57
	.DB  0x65,0x69,0x67,0x68,0x74,0x3F,0x3F,0x28
	.DB  0x30,0x30,0x2D,0x39,0x39,0x46,0x29,0x0
	.DB  0x54,0x65,0x6D,0x70,0x3F,0x3F,0x28,0x32
	.DB  0x30,0x2D,0x38,0x30,0x43,0x29,0x0,0x54
	.DB  0x68,0x65,0x20,0x45,0x6E,0x64,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x10
	.DW  _data_key
	.DW  _0x3*2

	.DW  0x0F
	.DW  _0x40003
	.DW  _0x40000*2

	.DW  0x08
	.DW  _0x40003+15
	.DW  _0x40000*2+15

	.DW  0x0A
	.DW  _0x4000C
	.DW  _0x40000*2+23

	.DW  0x09
	.DW  _0x4000C+10
	.DW  _0x40000*2+33

	.DW  0x0A
	.DW  _0x40010
	.DW  _0x40000*2+42

	.DW  0x10
	.DW  _0x40014
	.DW  _0x40000*2+52

	.DW  0x03
	.DW  _0x40014+16
	.DW  _0x40000*2+68

	.DW  0x10
	.DW  _0x40014+19
	.DW  _0x40000*2+71

	.DW  0x03
	.DW  _0x40014+35
	.DW  _0x40000*2+68

	.DW  0x11
	.DW  _0x40014+38
	.DW  _0x40000*2+87

	.DW  0x03
	.DW  _0x40014+55
	.DW  _0x40000*2+68

	.DW  0x0F
	.DW  _0x40014+58
	.DW  _0x40000*2+104

	.DW  0x03
	.DW  _0x40014+73
	.DW  _0x40000*2+68

	.DW  0x08
	.DW  _0x40032
	.DW  _0x40000*2+119

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 10/16/2020
;Author  : Ghazaleh Zehtab
;Company :
;Comments:  Micro Lab 3
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <headers.h>
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
;
;// Declare your global variables here
;
;unsigned char data_key[4][4]={
;'0','1','2','3',
;'4','5','6','7',
;'8','9','A','B',
;'C','D','E','F'};

	.DSEG
;
;
;unsigned char colloc,rowloc;
;
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0028 {

	.CSEG
_ext_int1_isr:
; .FSTART _ext_int1_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0029     DDRB=0x0F;
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 002A     PORTB=0xF0;
	LDI  R30,LOW(240)
	OUT  0x18,R30
; 0000 002B     MyKeypad();
	CALL _MyKeypad
; 0000 002C }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;//*********************************************************
;void main(void)
; 0000 0030 {
_main:
; .FSTART _main
; 0000 0031     init_board ();
	RCALL _init_board
; 0000 0032     question6();
	CALL _question6
; 0000 0033 
; 0000 0034 }
_0x4:
	RJMP _0x4
; .FEND
;#include <headers.h>
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
;void init_board (void){
; 0001 0002 void init_board (void){

	.CSEG
_init_board:
; .FSTART _init_board
; 0001 0003     // Input/Output Ports initialization
; 0001 0004     // Port A initialization
; 0001 0005     // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0001 0006     DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0001 0007     // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0001 0008     PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0001 0009 
; 0001 000A     // Port B initialization
; 0001 000B     // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In
; 0001 000C     DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0001 000D     // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=T Bit2=T Bit1=T Bit0=T
; 0001 000E     PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0001 000F 
; 0001 0010     // Port C initialization
; 0001 0011     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0001 0012     DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0001 0013     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0001 0014     PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0001 0015 
; 0001 0016     // Port D initialization
; 0001 0017     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0001 0018     DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0001 0019     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0001 001A     PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0001 001B 
; 0001 001C     // Timer/Counter 0 initialization
; 0001 001D     // Clock source: System Clock
; 0001 001E     // Clock value: Timer 0 Stopped
; 0001 001F     // Mode: Normal top=0xFF
; 0001 0020     // OC0 output: Disconnected
; 0001 0021     TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0001 0022     TCNT0=0x00;
	OUT  0x32,R30
; 0001 0023     OCR0=0x00;
	OUT  0x3C,R30
; 0001 0024 
; 0001 0025     // Timer/Counter 1 initialization
; 0001 0026     // Clock source: System Clock
; 0001 0027     // Clock value: Timer1 Stopped
; 0001 0028     // Mode: Normal top=0xFFFF
; 0001 0029     // OC1A output: Disconnected
; 0001 002A     // OC1B output: Disconnected
; 0001 002B     // Noise Canceler: Off
; 0001 002C     // Input Capture on Falling Edge
; 0001 002D     // Timer1 Overflow Interrupt: Off
; 0001 002E     // Input Capture Interrupt: Off
; 0001 002F     // Compare A Match Interrupt: Off
; 0001 0030     // Compare B Match Interrupt: Off
; 0001 0031     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0001 0032     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0001 0033     TCNT1H=0x00;
	OUT  0x2D,R30
; 0001 0034     TCNT1L=0x00;
	OUT  0x2C,R30
; 0001 0035     ICR1H=0x00;
	OUT  0x27,R30
; 0001 0036     ICR1L=0x00;
	OUT  0x26,R30
; 0001 0037     OCR1AH=0x00;
	OUT  0x2B,R30
; 0001 0038     OCR1AL=0x00;
	OUT  0x2A,R30
; 0001 0039     OCR1BH=0x00;
	OUT  0x29,R30
; 0001 003A     OCR1BL=0x00;
	OUT  0x28,R30
; 0001 003B 
; 0001 003C     // Timer/Counter 2 initialization
; 0001 003D     // Clock source: System Clock
; 0001 003E     // Clock value: Timer2 Stopped
; 0001 003F     // Mode: Normal top=0xFF
; 0001 0040     // OC2 output: Disconnected
; 0001 0041     ASSR=0<<AS2;
	OUT  0x22,R30
; 0001 0042     TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0001 0043     TCNT2=0x00;
	OUT  0x24,R30
; 0001 0044     OCR2=0x00;
	OUT  0x23,R30
; 0001 0045 
; 0001 0046     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0001 0047     TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0001 0048 
; 0001 0049     // External Interrupt(s) initialization
; 0001 004A     // INT0: Off
; 0001 004B     // INT1: On
; 0001 004C     // INT1 Mode: Falling Edge
; 0001 004D     // INT2: Off
; 0001 004E     GICR|=(1<<INT1) | (0<<INT0) | (0<<INT2);
	IN   R30,0x3B
	ORI  R30,0x80
	OUT  0x3B,R30
; 0001 004F     MCUCR=(1<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(8)
	OUT  0x35,R30
; 0001 0050     MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0001 0051     GIFR=(1<<INTF1) | (0<<INTF0) | (0<<INTF2);
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0001 0052 
; 0001 0053     // USART initialization
; 0001 0054     // USART disabled
; 0001 0055     UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0001 0056 
; 0001 0057     // Analog Comparator initialization
; 0001 0058     // Analog Comparator: Off
; 0001 0059     // The Analog Comparator's positive input is
; 0001 005A     // connected to the AIN0 pin
; 0001 005B     // The Analog Comparator's negative input is
; 0001 005C     // connected to the AIN1 pin
; 0001 005D     ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0001 005E     SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0001 005F 
; 0001 0060     // ADC initialization
; 0001 0061     // ADC disabled
; 0001 0062     ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0001 0063 
; 0001 0064     // SPI initialization
; 0001 0065     // SPI disabled
; 0001 0066     SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0001 0067 
; 0001 0068     // TWI initialization
; 0001 0069     // TWI disabled
; 0001 006A     TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0001 006B 
; 0001 006C     // Alphanumeric LCD initialization
; 0001 006D     // Connections are specified in the
; 0001 006E     // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0001 006F     // RS - PORTA Bit 0
; 0001 0070     // RD - PORTA Bit 1
; 0001 0071     // EN - PORTA Bit 2
; 0001 0072     // D4 - PORTA Bit 4
; 0001 0073     // D5 - PORTA Bit 5
; 0001 0074     // D6 - PORTA Bit 6
; 0001 0075     // D7 - PORTA Bit 7
; 0001 0076     // Characters/line: 16
; 0001 0077     lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0001 0078 }
	RET
; .FEND
;#include <headers.h>
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
;
;
;void question1(void){
; 0002 0004 void question1(void){

	.CSEG
_question1:
; .FSTART _question1
; 0002 0005     char *str = "Ghazale Zehtab";
; 0002 0006     char *std_num = "9629163";
; 0002 0007     lcd_init(16);
	CALL __SAVELOCR4
;	*str -> R16,R17
;	*std_num -> R18,R19
	__POINTWRMN 16,17,_0x40003,0
	__POINTWRMN 18,19,_0x40003,15
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0002 0008     lcd_puts(str);
	MOVW R26,R16
	CALL SUBOPT_0x0
; 0002 0009     lcd_gotoxy(0,1);
; 0002 000A     lcd_puts(std_num);
	MOVW R26,R18
	CALL SUBOPT_0x1
; 0002 000B     delay_ms(2000);
; 0002 000C     lcd_clear();
; 0002 000D }
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND

	.DSEG
_0x40003:
	.BYTE 0x17
;
;void question2 (void){
; 0002 000F void question2 (void){

	.CSEG
_question2:
; .FSTART _question2
; 0002 0010 
; 0002 0011     char pat[57] = "Welcome to the online lab classes due to Corona disease.";
; 0002 0012     unsigned int i=0;
; 0002 0013     unsigned int j=0;
; 0002 0014     unsigned int k=0;
; 0002 0015     lcd_init(16);
	SBIW R28,57
	LDI  R24,57
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x40004*2)
	LDI  R31,HIGH(_0x40004*2)
	CALL __INITLOCB
	CALL __SAVELOCR6
;	pat -> Y+6
;	i -> R16,R17
;	j -> R18,R19
;	k -> R20,R21
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	CALL SUBOPT_0x2
; 0002 0016     lcd_clear();
; 0002 0017     lcd_gotoxy(0,0);
; 0002 0018     for(i=0;i<56;i++) {
	__GETWRN 16,17,0
_0x40006:
	__CPWRN 16,17,56
	BRSH _0x40007
; 0002 0019         lcd_clear();
	CALL SUBOPT_0x3
; 0002 001A         lcd_gotoxy(0,0);
; 0002 001B         k= i+16;
	MOVW R30,R16
	ADIW R30,16
	MOVW R20,R30
; 0002 001C         if(i+16>=56){
	MOVW R26,R16
	ADIW R26,16
	SBIW R26,56
	BRLO _0x40008
; 0002 001D           k= 56-i-1;
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	SUB  R30,R16
	SBC  R31,R17
	SBIW R30,1
	MOVW R20,R30
; 0002 001E         }
; 0002 001F         for (j=i;j<k;j++){
_0x40008:
	MOVW R18,R16
_0x4000A:
	__CPWRR 18,19,20,21
	BRSH _0x4000B
; 0002 0020           lcd_putchar(pat[j]);
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R18
	ADC  R27,R19
	LD   R26,X
	CALL _lcd_putchar
; 0002 0021         }
	__ADDWRN 18,19,1
	RJMP _0x4000A
_0x4000B:
; 0002 0022         delay_ms(120);
	LDI  R26,LOW(120)
	LDI  R27,0
	CALL _delay_ms
; 0002 0023     }
	__ADDWRN 16,17,1
	RJMP _0x40006
_0x40007:
; 0002 0024 
; 0002 0025 }
	CALL __LOADLOCR6
	ADIW R28,63
	RET
; .FEND
;
;void question3(void){
; 0002 0027 void question3(void){
_question3:
; .FSTART _question3
; 0002 0028     unsigned int counter=0;
; 0002 0029     lcd_init(16);
	ST   -Y,R17
	ST   -Y,R16
;	counter -> R16,R17
	__GETWRN 16,17,0
	CALL SUBOPT_0x2
; 0002 002A     lcd_clear();
; 0002 002B     lcd_gotoxy(0,0);
; 0002 002C     lcd_puts("Q3 Starts");
	__POINTW2MN _0x4000C,0
	CALL _lcd_puts
; 0002 002D     delay_ms(1000);
	CALL SUBOPT_0x4
; 0002 002E     lcd_clear();
	CALL SUBOPT_0x3
; 0002 002F     lcd_gotoxy(0,0);
; 0002 0030     while(counter<20){
_0x4000D:
	__CPWRN 16,17,20
	BRSH _0x4000F
; 0002 0031         MyKeypad();
	RCALL _MyKeypad
; 0002 0032         counter++;
	__ADDWRN 16,17,1
; 0002 0033         delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0002 0034     }
	RJMP _0x4000D
_0x4000F:
; 0002 0035     lcd_clear();
	CALL _lcd_clear
; 0002 0036     lcd_puts("Q3 Ended");
	__POINTW2MN _0x4000C,10
	CALL SUBOPT_0x1
; 0002 0037     delay_ms(2000);
; 0002 0038     lcd_clear();
; 0002 0039 }
	RJMP _0x2040003
; .FEND

	.DSEG
_0x4000C:
	.BYTE 0x13
;
;
;void question4(void){
; 0002 003C void question4(void){

	.CSEG
_question4:
; .FSTART _question4
; 0002 003D 
; 0002 003E     lcd_clear();
	CALL _lcd_clear
; 0002 003F     lcd_puts("Q4 Starts");
	__POINTW2MN _0x40010,0
	CALL _lcd_puts
; 0002 0040     delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0002 0041     lcd_clear();
	CALL SUBOPT_0x3
; 0002 0042     lcd_gotoxy(0,0);
; 0002 0043     DDRB=0x0F;
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0002 0044     PORTB=0xF0;
	LDI  R30,LOW(240)
	OUT  0x18,R30
; 0002 0045     #asm("sei")
	sei
; 0002 0046     delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	RJMP _0x2040002
; 0002 0047 }
; .FEND

	.DSEG
_0x40010:
	.BYTE 0xA
;
;void question5(void){
; 0002 0049 void question5(void){

	.CSEG
_question5:
; .FSTART _question5
; 0002 004A 
; 0002 004B     unsigned char input1, input2;
; 0002 004C 
; 0002 004D     while(1)
	ST   -Y,R17
	ST   -Y,R16
;	input1 -> R17
;	input2 -> R16
_0x40011:
; 0002 004E     {
; 0002 004F         lcd_clear();
	CALL SUBOPT_0x3
; 0002 0050         lcd_gotoxy(0, 0);
; 0002 0051         lcd_puts("Speed??(00-50r)");
	__POINTW2MN _0x40014,0
	CALL SUBOPT_0x0
; 0002 0052         lcd_gotoxy(0, 1);
; 0002 0053         input1 = MyKeypad();
	CALL SUBOPT_0x5
; 0002 0054         input2 = MyKeypad();
; 0002 0055 
; 0002 0056         if ((input1 == '5' && input2 != '0')|| input1>'5' || input2>'9')
	CPI  R17,53
	BRNE _0x40016
	CPI  R16,48
	BRNE _0x40018
_0x40016:
	CPI  R17,54
	BRSH _0x40018
	CPI  R16,58
	BRLO _0x40015
_0x40018:
; 0002 0057         {
; 0002 0058             lcd_clear();
	CALL _lcd_clear
; 0002 0059             lcd_puts("EE");
	__POINTW2MN _0x40014,16
	CALL SUBOPT_0x6
; 0002 005A             delay_ms(2000);
; 0002 005B         }
; 0002 005C         else
	RJMP _0x4001A
_0x40015:
; 0002 005D         {
; 0002 005E             delay_ms(1000);
	CALL SUBOPT_0x4
; 0002 005F             break;
	RJMP _0x40013
; 0002 0060         }
_0x4001A:
; 0002 0061     }
	RJMP _0x40011
_0x40013:
; 0002 0062 
; 0002 0063     while(1)
_0x4001B:
; 0002 0064     {
; 0002 0065         lcd_clear();
	CALL SUBOPT_0x3
; 0002 0066         lcd_gotoxy(0, 0);
; 0002 0067         lcd_puts("Time:??(00-99s)");
	__POINTW2MN _0x40014,19
	CALL SUBOPT_0x0
; 0002 0068         lcd_gotoxy(0, 1);
; 0002 0069         input1 = MyKeypad();
	CALL SUBOPT_0x5
; 0002 006A         input2 = MyKeypad();
; 0002 006B 
; 0002 006C         if (input1>'9' || input2>'9')
	CPI  R17,58
	BRSH _0x4001F
	CPI  R16,58
	BRLO _0x4001E
_0x4001F:
; 0002 006D         {
; 0002 006E             lcd_clear();
	CALL _lcd_clear
; 0002 006F             lcd_puts("EE");
	__POINTW2MN _0x40014,35
	CALL SUBOPT_0x6
; 0002 0070             delay_ms(2000);
; 0002 0071         }
; 0002 0072         else
	RJMP _0x40021
_0x4001E:
; 0002 0073         {
; 0002 0074             delay_ms(1000);
	CALL SUBOPT_0x4
; 0002 0075             break;
	RJMP _0x4001D
; 0002 0076         }
_0x40021:
; 0002 0077     }
	RJMP _0x4001B
_0x4001D:
; 0002 0078 
; 0002 0079     while(1)
_0x40022:
; 0002 007A     {
; 0002 007B         lcd_clear();
	CALL SUBOPT_0x3
; 0002 007C         lcd_gotoxy(0, 0);
; 0002 007D         lcd_puts("Weight??(00-99F)");
	__POINTW2MN _0x40014,38
	CALL SUBOPT_0x0
; 0002 007E         lcd_gotoxy(0, 1);
; 0002 007F 
; 0002 0080 
; 0002 0081         input1 = MyKeypad();
	CALL SUBOPT_0x5
; 0002 0082         input2 = MyKeypad();
; 0002 0083 
; 0002 0084         if (input1>'9' || input2>'9')
	CPI  R17,58
	BRSH _0x40026
	CPI  R16,58
	BRLO _0x40025
_0x40026:
; 0002 0085         {
; 0002 0086             lcd_clear();
	CALL _lcd_clear
; 0002 0087             lcd_puts("EE");
	__POINTW2MN _0x40014,55
	CALL SUBOPT_0x6
; 0002 0088             delay_ms(2000);
; 0002 0089         }
; 0002 008A         else
	RJMP _0x40028
_0x40025:
; 0002 008B         {
; 0002 008C             delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0002 008D             break;
	RJMP _0x40024
; 0002 008E         }
_0x40028:
; 0002 008F     }
	RJMP _0x40022
_0x40024:
; 0002 0090 
; 0002 0091     while(1)
_0x40029:
; 0002 0092     {
; 0002 0093         lcd_clear();
	CALL SUBOPT_0x3
; 0002 0094         lcd_gotoxy(0, 0);
; 0002 0095         lcd_puts("Temp??(20-80C)");
	__POINTW2MN _0x40014,58
	CALL SUBOPT_0x0
; 0002 0096         lcd_gotoxy(0, 1);
; 0002 0097 
; 0002 0098         input1 = MyKeypad();
	CALL SUBOPT_0x5
; 0002 0099         input2 = MyKeypad();
; 0002 009A 
; 0002 009B         if ((input1 == '8' && input2 != '0') || input1<'2' || input1>'8' || input2>'9')
	CPI  R17,56
	BRNE _0x4002D
	CPI  R16,48
	BRNE _0x4002F
_0x4002D:
	CPI  R17,50
	BRLO _0x4002F
	CPI  R17,57
	BRSH _0x4002F
	CPI  R16,58
	BRLO _0x4002C
_0x4002F:
; 0002 009C         {
; 0002 009D             lcd_clear();
	CALL _lcd_clear
; 0002 009E             lcd_puts("EE");
	__POINTW2MN _0x40014,73
	CALL SUBOPT_0x6
; 0002 009F             delay_ms(2000);
; 0002 00A0         }
; 0002 00A1         else
	RJMP _0x40031
_0x4002C:
; 0002 00A2         {
; 0002 00A3             delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0002 00A4             break;
	RJMP _0x4002B
; 0002 00A5         }
_0x40031:
; 0002 00A6     }
	RJMP _0x40029
_0x4002B:
; 0002 00A7 }
_0x2040003:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND

	.DSEG
_0x40014:
	.BYTE 0x4C
;
;void question6(void){
; 0002 00A9 void question6(void){

	.CSEG
_question6:
; .FSTART _question6
; 0002 00AA     lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0002 00AB     question1();
	RCALL _question1
; 0002 00AC     question2();
	RCALL _question2
; 0002 00AD     question3();
	RCALL _question3
; 0002 00AE     question4();
	RCALL _question4
; 0002 00AF     question5();
	RCALL _question5
; 0002 00B0     lcd_clear();
	CALL _lcd_clear
; 0002 00B1     lcd_puts("The End");
	__POINTW2MN _0x40032,0
	CALL _lcd_puts
; 0002 00B2     delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
_0x2040002:
	CALL _delay_ms
; 0002 00B3 }
	RET
; .FEND

	.DSEG
_0x40032:
	.BYTE 0x8
;#include <headers.h>
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
;unsigned char MyKeypad(void){
; 0003 0002 unsigned char MyKeypad(void){

	.CSEG
_MyKeypad:
; .FSTART _MyKeypad
; 0003 0003     DDRB=0xF0;
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0003 0004     PORTB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0003 0005         do{
_0x60004:
; 0003 0006             PORTB &= 0x0F; //ground all rows at once
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	CALL SUBOPT_0x7
; 0003 0007             colloc = (PINB & 0x0F) ;//read the columns
; 0003 0008         } while(colloc != 0x0F);//check until all keys released
	LDS  R26,_colloc
	CPI  R26,LOW(0xF)
	BRNE _0x60004
; 0003 0009 
; 0003 000A         do
_0x60007:
; 0003 000B         {
; 0003 000C             do
_0x6000A:
; 0003 000D             {
; 0003 000E                 delay_ms(20);
	CALL SUBOPT_0x8
; 0003 000F                 colloc = (PINB & 0x0F);//check if any key is pressed
; 0003 0010             }while(colloc == 0x0F);
	LDS  R26,_colloc
	CPI  R26,LOW(0xF)
	BREQ _0x6000A
; 0003 0011             delay_ms(20);
	CALL SUBOPT_0x8
; 0003 0012             colloc = (PINB & 0x0F);
; 0003 0013         }while(colloc == 0x0F);
	LDS  R26,_colloc
	CPI  R26,LOW(0xF)
	BREQ _0x60007
; 0003 0014 
; 0003 0015         while(1){
_0x6000C:
; 0003 0016             PORTB=0xEF;//ground row 0
	LDI  R30,LOW(239)
	CALL SUBOPT_0x7
; 0003 0017             colloc = (PINB & 0x0F);//read all columns
; 0003 0018             if(colloc != 0x0F){ //we konw column here
	LDS  R26,_colloc
	CPI  R26,LOW(0xF)
	BREQ _0x6000F
; 0003 0019                 rowloc=0;
	LDI  R30,LOW(0)
	STS  _rowloc,R30
; 0003 001A                 break;
	RJMP _0x6000E
; 0003 001B             }
; 0003 001C 
; 0003 001D             PORTB=0xDF;//ground row 1
_0x6000F:
	LDI  R30,LOW(223)
	CALL SUBOPT_0x7
; 0003 001E             colloc = (PINB & 0x0F);//read all columns
; 0003 001F             if(colloc != 0x0F){ //we konw column here
	LDS  R26,_colloc
	CPI  R26,LOW(0xF)
	BREQ _0x60010
; 0003 0020                 rowloc=1;
	LDI  R30,LOW(1)
	STS  _rowloc,R30
; 0003 0021                 break;
	RJMP _0x6000E
; 0003 0022             }
; 0003 0023 
; 0003 0024             PORTB=0xBF;//ground row 2
_0x60010:
	LDI  R30,LOW(191)
	CALL SUBOPT_0x7
; 0003 0025             colloc = (PINB & 0x0F);//read all columns
; 0003 0026             if(colloc != 0x0F){ //we konw column here
	LDS  R26,_colloc
	CPI  R26,LOW(0xF)
	BREQ _0x60011
; 0003 0027                 rowloc=2;
	LDI  R30,LOW(2)
	STS  _rowloc,R30
; 0003 0028                 break;
	RJMP _0x6000E
; 0003 0029             }
; 0003 002A 
; 0003 002B             PORTB=0x7F;//ground row 3
_0x60011:
	LDI  R30,LOW(127)
	CALL SUBOPT_0x7
; 0003 002C             colloc = (PINB & 0x0F);//read all columns
; 0003 002D             if(colloc != 0x0F){ //we konw column here
	LDS  R26,_colloc
	CPI  R26,LOW(0xF)
	BREQ _0x60012
; 0003 002E                 rowloc=3;
	LDI  R30,LOW(3)
	STS  _rowloc,R30
; 0003 002F                 break;
	RJMP _0x6000E
; 0003 0030             }
; 0003 0031         }
_0x60012:
	RJMP _0x6000C
_0x6000E:
; 0003 0032 
; 0003 0033         //check column and send result to LCD
; 0003 0034 
; 0003 0035         if (colloc == 0x0E){
	LDS  R26,_colloc
	CPI  R26,LOW(0xE)
	BRNE _0x60013
; 0003 0036             lcd_putchar(data_key [rowloc][0] );
	CALL SUBOPT_0x9
	LD   R26,X
	RCALL _lcd_putchar
; 0003 0037             return (data_key [rowloc][0]);
	CALL SUBOPT_0x9
	LD   R30,X
	RET
; 0003 0038             }
; 0003 0039         else if (colloc == 0x0D){
_0x60013:
	LDS  R26,_colloc
	CPI  R26,LOW(0xD)
	BRNE _0x60015
; 0003 003A             lcd_putchar(data_key [rowloc][1] );
	CALL SUBOPT_0xA
	LDD  R26,Z+1
	CALL SUBOPT_0xB
; 0003 003B             return(data_key [rowloc][1] );
	LDD  R30,Z+1
	RET
; 0003 003C             }
; 0003 003D         else if (colloc == 0x0B){
_0x60015:
	LDS  R26,_colloc
	CPI  R26,LOW(0xB)
	BRNE _0x60017
; 0003 003E             lcd_putchar(data_key [rowloc][2] );
	CALL SUBOPT_0xA
	LDD  R26,Z+2
	CALL SUBOPT_0xB
; 0003 003F             return (data_key [rowloc][2]);
	LDD  R30,Z+2
	RET
; 0003 0040             }
; 0003 0041         else {
_0x60017:
; 0003 0042             lcd_putchar(data_key [rowloc][3] );
	CALL SUBOPT_0xA
	LDD  R26,Z+3
	CALL SUBOPT_0xB
; 0003 0043             return (data_key [rowloc][3]);
	LDD  R30,Z+3
	RET
; 0003 0044             }
; 0003 0045 }
	RET
; .FEND
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

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x2040001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2040001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R5,Y+1
	LDD  R4,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0xC
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0xC
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R5,R7
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x2040001
_0x2000007:
_0x2000004:
	INC  R5
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2040001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0xD
	CALL SUBOPT_0xD
	CALL SUBOPT_0xD
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2040001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.DSEG
_data_key:
	.BYTE 0x10
_colloc:
	.BYTE 0x1
_rowloc:
	.BYTE 0x1
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x0:
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	CALL _lcd_puts
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
	JMP  _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(16)
	CALL _lcd_init
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x3:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	CALL _MyKeypad
	MOV  R17,R30
	CALL _MyKeypad
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	CALL _lcd_puts
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7:
	OUT  0x18,R30
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	STS  _colloc,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	STS  _colloc,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	LDS  R30,_rowloc
	LDI  R26,LOW(_data_key)
	LDI  R27,HIGH(_data_key)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0xA:
	LDS  R30,_rowloc
	LDI  R26,LOW(_data_key)
	LDI  R27,HIGH(_data_key)
	LDI  R31,0
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	CALL _lcd_putchar
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
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

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
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
