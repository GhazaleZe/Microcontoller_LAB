
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
; * s02.c
; *
; * Created: 10/5/2020 8:56:50 PM
; * Author: Ghazaleh Zehtab
; * Subject: Working with header files
; * Each question has its own header and source file named questionx.
; * In question6.c all other files are called and this function called is main.
; */
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
;    };

	.DSEG
;void main(void)
; 0000 001C {

	.CSEG
_main:
; .FSTART _main
; 0000 001D 
; 0000 001E     // Please write your application code here
; 0000 001F    CallAll(); //question6
	CALL _CallAll
; 0000 0020 }
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
;//question 1
;void LED_ON_OFF(unsigned int NumberOfOn,char OutPort,unsigned int timer){
; 0001 0003 void LED_ON_OFF(unsigned int NumberOfOn,char OutPort,unsigned int timer){

	.CSEG
_LED_ON_OFF:
; .FSTART _LED_ON_OFF
; 0001 0004 
; 0001 0005     unsigned int i; //integer as counter
; 0001 0006     switch(OutPort){
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	NumberOfOn -> Y+5
;	OutPort -> Y+4
;	timer -> Y+2
;	i -> R16,R17
	LDD  R30,Y+4
	LDI  R31,0
; 0001 0007 
; 0001 0008         case 0:
	SBIW R30,0
	BRNE _0x20006
; 0001 0009             DDRA=0xFF;       // define port A as output
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0001 000A             for(i=0;i<NumberOfOn;i++)
	__GETWRN 16,17,0
_0x20008:
	CALL SUBOPT_0x0
	BRSH _0x20009
; 0001 000B             {
; 0001 000C                 PORTA=0xFF;      //turn on all portA
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0001 000D                 delay_ms(timer);  //delay
	CALL SUBOPT_0x1
; 0001 000E                 PORTA=0x00;     //turn off the portA
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0001 000F                 delay_ms(timer);
	CALL SUBOPT_0x1
; 0001 0010             }
	__ADDWRN 16,17,1
	RJMP _0x20008
_0x20009:
; 0001 0011 
; 0001 0012         case 1:
	RJMP _0x2000A
_0x20006:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2000B
_0x2000A:
; 0001 0013             DDRB=0xFF;       // define port B as output
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0001 0014             for(i=0;i<NumberOfOn;i++)
	__GETWRN 16,17,0
_0x2000D:
	CALL SUBOPT_0x0
	BRSH _0x2000E
; 0001 0015             {
; 0001 0016                 PORTB=0xFF;      //turn on all portB
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0001 0017                 delay_ms(timer);  //delay
	CALL SUBOPT_0x1
; 0001 0018                 PORTB=0x00;     //turn off the portB
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0001 0019                 delay_ms(timer);
	CALL SUBOPT_0x1
; 0001 001A             }
	__ADDWRN 16,17,1
	RJMP _0x2000D
_0x2000E:
; 0001 001B         case 2:
	RJMP _0x2000F
_0x2000B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20010
_0x2000F:
; 0001 001C             DDRC=0xFF;       // define port C as output
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0001 001D             for(i=0;i<NumberOfOn;i++)
	__GETWRN 16,17,0
_0x20012:
	CALL SUBOPT_0x0
	BRSH _0x20013
; 0001 001E             {
; 0001 001F                 PORTC=0xFF;      //turn on all portC
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0001 0020                 delay_ms(timer);  //delay
	CALL SUBOPT_0x1
; 0001 0021                 PORTC=0x00;     //turn off the portC
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0001 0022                 delay_ms(timer);
	CALL SUBOPT_0x1
; 0001 0023             }
	__ADDWRN 16,17,1
	RJMP _0x20012
_0x20013:
; 0001 0024         case 3:
	RJMP _0x20014
_0x20010:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20019
_0x20014:
; 0001 0025             DDRD=0xFF;       // define port D as output
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0001 0026             for(i=0;i<NumberOfOn;i++)
	__GETWRN 16,17,0
_0x20017:
	CALL SUBOPT_0x0
	BRSH _0x20018
; 0001 0027             {
; 0001 0028                 PORTD=0xFF;      //turn on all portD
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0001 0029                 delay_ms(timer);  //delay
	CALL SUBOPT_0x1
; 0001 002A                 PORTD=0x00;     //turn off the portD
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0001 002B                 delay_ms(timer);
	CALL SUBOPT_0x1
; 0001 002C             }
	__ADDWRN 16,17,1
	RJMP _0x20017
_0x20018:
; 0001 002D         default:
_0x20019:
; 0001 002E             DDRB=0xFF;       // define port B as output
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0001 002F             for(i=0;i<NumberOfOn;i++)
	__GETWRN 16,17,0
_0x2001B:
	CALL SUBOPT_0x0
	BRSH _0x2001C
; 0001 0030             {
; 0001 0031                 PORTB=0xFF;      //turn on all portB
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0001 0032                 delay_ms(timer);  //delay
	CALL SUBOPT_0x1
; 0001 0033                 PORTB=0x00;     //turn off the portB
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0001 0034                 delay_ms(timer);
	CALL SUBOPT_0x1
; 0001 0035             }
	__ADDWRN 16,17,1
	RJMP _0x2001B
_0x2001C:
; 0001 0036     }
; 0001 0037 
; 0001 0038 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
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
;//question2
;
;void DancingLight(unsigned int StartPoint,unsigned int timer){
; 0002 0005 void DancingLight(unsigned int StartPoint,unsigned int timer){

	.CSEG
_DancingLight:
; .FSTART _DancingLight
; 0002 0006 
; 0002 0007     unsigned int i; //integer as counter
; 0002 0008     unsigned int j;
; 0002 0009     unsigned int num;
; 0002 000A     num=1;
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR6
;	StartPoint -> Y+8
;	timer -> Y+6
;	i -> R16,R17
;	j -> R18,R19
;	num -> R20,R21
	__GETWRN 20,21,1
; 0002 000B     DDRB=0xFF;       // define port B as output
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0002 000C     timer /= 20;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL __DIVW21U
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0002 000D     for(j=0;j<StartPoint;j++){
	__GETWRN 18,19,0
_0x40004:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CP   R18,R30
	CPC  R19,R31
	BRSH _0x40005
; 0002 000E         num=num*2;
	CALL SUBOPT_0x2
; 0002 000F     }
	__ADDWRN 18,19,1
	RJMP _0x40004
_0x40005:
; 0002 0010     for(i=0;i<20;i++)
	__GETWRN 16,17,0
_0x40007:
	__CPWRN 16,17,20
	BRSH _0x40008
; 0002 0011     {
; 0002 0012        PORTB=num;      //turn on all portB
	OUT  0x18,R20
; 0002 0013        delay_ms(timer);
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL _delay_ms
; 0002 0014        num = num * 2;    // turn on next LED
	CALL SUBOPT_0x2
; 0002 0015        if (num > 128){    //if last on in ON back to the beginig
	__CPWRN 20,21,129
	BRLO _0x40009
; 0002 0016         num= 1;
	__GETWRN 20,21,1
; 0002 0017        }
; 0002 0018     }
_0x40009:
	__ADDWRN 16,17,1
	RJMP _0x40007
_0x40008:
; 0002 0019 }
	CALL __LOADLOCR6
	ADIW R28,10
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
;void DiplayPortx_onLEDs(unsigned int inport, unsigned int outport){
; 0003 0003 void DiplayPortx_onLEDs(unsigned int inport, unsigned int outport){

	.CSEG
_DiplayPortx_onLEDs:
; .FSTART _DiplayPortx_onLEDs
; 0003 0004 
; 0003 0005     unsigned int Myinport=0;
; 0003 0006     unsigned int p=0;
; 0003 0007     switch(inport){
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	inport -> Y+6
;	outport -> Y+4
;	Myinport -> R16,R17
;	p -> R18,R19
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	LDD  R30,Y+6
	LDD  R31,Y+6+1
; 0003 0008 
; 0003 0009         case 0:
	SBIW R30,0
	BRNE _0x60006
; 0003 000A             DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0003 000B             Myinport = PINA;
	IN   R16,25
	RJMP _0x60022
; 0003 000C             break;
; 0003 000D 
; 0003 000E         case 1:
_0x60006:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ _0x60023
; 0003 000F 
; 0003 0010             DDRB=0x00;       // define port B as input
; 0003 0011             Myinport = PINB;
; 0003 0012             break;
; 0003 0013 
; 0003 0014         case 2:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x60008
; 0003 0015             DDRC=0x00;       // define port C as output
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0003 0016             Myinport = PINC;
	IN   R16,19
	RJMP _0x60022
; 0003 0017             break;
; 0003 0018 
; 0003 0019         case 3:
_0x60008:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x6000A
; 0003 001A             DDRD=0x00;       // define port D as output
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0003 001B             Myinport = PIND;
	IN   R16,16
	RJMP _0x60022
; 0003 001C             break;
; 0003 001D         default:
_0x6000A:
; 0003 001E 
; 0003 001F             DDRB=0x00;       // define port B as output
_0x60023:
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0003 0020             Myinport=PINB;
	IN   R16,22
_0x60022:
	CLR  R17
; 0003 0021             break;
; 0003 0022     }
; 0003 0023     switch(outport){
	LDD  R30,Y+4
	LDD  R31,Y+4+1
; 0003 0024 
; 0003 0025         case 0:
	SBIW R30,0
	BRNE _0x6000E
; 0003 0026             DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0003 0027             while(p<3000){
_0x6000F:
	__CPWRN 18,19,3000
	BRSH _0x60011
; 0003 0028                 PORTA=Myinport;
	OUT  0x1B,R16
; 0003 0029                 p++;
	CALL SUBOPT_0x3
; 0003 002A                 delay_ms(1);
; 0003 002B             }
	RJMP _0x6000F
_0x60011:
; 0003 002C             p=0;
	__GETWRN 18,19,0
; 0003 002D             break;
	RJMP _0x6000D
; 0003 002E         case 1:
_0x6000E:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x60012
; 0003 002F             DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0003 0030             while(p<3000){
_0x60013:
	__CPWRN 18,19,3000
	BRSH _0x60015
; 0003 0031                 PORTB=Myinport;
	OUT  0x18,R16
; 0003 0032                 p++;
	CALL SUBOPT_0x3
; 0003 0033                 delay_ms(1);
; 0003 0034             }
	RJMP _0x60013
_0x60015:
; 0003 0035             break;
	RJMP _0x6000D
; 0003 0036         case 2:
_0x60012:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x60016
; 0003 0037             DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0003 0038             while(p<3000){
_0x60017:
	__CPWRN 18,19,3000
	BRSH _0x60019
; 0003 0039                 PORTC=Myinport;
	OUT  0x15,R16
; 0003 003A                 p++;
	CALL SUBOPT_0x3
; 0003 003B                 delay_ms(1);
; 0003 003C             }
	RJMP _0x60017
_0x60019:
; 0003 003D             break;
	RJMP _0x6000D
; 0003 003E         case 3:
_0x60016:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x6001E
; 0003 003F             DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0003 0040             while(p<3000){
_0x6001B:
	__CPWRN 18,19,3000
	BRSH _0x6001D
; 0003 0041                 PORTD=Myinport;
	OUT  0x12,R16
; 0003 0042                 p++;
	CALL SUBOPT_0x3
; 0003 0043                 delay_ms(1);
; 0003 0044             }
	RJMP _0x6001B
_0x6001D:
; 0003 0045             break;
	RJMP _0x6000D
; 0003 0046         default:
_0x6001E:
; 0003 0047             DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0003 0048             while(p<3000){
_0x6001F:
	__CPWRN 18,19,3000
	BRSH _0x60021
; 0003 0049                 PORTB=Myinport;
	OUT  0x18,R16
; 0003 004A                 p++;
	CALL SUBOPT_0x3
; 0003 004B                 delay_ms(1);
; 0003 004C             }
	RJMP _0x6001F
_0x60021:
; 0003 004D             break;
; 0003 004E     }
_0x6000D:
; 0003 004F }
	CALL __LOADLOCR4
	ADIW R28,8
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
;//when AcOrDec is 1 means nine to zero when it's 0 mean zero to 1
;
;void  NineToZero(unsigned int descent){
; 0004 0005 void  NineToZero(unsigned int descent){

	.CSEG
_NineToZero:
; .FSTART _NineToZero
; 0004 0006     if(descent==0){
	ST   -Y,R27
	ST   -Y,R26
;	descent -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x80003
; 0004 0007         DDRC=0xFF;
	CALL SUBOPT_0x4
; 0004 0008         DDRD=0x0F;
; 0004 0009         DDRD.0=1;
; 0004 000A         DDRD.1=1;
; 0004 000B         DDRD.2=1;
; 0004 000C         DDRD.3=1;
; 0004 000D         PORTC=0b00111111;    //0
	LDI  R30,LOW(63)
	CALL SUBOPT_0x5
; 0004 000E         delay_ms(500);
; 0004 000F         PORTC=0b00000110;    //1
	LDI  R30,LOW(6)
	CALL SUBOPT_0x5
; 0004 0010         delay_ms(500);
; 0004 0011         PORTC=0b01011011;    //2
	LDI  R30,LOW(91)
	CALL SUBOPT_0x5
; 0004 0012         delay_ms(500);
; 0004 0013         PORTC=0b01001111;   //3
	LDI  R30,LOW(79)
	CALL SUBOPT_0x5
; 0004 0014         delay_ms(500);
; 0004 0015         PORTC=0b01100110;   //4
	LDI  R30,LOW(102)
	CALL SUBOPT_0x5
; 0004 0016         delay_ms(500);
; 0004 0017         PORTC=0b01101101;    //5
	LDI  R30,LOW(109)
	CALL SUBOPT_0x5
; 0004 0018         delay_ms(500);
; 0004 0019         PORTC=0b01111101;   //6
	LDI  R30,LOW(125)
	CALL SUBOPT_0x5
; 0004 001A         delay_ms(500);
; 0004 001B         PORTC=0b0000111;   //7
	LDI  R30,LOW(7)
	CALL SUBOPT_0x5
; 0004 001C         delay_ms(500);
; 0004 001D         PORTC=0b01111111;    //8
	LDI  R30,LOW(127)
	CALL SUBOPT_0x5
; 0004 001E         delay_ms(500);
; 0004 001F         PORTC=0b01101111; //9
	LDI  R30,LOW(111)
	RJMP _0x80015
; 0004 0020         delay_ms(500);
; 0004 0021     }
; 0004 0022     else  {
_0x80003:
; 0004 0023         DDRC=0xFF;
	CALL SUBOPT_0x4
; 0004 0024         DDRD=0x0F;
; 0004 0025         DDRD.0=1;
; 0004 0026         DDRD.1=1;
; 0004 0027         DDRD.2=1;
; 0004 0028         DDRD.3=1;
; 0004 0029         PORTC=0b01101111; //9
	LDI  R30,LOW(111)
	CALL SUBOPT_0x5
; 0004 002A         delay_ms(500);
; 0004 002B         PORTC=0b01111111;    //8
	LDI  R30,LOW(127)
	CALL SUBOPT_0x5
; 0004 002C         delay_ms(500);
; 0004 002D         PORTC=0b0000111;   //7
	LDI  R30,LOW(7)
	CALL SUBOPT_0x5
; 0004 002E         delay_ms(500);
; 0004 002F         PORTC=0b01111101;   //6
	LDI  R30,LOW(125)
	CALL SUBOPT_0x5
; 0004 0030         delay_ms(500);
; 0004 0031         PORTC=0b01101101;    //5
	LDI  R30,LOW(109)
	CALL SUBOPT_0x5
; 0004 0032         delay_ms(500);
; 0004 0033         PORTC=0b01100110;   //4
	LDI  R30,LOW(102)
	CALL SUBOPT_0x5
; 0004 0034         delay_ms(500);
; 0004 0035         PORTC=0b01001111;   //3
	LDI  R30,LOW(79)
	CALL SUBOPT_0x5
; 0004 0036         delay_ms(500);
; 0004 0037         PORTC=0b01011011;    //2
	LDI  R30,LOW(91)
	CALL SUBOPT_0x5
; 0004 0038         delay_ms(500);
; 0004 0039         PORTC=0b00000110;    //1
	LDI  R30,LOW(6)
	CALL SUBOPT_0x5
; 0004 003A         delay_ms(500);
; 0004 003B         PORTC=0b00111111;    //0
	LDI  R30,LOW(63)
_0x80015:
	OUT  0x15,R30
; 0004 003C         delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0004 003D     }
; 0004 003E }
	ADIW R28,2
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
;void Reduce(float reducer){
; 0005 0003 void Reduce(float reducer){

	.CSEG
_Reduce:
; .FSTART _Reduce
; 0005 0004     unsigned int number=0;
; 0005 0005     unsigned int numberCopy=0;
; 0005 0006     unsigned int FirstDigit=0;
; 0005 0007     unsigned int SecondDigit=0;
; 0005 0008     unsigned int ThirdDigit=0;
; 0005 0009     unsigned int Deci=0;        // after point
; 0005 000A     DDRA=0x00;
	CALL __PUTPARD2
	SBIW R28,6
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	STD  Y+5,R30
	CALL __SAVELOCR6
;	reducer -> Y+12
;	number -> R16,R17
;	numberCopy -> R18,R19
;	FirstDigit -> R20,R21
;	SecondDigit -> Y+10
;	ThirdDigit -> Y+8
;	Deci -> Y+6
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	OUT  0x1A,R30
; 0005 000B     DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0005 000C     DDRD=0x00;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0005 000D     number= PINA;
	IN   R16,25
	CLR  R17
; 0005 000E     numberCopy = number  *10;   //FOR making decimal easier
	__MULBNWRU 16,17,10
	MOVW R18,R30
; 0005 000F     reducer *=10;
	__GETD2S 12
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 12
; 0005 0010     while(numberCopy>0){
_0xA0003:
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRSH _0xA0005
; 0005 0011         delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0005 0012         number=numberCopy;
	MOVW R16,R18
; 0005 0013         Deci=number%10;
	RCALL SUBOPT_0x6
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0005 0014         number= number /10;
	RCALL SUBOPT_0x7
; 0005 0015         FirstDigit=number%10;
	MOVW R20,R30
; 0005 0016         number= number /10;
	RCALL SUBOPT_0x7
; 0005 0017         SecondDigit = number %10;
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0005 0018         number= number /10;
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOVW R16,R30
; 0005 0019         ThirdDigit= number;
	__PUTWSR 16,17,8
; 0005 001A         DDRD.2=1;
	SBI  0x11,2
; 0005 001B         PORTC= sevenseg[FirstDigit]+ 0b10000000;   //point on
	LDI  R26,LOW(_sevenseg)
	LDI  R27,HIGH(_sevenseg)
	ADD  R26,R20
	ADC  R27,R21
	LD   R30,X
	SUBI R30,-LOW(128)
	RCALL SUBOPT_0x8
; 0005 001C         delay_ms(1);
; 0005 001D         DDRD.2=0;
	CBI  0x11,2
; 0005 001E         DDRD.1=1;
	SBI  0x11,1
; 0005 001F         PORTC= sevenseg[SecondDigit];
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL SUBOPT_0x9
; 0005 0020         delay_ms(1);
; 0005 0021         DDRD.1=0;
	CBI  0x11,1
; 0005 0022         DDRD.0=1;
	SBI  0x11,0
; 0005 0023         PORTC= sevenseg[ThirdDigit];
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RCALL SUBOPT_0x9
; 0005 0024         delay_ms(1);
; 0005 0025         DDRD.0=0;
	CBI  0x11,0
; 0005 0026         DDRD.3=1;
	SBI  0x11,3
; 0005 0027         PORTC= sevenseg[Deci];
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL SUBOPT_0x9
; 0005 0028         delay_ms(1);
; 0005 0029         DDRD.3=0;
	CBI  0x11,3
; 0005 002A         numberCopy = numberCopy - reducer ;
	__GETD1S 12
	MOVW R26,R18
	CLR  R24
	CLR  R25
	CALL __CDF2
	CALL __SWAPD12
	CALL __SUBF12
	CALL __CFD1U
	MOVW R18,R30
; 0005 002B         //delay_ms(200);
; 0005 002C 
; 0005 002D 
; 0005 002E 
; 0005 002F     }
	RJMP _0xA0003
_0xA0005:
; 0005 0030 }
	CALL __LOADLOCR6
	ADIW R28,16
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
;void CallAll(void){
; 0006 0002 void CallAll(void){

	.CSEG
_CallAll:
; .FSTART _CallAll
; 0006 0003     LED_ON_OFF(5,myPORTB,500); //question1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _LED_ON_OFF
; 0006 0004     DancingLight(2,5000);    //question2
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	CALL _DancingLight
; 0006 0005     DiplayPortx_onLEDs(0 , 1);  //question3
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _DiplayPortx_onLEDs
; 0006 0006     NineToZero(0); //question4
	LDI  R26,LOW(0)
	LDI  R27,0
	CALL _NineToZero
; 0006 0007     Reduce(0.3);  //question5
	__GETD2N 0x3E99999A
	RCALL _Reduce
; 0006 0008 }
	RET
; .FEND

	.DSEG
_sevenseg:
	.BYTE 0xA

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	CP   R16,R30
	CPC  R17,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	__MULBNWRU 20,21,2
	MOVW R20,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3:
	__ADDWRN 18,19,1
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(255)
	OUT  0x14,R30
	LDI  R30,LOW(15)
	OUT  0x11,R30
	SBI  0x11,0
	SBI  0x11,1
	SBI  0x11,2
	SBI  0x11,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:48 WORDS
SUBOPT_0x5:
	OUT  0x15,R30
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOVW R16,R30
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8:
	OUT  0x15,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	SUBI R30,LOW(-_sevenseg)
	SBCI R31,HIGH(-_sevenseg)
	LD   R30,Z
	RJMP SUBOPT_0x8


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

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
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

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
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

;END OF CODE MARKER
__END_OF_CODE:
