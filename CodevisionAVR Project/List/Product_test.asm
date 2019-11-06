
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

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
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
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
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	.DEF _machine_state=R5
	.DEF _old_machine_state=R4
	.DEF _error_flag=R7
	.DEF _freq_error_flag=R6
	.DEF _i=R8
	.DEF _on_button_state=R10
	.DEF _off_button_state=R12

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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer3_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_font:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x20,0x20,0x28,0x28,0x68,0xB0,0x60,0x20
	.DB  0x20,0x20,0x28,0x2A,0x28,0x30,0x20,0x20
	.DB  0x0,0x80,0x80,0x44,0x32,0x24,0x20,0x20
	.DB  0x0,0x24,0x24,0x24,0x38,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x24,0x2A,0x11,0x0
	.DB  0x20,0x20,0x20,0x24,0x2A,0x11,0x20,0x20
	.DB  0x30,0x20,0x20,0x20,0x24,0x2A,0x11,0x20
	.DB  0x20,0x20,0x30,0x20,0x30,0x28,0x28,0x18
	.DB  0x20,0x24,0x22,0x21,0x24,0x2A,0x11,0x0
	.DB  0x24,0x22,0x21,0x24,0x2A,0x11,0x20,0x20
	.DB  0x30,0x24,0x22,0x21,0x24,0x2A,0x11,0x20
	.DB  0x0,0x80,0x80,0x40,0x30,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x60,0xA0,0x60,0x28,0x30
	.DB  0x20,0x20,0x20,0x60,0xB0,0x60,0x20,0x20
	.DB  0x0,0x30,0x28,0x60,0xA0,0x60,0x30,0x20
	.DB  0x0,0x4,0x6,0x1D,0x25,0x24,0x20,0x20
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x4F,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x7,0x0,0x7,0x0,0x0,0x0,0x0
	.DB  0x0,0x14,0x7F,0x14,0x7F,0x14,0x0,0x0
	.DB  0x0,0x24,0x2A,0x7F,0x2A,0x12,0x0,0x0
	.DB  0x0,0x23,0x13,0x8,0x64,0x62,0x0,0x0
	.DB  0x0,0x36,0x49,0x55,0x22,0x40,0x0,0x0
	.DB  0x0,0x0,0x5,0x3,0x0,0x0,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x0,0x0
	.DB  0x0,0x41,0x22,0x1C,0x0,0x0,0x0,0x0
	.DB  0x0,0x14,0x8,0x3E,0x8,0x14,0x0,0x0
	.DB  0x0,0x8,0x8,0x3E,0x8,0x8,0x0,0x0
	.DB  0x0,0x0,0x28,0x18,0x0,0x0,0x0,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x8,0x0
	.DB  0x0,0x30,0x30,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x20,0x10,0x8,0x4,0x2,0x0,0x0
	.DB  0x0,0x3E,0x51,0x49,0x45,0x3E,0x0,0x0
	.DB  0x0,0x0,0x42,0x7F,0x40,0x0,0x0,0x0
	.DB  0x0,0x42,0x61,0x51,0x49,0x46,0x0,0x0
	.DB  0x0,0x21,0x41,0x45,0x4B,0x31,0x0,0x0
	.DB  0x0,0x18,0x14,0x12,0x7F,0x10,0x0,0x0
	.DB  0x0,0x0,0x27,0x45,0x45,0x45,0x39,0x0
	.DB  0x0,0x3C,0x4A,0x49,0x49,0x30,0x0,0x0
	.DB  0x0,0x1,0x71,0x9,0x5,0x3,0x0,0x0
	.DB  0x0,0x36,0x49,0x49,0x49,0x36,0x0,0x0
	.DB  0x0,0x6,0x49,0x49,0x29,0x1E,0x0,0x0
	.DB  0x0,0x0,0x36,0x36,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x56,0x36,0x0,0x0,0x0,0x0
	.DB  0x0,0x8,0x14,0x22,0x41,0x0,0x0,0x0
	.DB  0x0,0x24,0x24,0x24,0x24,0x24,0x0,0x0
	.DB  0x0,0x0,0x41,0x22,0x14,0x8,0x0,0x0
	.DB  0x0,0x2,0x1,0x51,0x9,0x6,0x0,0x0
	.DB  0x0,0x32,0x49,0x79,0x41,0x3E,0x0,0x0
	.DB  0x0,0x7E,0x11,0x11,0x11,0x7E,0x0,0x0
	.DB  0x0,0x7F,0x49,0x49,0x49,0x36,0x0,0x0
	.DB  0x0,0x3E,0x41,0x41,0x41,0x22,0x0,0x0
	.DB  0x0,0x7F,0x41,0x41,0x22,0x1C,0x0,0x0
	.DB  0x0,0x7F,0x49,0x49,0x49,0x41,0x0,0x0
	.DB  0x0,0x7F,0x9,0x9,0x9,0x1,0x0,0x0
	.DB  0x0,0x3E,0x41,0x49,0x49,0x3A,0x0,0x0
	.DB  0x0,0x7F,0x8,0x8,0x8,0x7F,0x0,0x0
	.DB  0x0,0x0,0x41,0x7F,0x41,0x0,0x0,0x0
	.DB  0x0,0x20,0x40,0x41,0x3F,0x1,0x0,0x0
	.DB  0x0,0x7F,0x8,0x14,0x22,0x41,0x0,0x0
	.DB  0x0,0x7F,0x40,0x40,0x40,0x40,0x0,0x0
	.DB  0x0,0x7F,0x2,0xC,0x2,0x7F,0x0,0x0
	.DB  0x0,0x7F,0x4,0x8,0x10,0x7F,0x0,0x0
	.DB  0x0,0x3E,0x41,0x41,0x41,0x3E,0x0,0x0
	.DB  0x0,0x7F,0x9,0x9,0x9,0x6,0x0,0x0
	.DB  0x3E,0x41,0x51,0x21,0x5E,0x0,0x0,0x0
	.DB  0x0,0x7F,0x9,0x19,0x29,0x46,0x0,0x0
	.DB  0x0,0x46,0x49,0x49,0x49,0x31,0x0,0x0
	.DB  0x0,0x1,0x1,0x7F,0x1,0x1,0x0,0x0
	.DB  0x0,0x3F,0x40,0x40,0x40,0x3F,0x0,0x0
	.DB  0x0,0x1F,0x20,0x40,0x20,0x1F,0x0,0x0
	.DB  0x0,0x3F,0x40,0x60,0x40,0x3F,0x0,0x0
	.DB  0x0,0x63,0x14,0x8,0x14,0x63,0x0,0x0
	.DB  0x0,0x7,0x8,0x70,0x8,0x7,0x0,0x0
	.DB  0x0,0x61,0x51,0x49,0x45,0x43,0x0,0x0
	.DB  0x0,0x7F,0x41,0x41,0x0,0x0,0x0,0x0
	.DB  0x0,0x15,0x16,0x7C,0x16,0x15,0x0,0x0
	.DB  0x0,0x41,0x41,0x7F,0x0,0x0,0x0,0x0
	.DB  0x0,0x4,0x2,0x1,0x2,0x4,0x0,0x0
	.DB  0x0,0x40,0x40,0x40,0x40,0x40,0x0,0x0
	.DB  0x0,0x1,0x2,0x4,0x0,0x0,0x0,0x0
	.DB  0x0,0x20,0x54,0x54,0x54,0x78,0x0,0x0
	.DB  0x0,0x7F,0x44,0x44,0x44,0x38,0x0,0x0
	.DB  0x0,0x38,0x44,0x44,0x44,0x0,0x0,0x0
	.DB  0x0,0x38,0x44,0x44,0x48,0x7F,0x0,0x0
	.DB  0x0,0x38,0x54,0x54,0x54,0x18,0x0,0x0
	.DB  0x0,0x10,0x7E,0x11,0x1,0x2,0x0,0x0
	.DB  0x0,0xC,0x52,0x52,0x52,0x3E,0x0,0x0
	.DB  0x0,0x7F,0x8,0x4,0x4,0x78,0x0,0x0
	.DB  0x0,0x0,0x44,0x7D,0x40,0x0,0x0,0x0
	.DB  0x0,0x20,0x40,0x40,0x3D,0x0,0x0,0x0
	.DB  0x0,0x7F,0x10,0x28,0x44,0x0,0x0,0x0
	.DB  0x0,0x0,0x41,0x7F,0x40,0x0,0x0,0x0
	.DB  0x0,0x7C,0x4,0x18,0x4,0x78,0x0,0x0
	.DB  0x0,0x7C,0x8,0x4,0x4,0x78,0x0,0x0
	.DB  0x0,0x38,0x44,0x44,0x44,0x38,0x0,0x0
	.DB  0x0,0x7C,0x14,0x14,0x14,0x8,0x0,0x0
	.DB  0x0,0x8,0x14,0x14,0x18,0x7C,0x0,0x0
	.DB  0x0,0x7C,0x8,0x4,0x4,0x8,0x0,0x0
	.DB  0x0,0x48,0x54,0x54,0x54,0x20,0x0,0x0
	.DB  0x0,0x4,0x3F,0x44,0x40,0x20,0x0,0x0
	.DB  0x0,0x3C,0x40,0x40,0x20,0x7C,0x0,0x0
	.DB  0x0,0x1C,0x20,0x40,0x20,0x1C,0x0,0x0
	.DB  0x0,0x1E,0x20,0x10,0x20,0x1E,0x0,0x0
	.DB  0x0,0x22,0x14,0x8,0x14,0x22,0x0,0x0
	.DB  0x0,0x6,0x48,0x48,0x48,0x3E,0x0,0x0
	.DB  0x0,0x44,0x64,0x54,0x4C,0x44,0x0,0x0
	.DB  0x0,0x8,0x36,0x41,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x7F,0x0,0x0,0x0,0x0
	.DB  0x0,0x41,0x36,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x8,0x8,0x2A,0x1C,0x8,0x0,0x0
	.DB  0x0,0x8,0x1C,0x2A,0x8,0x8,0x0,0x0
	.DB  0x0,0x3C,0x42,0x41,0x42,0x3C,0x0,0x0
	.DB  0x0,0x30,0x28,0x60,0xA0,0x60,0x28,0x30
	.DB  0x20,0x20,0x20,0x20,0xA0,0x20,0x28,0x30
	.DB  0x20,0x20,0x20,0x20,0xB0,0x20,0x20,0x20
	.DB  0x0,0x30,0x28,0x20,0xA0,0x20,0x30,0x20
	.DB  0x20,0x20,0x20,0x22,0x20,0x22,0x28,0x30
	.DB  0x20,0x20,0x20,0x22,0x30,0x22,0x20,0x20
	.DB  0x0,0x30,0x28,0x22,0x20,0x22,0x30,0x20
	.DB  0x20,0x20,0x20,0x22,0x21,0x22,0x28,0x30
	.DB  0x20,0x20,0x20,0x22,0x31,0x22,0x20,0x20
	.DB  0x0,0x30,0x28,0x22,0x21,0x22,0x30,0x20
	.DB  0x20,0x20,0x28,0x28,0x28,0xB0,0x20,0x20
	.DB  0x20,0x20,0x28,0x28,0x28,0x30,0x20,0x20
	.DB  0x0,0xC0,0xA8,0x28,0x68,0xB0,0x60,0x20
	.DB  0x0,0x0,0x80,0x80,0x44,0x32,0x4,0x0
	.DB  0x0,0x24,0x25,0x24,0x38,0x20,0x20,0x20
	.DB  0x30,0x24,0x22,0x21,0x24,0x2A,0x11,0x0
	.DB  0x0,0x80,0x80,0x40,0x34,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x38,0x20,0x38,0x20,0x18
	.DB  0x20,0x20,0x38,0x20,0x38,0x20,0x38,0x20
	.DB  0x60,0x80,0x80,0x78,0x20,0x38,0x20,0x18
	.DB  0x20,0x20,0x20,0x38,0x22,0x39,0x22,0x18
	.DB  0x20,0x20,0x38,0x22,0x39,0x22,0x38,0x20
	.DB  0x60,0x80,0x80,0x78,0x22,0x39,0x22,0x18
	.DB  0x30,0x20,0x20,0x20,0x24,0x2A,0x11,0x0
	.DB  0x20,0x30,0x20,0x30,0x28,0x28,0x38,0x20
	.DB  0x60,0x80,0x80,0x60,0x30,0x28,0x28,0x38
	.DB  0x20,0x20,0x30,0x20,0x30,0x28,0x2A,0x18
	.DB  0x20,0x30,0x20,0x30,0x28,0x2A,0x38,0x20
	.DB  0x60,0x80,0x80,0x60,0x30,0x28,0x2A,0x38
	.DB  0x20,0x20,0x3E,0x30,0x28,0x28,0x38,0x20
	.DB  0x20,0x20,0x3E,0x30,0x28,0x2A,0x38,0x20
	.DB  0x20,0x20,0x20,0x20,0x30,0x28,0x28,0x0
	.DB  0x20,0x20,0x20,0x30,0x28,0x28,0x20,0x20
	.DB  0x0,0x40,0xA0,0xB0,0x28,0x28,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x30,0x28,0x2A,0x0
	.DB  0x20,0x20,0x20,0x30,0x28,0x2A,0x20,0x20
	.DB  0x0,0x40,0xA0,0xB0,0x28,0x2A,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x30,0x28,0x2A,0x30
	.DB  0x20,0x20,0x30,0x28,0x2A,0x30,0x20,0x20
	.DB  0x0,0x18,0x20,0x20,0x30,0x28,0x2A,0x30
	.DB  0x20,0x20,0x20,0x20,0x30,0x2A,0x28,0x32
	.DB  0x20,0x20,0x30,0x2A,0x28,0x32,0x20,0x20
	.DB  0x60,0x80,0x80,0xB2,0xA8,0x7A,0x20,0x20
	.DB  0x22,0x25,0x25,0x25,0x25,0x25,0x25,0x19
	.DB  0x20,0x20,0x20,0x1C,0x22,0x21,0x20,0x20
	.DB  0x30,0x28,0x2C,0x2A,0x20,0x3F,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x1F,0x0
	.DB  0x20,0x20,0x20,0x20,0x1F,0x20,0x20,0x20
	.DB  0x0,0x30,0x40,0x40,0x3F,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x30,0x48,0x48,0x30
	.DB  0x20,0x20,0x30,0x48,0x48,0x30,0x20,0x20
	.DB  0x80,0x40,0x30,0x48,0x48,0x30,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x22,0x20,0x18,0x0
	.DB  0x20,0x20,0x20,0x20,0x1A,0x20,0x20,0x20
	.DB  0x30,0x40,0x44,0x40,0x30,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x30,0x28,0x3A,0x2C,0x18
	.DB  0x20,0x20,0x30,0x28,0x3A,0x2C,0x38,0x20
	.DB  0x0,0x18,0x14,0x14,0x18,0x20,0x20,0x20
	.DB  0x0,0x21,0x22,0x24,0x28,0x10,0xF,0x0
	.DB  0x0,0xB0,0xA8,0x78,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0xA0,0x20,0xA0,0x28,0x30
	.DB  0x20,0x20,0x20,0xA0,0x30,0xA0,0x20,0x20
	.DB  0x0,0x60,0x80,0x80,0xA0,0x50,0x10,0x20
	.DB  0x0,0x1E,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x30,0x28,0x28,0x20,0x0,0x0
	.DB  0x0,0x4,0x2,0x2,0x3A,0x2,0x2,0x1
	.DB  0x0,0x0,0x4,0x6,0x3D,0x5,0x4,0x0
	.DB  0x0,0x0,0x4,0xB6,0xAD,0x7D,0x4,0x0
	.DB  0x0,0x0,0x80,0xC0,0xBF,0xA0,0x80,0x0
	.DB  0x4,0x66,0x85,0x95,0xA8,0xA8,0x48,0x0
	.DB  0x0,0x0,0x0,0x3F,0x0,0x0,0x0,0x0
	.DB  0x0,0x30,0x28,0x20,0xA0,0x20,0x28,0x30
	.DB  0x0,0x0,0x30,0x2A,0x28,0x32,0x0,0x0
	.DB  0x0,0x30,0x28,0x22,0x20,0x22,0x28,0x30
	.DB  0x0,0x30,0x28,0x22,0x21,0x22,0x28,0x30
	.DB  0x0,0xC0,0xA8,0xA8,0x28,0xB0,0x20,0x20
	.DB  0x0,0xC0,0xA8,0xA8,0xA8,0x30,0x20,0x20
	.DB  0x0,0xC0,0xA8,0xAA,0x28,0x30,0x20,0x20
	.DB  0x0,0x0,0x24,0x24,0x24,0x38,0x0,0x0
	.DB  0x0,0x0,0x24,0x25,0x24,0x38,0x0,0x0
	.DB  0x0,0x80,0x80,0x40,0x30,0x0,0x0,0x0
	.DB  0x0,0x0,0x80,0x80,0x40,0x34,0x0,0x0
	.DB  0x60,0x80,0x80,0x78,0x20,0x38,0x20,0x18
	.DB  0x60,0x80,0x80,0x78,0x22,0x39,0x22,0x18
	.DB  0x60,0x80,0x80,0x60,0x30,0x28,0x28,0x18
	.DB  0x60,0x80,0x80,0x60,0x30,0x28,0x2A,0x18
	.DB  0x0,0x22,0x14,0x8,0x14,0x22,0x0,0x0
	.DB  0x20,0x20,0x3E,0x30,0x28,0x28,0x18,0x0
	.DB  0x20,0x20,0x3E,0x30,0x28,0x2A,0x18,0x0
	.DB  0x0,0x0,0x40,0xA0,0xB0,0x28,0x28,0x0
	.DB  0x0,0x0,0x40,0xA0,0xB0,0x2A,0x28,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x18,0x20,0x20,0x30,0x28,0x2A,0x30
	.DB  0x0,0x60,0x80,0x80,0xB2,0xA8,0x7A,0x0
	.DB  0x0,0x30,0x28,0x2C,0x2A,0x20,0x3F,0x0
	.DB  0x0,0x40,0xA9,0xAA,0xA8,0xF0,0x0,0x0
	.DB  0x0,0x0,0x60,0x80,0x80,0x7E,0x0,0x0
	.DB  0x0,0x40,0xAA,0xA9,0xAA,0xF0,0x0,0x0
	.DB  0x0,0x0,0xC0,0x20,0x30,0x28,0x28,0x30
	.DB  0x0,0x0,0x60,0x80,0x88,0x80,0x60,0x0
	.DB  0x0,0x0,0x30,0x28,0x28,0x30,0x0,0x0
	.DB  0x0,0x0,0x0,0xB0,0xA8,0x78,0x0,0x0
	.DB  0x4,0x26,0x25,0x25,0x28,0x10,0xF,0x0
	.DB  0x4,0x22,0x22,0x26,0x29,0x10,0xF,0x0
	.DB  0x0,0x21,0x22,0x24,0xA8,0xD0,0xAF,0xA0
	.DB  0x0,0x70,0xAA,0xA9,0xAA,0x30,0x0,0x0
	.DB  0x0,0x70,0xAA,0xA8,0xAA,0x30,0x0,0x0
	.DB  0x0,0x30,0x40,0x40,0x50,0x28,0x8,0x0
	.DB  0x0,0x30,0xC0,0x40,0xD0,0x28,0x8,0x0
	.DB  0x0,0x0,0x2,0x79,0x2,0x0,0x0,0x0
	.DB  0x0,0x0,0x2,0x78,0x2,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x5,0x5,0x5
	.DB  0x0,0x0,0x0,0x4,0x3,0xB,0x6,0x6
	.DB  0xA0,0xA0,0xA0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x1,0x1,0x1,0x0,0x0
	.DB  0x0,0x21,0x22,0x24,0x28,0x10,0x2F,0x20
	.DB  0x0,0x0,0x0,0x0,0x0,0x4,0x3,0x3
	.DB  0x0,0x0,0x80,0x80,0x80,0x80,0x0,0x0
	.DB  0x0,0x0,0x10,0x10,0x54,0x10,0x10,0x0
	.DB  0x0,0x0,0x2,0x4,0x2,0x4,0x2,0x0
	.DB  0x20,0x24,0x26,0x25,0x25,0x20,0x28,0x30
	.DB  0x20,0x24,0x26,0x25,0x35,0x20,0x20,0x20
	.DB  0x8,0x6C,0x8A,0x8A,0xA0,0x50,0x10,0x20
	.DB  0x4,0xB6,0xAD,0x7D,0x24,0x20,0x20,0x20
	.DB  0x0,0x19,0x14,0x15,0x18,0x20,0x20,0x20
	.DB  0x4,0x2,0x2,0x1A,0x22,0x22,0x21,0x20
	.DB  0x0,0x40,0x60,0x50,0x48,0x50,0x40,0x40
_map:
	.DB  0xC1,0xC1,0xC1,0xC1,0x0,0x0,0xC2,0xC2
	.DB  0xFE,0xFE,0x1,0x0,0xC3,0xC3,0x1F,0x1F
	.DB  0x1,0x0,0xC4,0xC4,0xFC,0xFC,0x1,0x0
	.DB  0xC5,0xC5,0xC5,0xC5,0x1,0x1,0xC6,0xBD
	.DB  0xBF,0xBE,0x1,0x1,0xC7,0xC7,0xC0,0xC0
	.DB  0x1,0x0,0xC8,0x82,0x84,0x83,0x1,0x1
	.DB  0xC9,0xC9,0xFD,0xFD,0x1,0x0,0xCA,0x85
	.DB  0x87,0x86,0x1,0x1,0xCB,0x88,0x8A,0x89
	.DB  0x1,0x1,0xCC,0x8B,0xCC,0x8B,0x1,0x1
	.DB  0xCD,0x8C,0xCD,0x8C,0x1,0x1,0xCE,0x11
	.DB  0xCE,0x11,0x1,0x1,0xCF,0xCF,0x13,0x13
	.DB  0x1,0x0,0xD0,0xD0,0x8F,0x8F,0x1,0x0
	.DB  0xD1,0xD1,0x1B,0x1B,0x1,0x0,0xD2,0xD2
	.DB  0x91,0x91,0x1,0x0,0xD3,0x92,0x94,0x93
	.DB  0x1,0x1,0xD4,0x95,0x97,0x96,0x1,0x1
	.DB  0xD5,0x17,0x9A,0x99,0x1,0x1,0xD6,0x9B
	.DB  0x9D,0x9C,0x1,0x1,0xD7,0xD7,0xD7,0xD7
	.DB  0x0,0x0,0xD8,0xD8,0x9E,0x9E,0x1,0x1
	.DB  0xD9,0xD9,0x9F,0x9F,0x1,0x1,0xDA,0xA0
	.DB  0xA2,0xA1,0x1,0x1,0xDB,0xA3,0xA5,0xA4
	.DB  0x1,0x1,0xDC,0xDC,0xDC,0xDC,0x0,0x0
	.DB  0xDD,0xA6,0xA8,0xA7,0x1,0x1,0xDE,0xA9
	.DB  0xAB,0xAA,0x1,0x1,0xDF,0xAC,0xAE,0xAD
	.DB  0x1,0x1,0xE0,0xE0,0xE0,0xE0,0x0,0x0
	.DB  0xE1,0xAF,0xB1,0xB0,0x1,0x1,0xE2,0xE2
	.DB  0xE2,0xE2,0x0,0x0,0xE3,0xB2,0xB4,0xB3
	.DB  0x1,0x1,0xE4,0xB5,0xB7,0xB6,0x1,0x1
	.DB  0xE5,0xB8,0xBA,0xB9,0x1,0x1,0xE6,0xE6
	.DB  0xBC,0xBC,0x1,0x0,0xE7,0xE7,0xE7,0xE7
	.DB  0x0,0x0,0xE8,0xE8,0xE8,0xE8,0x0,0x0
	.DB  0xE9,0xE9,0xE9,0xE9,0x0,0x0,0xEA,0xEA
	.DB  0xEA,0xEA,0x0,0x0,0xEB,0xEB,0xEB,0xEB
	.DB  0x0,0x0,0xEC,0xBD,0xBF,0xBE,0x1,0x1
	.DB  0xED,0xBD,0xBF,0xBE,0x1,0x1,0xEE,0xEE
	.DB  0xEE,0xEE,0x0,0x0,0xEF,0xEF,0xEF,0xEF
	.DB  0x0,0x0,0xF0,0xF0,0xF0,0xF0,0x0,0x0
	.DB  0xF1,0xF1,0xF1,0xF1,0x0,0x0,0xF2,0xF2
	.DB  0xF2,0xF2,0x0,0x0,0xF3,0xF3,0xF3,0xF3
	.DB  0x0,0x0,0xF5,0xF5,0xF5,0xF5,0x0,0x0
	.DB  0xF6,0xF6,0xF6,0xF6,0x0,0x0,0xF7,0xF7
	.DB  0xF7,0xF7,0x0,0x0,0xF8,0xF8,0xF8,0xF8
	.DB  0x0,0x0,0xFB,0xF9,0xFB,0xFA,0x1,0x1
	.DB  0xBB,0xBB,0xF4,0xF4,0x1,0x0,0x81,0x1C
	.DB  0x1E,0x1D,0x1,0x1,0x90,0x18,0x1A,0x19
	.DB  0x1,0x1,0x98,0x14,0x16,0x15,0x1,0x1
	.DB  0x8E,0x8E,0x12,0x12,0x1,0x0,0x8D,0x10
	.DB  0x8D,0x10,0x1,0x1
_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0xC1
_0xC7:
	.DB  0x0,0x0,0x39,0x43
_0xC8:
	.DB  0x0,0x0,0x7,0x43
_0xC9:
	.DB  0x0,0x0,0xA0,0x40
_0x119:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _prevLet_G000
	.DW  _0x3*2

	.DW  0x04
	.DW  _UL
	.DW  _0xC7*2

	.DW  0x04
	.DW  _LL
	.DW  _0xC8*2

	.DW  0x04
	.DW  _TIME
	.DW  _0xC9*2

	.DW  0x0A
	.DW  0x04
	.DW  _0x119*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

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
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
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

	OUT  RAMPZ,R24

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
	.ORG 0x500

	.CSEG
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;#include <string.h>
;#include <glcd.h>

	.DSEG

	.CSEG
;	line -> Y+0
;	x -> Y+1
;	pattern -> R17
;	y -> Y+1
;	pattern -> R17
;	x -> Y+2
;	y -> Y+0
;	b -> Y+0
;	ln -> Y+2
;	i -> R16,R17
;	i -> R16,R17
;	status -> R17
;	column -> Y+1
;	read_data -> R17
;	x -> Y+4
;	y -> Y+2
;	color -> Y+1
;	pattern -> R17
;	x -> Y+7
;	y -> Y+5
;	l -> Y+4
;	s -> Y+3
;	c -> Y+2
;	i -> R16,R17
;	x -> Y+8
;	y -> Y+6
;	l -> Y+4
;	s -> Y+3
;	c -> Y+2
;	i -> R16,R17
;	x1 -> Y+22
;	y1 -> Y+20
;	x2 -> Y+18
;	y2 -> Y+16
;	s -> Y+15
;	c -> Y+14
;	i -> R17
;	y01 -> R16
;	temp -> R19
;	a -> Y+10
;	b -> Y+6
;	y00 -> R18
;	y010 -> R21
;	x1 -> Y+8
;	y1 -> Y+6
;	x2 -> Y+4
;	y2 -> Y+2
;	s -> Y+1
;	c -> Y+0
;	x11 -> Y+16
;	y11 -> Y+14
;	x12 -> Y+12
;	y12 -> Y+10
;	x21 -> Y+8
;	y21 -> Y+6
;	x22 -> Y+4
;	y22 -> Y+2
;	s -> Y+1
;	c -> Y+0
;	x1 -> Y+9
;	y1 -> Y+7
;	x2 -> Y+5
;	y2 -> Y+3
;	l -> Y+2
;	s -> Y+1
;	c -> Y+0
;	x1 -> Y+9
;	y1 -> Y+7
;	x2 -> Y+5
;	y2 -> Y+3
;	l -> Y+2
;	s -> Y+1
;	c -> Y+0
;	x11 -> Y+18
;	y11 -> Y+16
;	x12 -> Y+14
;	y12 -> Y+12
;	l1 -> Y+11
;	x21 -> Y+9
;	y21 -> Y+7
;	x22 -> Y+5
;	y22 -> Y+3
;	l2 -> Y+2
;	s -> Y+1
;	c -> Y+0
;	x11 -> Y+18
;	y11 -> Y+16
;	x12 -> Y+14
;	y12 -> Y+12
;	l1 -> Y+11
;	x21 -> Y+9
;	y21 -> Y+7
;	x22 -> Y+5
;	y22 -> Y+3
;	l2 -> Y+2
;	s -> Y+1
;	c -> Y+0
;	x0 -> Y+10
;	y0 -> Y+8
;	r -> Y+6
;	s -> Y+5
;	c -> Y+4
;	i -> R17
;	y -> R16
;	y00 -> R19
;	c -> Y+5
;	x -> Y+3
;	y -> Y+1
;	i -> R17
;	*large -> Y+6
;	c -> Y+5
;	size -> Y+4
;	i -> R17
;	j -> R16
;	temp -> R19
;	k -> R18
;	c -> Y+73
;	x -> Y+71
;	y -> Y+69
;	sz -> Y+68
;	i -> R17
;	j -> R16
;	k -> R19
;	large -> Y+4
;	c -> Y+6
;	x -> Y+4
;	y -> Y+2
;	l -> Y+1
;	sz -> Y+0
;	*c -> Y+9
;	x -> Y+7
;	y -> Y+5
;	l -> Y+4
;	sz -> Y+3
;	space -> Y+2
;	i -> R17
;	special -> R16
;	*bmp -> Y+12
;	x1 -> Y+10
;	y1 -> Y+8
;	x2 -> Y+6
;	y2 -> Y+4
;	i -> R16,R17
;	j -> R18,R19
;#include <stdio.h>
;#include "logo.h"
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR        (1 << FE)
;#define PARITY_ERROR         (1 << UPE)
;#define DATA_OVERRUN         (1 << DOR)
;#define DATA_REGISTER_EMPTY  (1 << UDRE)
;#define RX_COMPLETE          (1 << RXC)
;
;char machine_state = 0;  // 0 - OFF, 1 - ON
;char old_machine_state = 0;
;char error_flag = 0;
;char freq_error_flag = 0;
;
;int i;
;
;float frequency_count = 0;
;float frequency_count_old = 0;
;
;float duty_cycle_count;
;float mult_factor;
;float x;
;
;// TIME is in Seconds.
;//UL(816) corresponds to 10kHZ and LL(204) corresponds 40kHz
;//UL(1024) -- 0kHz
;float UL = 185; //UL (218) -- 18kHz,

	.DSEG
;float LL = 135; //LL (135) -- 30kHz  on GATE DRIVERS
;float TIME = 5;
;float delay_time_stop;
;float delay_time_start;
;
;//int cnt10ms = 0;  // Timer 10ms event flag
;//int cnt100ms = 0;  //Timer 100ms event flag
;
;short int on_button_state = 0x0000;
;short int off_button_state = 0x0000;
;
;#define ADC_VREF_TYPE 0x00
;
;//Initialize ports, ADC, Timer, etc.
;void initialize() {
; 0000 004B void initialize() {

	.CSEG
_initialize:
; 0000 004C     PORTA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 004D     DDRA = 0x37; // port A GLCD control port
	LDI  R30,LOW(55)
	OUT  0x1A,R30
; 0000 004E 
; 0000 004F     PORTB = 0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0050     DDRB = 0x21; // PB.5 for Timer 1 PWM output at OC1A
	LDI  R30,LOW(33)
	OUT  0x17,R30
; 0000 0051     DDRB.6 = 1;
	SBI  0x17,6
; 0000 0052 
; 0000 0053     DDRB.2 = 1;  // PB.2 for buzzer as output
	SBI  0x17,2
; 0000 0054     PORTB.2 = 1;
	SBI  0x18,2
; 0000 0055     // DDRB.0=1;
; 0000 0056     // PORTB.0 = 1;
; 0000 0057 
; 0000 0058     PORTC = 0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0059     DDRC = 0xFF; // GLCD Dataport as output
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 005A 
; 0000 005B     PORTD = 0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 005C     DDRD = 0x08; // for uart 1
	LDI  R30,LOW(8)
	OUT  0x11,R30
; 0000 005D 
; 0000 005E     PORTE = 0x0F;
	LDI  R30,LOW(15)
	OUT  0x3,R30
; 0000 005F     DDRE = 0x00; // E as input for interrupts
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 0060 
; 0000 0061     PORTF = 0x00;
	STS  98,R30
; 0000 0062     DDRF = 0x00;
	STS  97,R30
; 0000 0063 
; 0000 0064     PORTG = 0x00;
	STS  101,R30
; 0000 0065     DDRG = 0x00;
	STS  100,R30
; 0000 0066 
; 0000 0067     // PWM generation using Timer 1 at OC1A --> PB.5
; 0000 0068     // Timer Clock and mode controlled using TCCR1A and TCCR1B
; 0000 0069     // Timer Clock --> 8MHz
; 0000 006A     // OC1A --> Non - Inverted output
; 0000 006B     // TOP vlaue --> ICR1 (16 bit)
; 0000 006C     // Compare value --> OCR1A (16 bit) ---- take care when resetting ICR on the  fly, it is not double buffered
; 0000 006D     // Duty Cycle % = (OCR1A/ICR1)*100
; 0000 006E     TCCR1A = 0x82;
	LDI  R30,LOW(130)
	OUT  0x2F,R30
; 0000 006F 
; 0000 0070     TCCR1B = 0x18;
	LDI  R30,LOW(24)
	OUT  0x2E,R30
; 0000 0071     TCNT1H = 0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0072     TCNT1L = 0x00;
	OUT  0x2C,R30
; 0000 0073     ICR1H = 0x03;
	LDI  R30,LOW(3)
	OUT  0x27,R30
; 0000 0074     ICR1L = 0xff;
	LDI  R30,LOW(255)
	OUT  0x26,R30
; 0000 0075     OCR1AH = 0x01;
	LDI  R30,LOW(1)
	OUT  0x2B,R30
; 0000 0076     OCR1AL = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x2A,R30
; 0000 0077     OCR1BH = 0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 0078     OCR1BL = 0x00;
	OUT  0x28,R30
; 0000 0079     OCR1CH = 0x00;
	STS  121,R30
; 0000 007A     OCR1CL = 0x00;
	STS  120,R30
; 0000 007B 
; 0000 007C     // delta T ----> control using Timer 3
; 0000 007D     // Timer Clock and mode controlled using TCCR3A and TCCR3B
; 0000 007E     // Timer Clock --> 1MHz
; 0000 007F     // CTC mode --> top value ---> OCR3A
; 0000 0080     // Interrupt triggered when counter reaches OCR3A value and is cleared
; 0000 0081     // Interrupt Rate = (OCR3A/Timer clock)
; 0000 0082     TCCR3A = 0x00;
	STS  139,R30
; 0000 0083     TCCR3B = 0x09;//0x0B;
	LDI  R30,LOW(9)
	STS  138,R30
; 0000 0084     TCNT3H = 0x00;
	LDI  R30,LOW(0)
	STS  137,R30
; 0000 0085     TCNT3L = 0x00;
	STS  136,R30
; 0000 0086     ICR3H = 0x00;
	STS  129,R30
; 0000 0087     ICR3L = 0x00;
	STS  128,R30
; 0000 0088     OCR3AH = 0xFF;
	LDI  R30,LOW(255)
	STS  135,R30
; 0000 0089     OCR3AL = 0xFF;
	STS  134,R30
; 0000 008A     OCR3BH = 0x00;
	LDI  R30,LOW(0)
	STS  133,R30
; 0000 008B     OCR3BL = 0x00;
	STS  132,R30
; 0000 008C     OCR3CH = 0x00;
	STS  131,R30
; 0000 008D     OCR3CL = 0x00;
	STS  130,R30
; 0000 008E 
; 0000 008F     // External Interrupt(s) initialization
; 0000 0090     EICRA = 0x00; // Interrupts trigerred on rising edge; Change mode using EICR
	STS  106,R30
; 0000 0091     EICRB = 0x00;
	OUT  0x3A,R30
; 0000 0092     EIMSK = 0x00;
	OUT  0x39,R30
; 0000 0093     EIFR = 0x00;
	OUT  0x38,R30
; 0000 0094 
; 0000 0095     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0096     TIMSK = 0x00;
	OUT  0x37,R30
; 0000 0097 
; 0000 0098     ETIMSK = 0x04;
	LDI  R30,LOW(4)
	STS  125,R30
; 0000 0099 
; 0000 009A     // USART0 initialization
; 0000 009B     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 009C     // USART0 Receiver: On
; 0000 009D     // USART0 Transmitter: On
; 0000 009E     // USART0 Mode: Asynchronous
; 0000 009F     // USART0 Baud Rate: 9600
; 0000 00A0     UCSR0A = 0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 00A1     UCSR0B = 0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 00A2     UCSR0C = 0x06;
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 00A3     UBRR0H = 0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 00A4     UBRR0L = 0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 00A5 
; 0000 00A6     // USART1 initialization
; 0000 00A7     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00A8     // USART1 Receiver: On
; 0000 00A9     // USART1 Transmitter: On
; 0000 00AA     // USART1 Mode: Asynchronous
; 0000 00AB     // USART1 Baud Rate: 9600
; 0000 00AC     UCSR1A = 0x00;
	LDI  R30,LOW(0)
	STS  155,R30
; 0000 00AD     UCSR1B = 0x18;
	LDI  R30,LOW(24)
	STS  154,R30
; 0000 00AE     UCSR1C = 0x06;
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 00AF     UBRR1H = 0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0000 00B0     UBRR1L = 0x33;
	LDI  R30,LOW(51)
	STS  153,R30
; 0000 00B1 
; 0000 00B2     // Analog Comparator initialization
; 0000 00B3     // Analog Comparator: Off
; 0000 00B4     // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00B5     ACSR = 0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00B6     SFIOR = 0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00B7 
; 0000 00B8     // ADC initialization
; 0000 00B9     // ADC Clock frequency: 1000.000 kHz
; 0000 00BA     // ADC Voltage Reference: AREF pin
; 0000 00BB     ADMUX = ADC_VREF_TYPE & 0xff;
	OUT  0x7,R30
; 0000 00BC     ADCSRA = 0x81;
	LDI  R30,LOW(129)
	OUT  0x6,R30
; 0000 00BD 
; 0000 00BE     // SPI initialization
; 0000 00BF     // SPI disabled
; 0000 00C0     SPCR = 0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 00C1 
; 0000 00C2     // TWI initialization
; 0000 00C3     // TWI disabled
; 0000 00C4     TWCR = 0x00;
	STS  116,R30
; 0000 00C5 
; 0000 00C6     PORTB .0 = 0;
	RJMP _0x20A0001
; 0000 00C7     TCCR1B = 0x18;
; 0000 00C8 }
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input) { //PORTB.6=1;
; 0000 00CB unsigned int read_adc(unsigned char adc_input) {
_read_adc:
; 0000 00CC     ADMUX = adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 00CD     // Delay needed for the stabilization of the ADC input voltage
; 0000 00CE     delay_us(10);
	__DELAY_USB 27
; 0000 00CF     // Start the AD conversion
; 0000 00D0     ADCSRA |= 0x40;
	SBI  0x6,6
; 0000 00D1     // Wait for the AD conversion to complete
; 0000 00D2     while ((ADCSRA & 0x10) == 0);
_0xD2:
	SBIS 0x6,4
	RJMP _0xD2
; 0000 00D3     ADCSRA |= 0x10;
	SBI  0x6,4
; 0000 00D4     //PORTB.6=0;
; 0000 00D5     //ADCW = ((ADCW/1024)*(UL-LL))+UL;
; 0000 00D6     return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 00D7 }
;
;void indicate_machine_on() {
; 0000 00D9 void indicate_machine_on() {
_indicate_machine_on:
; 0000 00DA     PORTC.0 = 1;   // ON LED on C.0, active HIGH logic
	SBI  0x15,0
; 0000 00DB     PORTC.2 = 0;
	CBI  0x15,2
; 0000 00DC }
	RET
;
;void indicate_machine_off() {
; 0000 00DE void indicate_machine_off() {
_indicate_machine_off:
; 0000 00DF     PORTC.0 = 0;
	CBI  0x15,0
; 0000 00E0     PORTC.2 = 1;
	SBI  0x15,2
; 0000 00E1 }
	RET
;
;void soft_start() {
; 0000 00E3 void soft_start() {
_soft_start:
; 0000 00E4     x = read_adc(0x03);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	LDI  R26,LOW(_x)
	LDI  R27,HIGH(_x)
	CALL SUBOPT_0x0
	CALL __PUTDP1
; 0000 00E5     x = ((x / 1024) * (UL - LL)) + LL;
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3
	CALL SUBOPT_0x4
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
; 0000 00E6 
; 0000 00E7     delay_time_start = (TIME * 100) / (UL - LL);
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	STS  _delay_time_start,R30
	STS  _delay_time_start+1,R31
	STS  _delay_time_start+2,R22
	STS  _delay_time_start+3,R23
; 0000 00E8 
; 0000 00E9 
; 0000 00EA     if (x > UL) {
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xDD
; 0000 00EB         x = UL;
	CALL SUBOPT_0x8
	RJMP _0x116
; 0000 00EC     } else if (x < LL) {
_0xDD:
	CALL SUBOPT_0x9
	CALL SUBOPT_0x1
	CALL __CMPF12
	BRSH _0xDF
; 0000 00ED         x = LL;
	CALL SUBOPT_0x9
_0x116:
	STS  _x,R30
	STS  _x+1,R31
	STS  _x+2,R22
	STS  _x+3,R23
; 0000 00EE     }
; 0000 00EF 
; 0000 00F0     ICR1 = LL;
_0xDF:
	CALL SUBOPT_0x9
	CALL __CFD1U
	OUT  0x26+1,R31
	OUT  0x26,R30
; 0000 00F1     OCR1A = 0.5 * ICR1;
	CALL SUBOPT_0xA
; 0000 00F2 
; 0000 00F3     TCCR1B = 0x19;
	LDI  R30,LOW(25)
	OUT  0x2E,R30
; 0000 00F4     PORTB.0 = 1;
	SBI  0x18,0
; 0000 00F5 
; 0000 00F6     for (i = LL; i < x; i++) {
	CALL SUBOPT_0x9
	CALL __CFD1
	MOVW R8,R30
_0xE3:
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
	BRSH _0xE4
; 0000 00F7         ICR1 = i;
	__OUTWR 8,9,38
; 0000 00F8         OCR1A = 0.5 * ICR1;
	CALL SUBOPT_0xA
; 0000 00F9         delay_ms(delay_time_start);
	LDS  R30,_delay_time_start
	LDS  R31,_delay_time_start+1
	LDS  R22,_delay_time_start+2
	LDS  R23,_delay_time_start+3
	CALL SUBOPT_0xD
; 0000 00FA     }
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	SBIW R30,1
	RJMP _0xE3
_0xE4:
; 0000 00FB }
	RET
;
;void soft_stop() {
; 0000 00FD void soft_stop() {
_soft_stop:
; 0000 00FE     x = frequency_count;
	CALL SUBOPT_0xE
	CALL SUBOPT_0x6
; 0000 00FF 
; 0000 0100     delay_time_stop = (TIME * 100) / (UL - LL);
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	STS  _delay_time_stop,R30
	STS  _delay_time_stop+1,R31
	STS  _delay_time_stop+2,R22
	STS  _delay_time_stop+3,R23
; 0000 0101 
; 0000 0102     for (i = x; i > LL; i--) {
	CALL SUBOPT_0xB
	CALL __CFD1
	MOVW R8,R30
_0xE6:
	CALL SUBOPT_0x9
	CALL SUBOPT_0xC
	BREQ PC+2
	BRCC PC+3
	JMP  _0xE7
; 0000 0103         ICR1 = i;
	__OUTWR 8,9,38
; 0000 0104         OCR1A = 0.5 * ICR1;
	CALL SUBOPT_0xA
; 0000 0105         delay_ms(delay_time_stop);
	LDS  R30,_delay_time_stop
	LDS  R31,_delay_time_stop+1
	LDS  R22,_delay_time_stop+2
	LDS  R23,_delay_time_stop+3
	CALL SUBOPT_0xD
; 0000 0106     }
	MOVW R30,R8
	SBIW R30,1
	MOVW R8,R30
	RJMP _0xE6
_0xE7:
; 0000 0107 
; 0000 0108     PORTB .0 = 0;
_0x20A0001:
	CBI  0x18,0
; 0000 0109     TCCR1B = 0x18;
	LDI  R30,LOW(24)
	OUT  0x2E,R30
; 0000 010A }
	RET
;
;void check_sensor_states() {
; 0000 010C void check_sensor_states() {
_check_sensor_states:
; 0000 010D     // PINE.4 --> heat sensor
; 0000 010E     // PINE.5 --> crucible sensor
; 0000 010F     // PINE.6 --> water sensor
; 0000 0110 
; 0000 0111     if (PINE.4 == 1 || PINE.5 == 1 || PINE.6 == 1) {  // if any fault detected by sensors
	SBIC 0x1,4
	RJMP _0xEB
	SBIC 0x1,5
	RJMP _0xEB
	SBIS 0x1,6
	RJMP _0xEA
_0xEB:
; 0000 0112         machine_state = 0;
	CLR  R5
; 0000 0113         error_flag = 1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 0114     } else {
	RJMP _0xED
_0xEA:
; 0000 0115         error_flag = 0;
	CLR  R7
; 0000 0116     }
_0xED:
; 0000 0117 }
	RET
;
;
;// Timer3 overflow interrupt service routine
;interrupt[TIM3_OVF] void timer3_ovf_isr(void) {
; 0000 011B interrupt[30] void timer3_ovf_isr(void) {
_timer3_ovf_isr:
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
; 0000 011C 
; 0000 011D     // ISR called every 8.595 msec when TCCRB = 0x09, and OCR3A = 0xFFFF
; 0000 011E 
; 0000 011F     // switch debounce logic. refer: https://www.embedded.com/electronics-blogs/break-points/4024981/My-favorite-software-debouncers
; 0000 0120     // 16 bit shifts = approx 130msec debounce delay
; 0000 0121     on_button_state = (0x8000 | !PIND.7) | (on_button_state << 1);
	LDI  R30,0
	SBIS 0x10,7
	LDI  R30,1
	LDI  R31,0
	ORI  R31,HIGH(0x8000)
	MOVW R26,R30
	MOVW R30,R10
	LSL  R30
	ROL  R31
	OR   R30,R26
	OR   R31,R27
	MOVW R10,R30
; 0000 0122     if(on_button_state == 0xC000) {
	LDI  R30,LOW(49152)
	LDI  R31,HIGH(49152)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0xEE
; 0000 0123 
; 0000 0124         if(machine_state == 0 && error_flag == 0 && freq_error_flag == 0) { // if machine is OFF
	CP   R30,R5
	BRNE _0xF0
	CP   R30,R7
	BRNE _0xF0
	CP   R30,R6
	BREQ _0xF1
_0xF0:
	RJMP _0xEF
_0xF1:
; 0000 0125 
; 0000 0126             machine_state = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0127         }
; 0000 0128     }
_0xEF:
; 0000 0129 
; 0000 012A     off_button_state = (0x8000 | !PIND.6) | (off_button_state << 1);
_0xEE:
	LDI  R30,0
	SBIS 0x10,6
	LDI  R30,1
	LDI  R31,0
	ORI  R31,HIGH(0x8000)
	MOVW R26,R30
	MOVW R30,R12
	LSL  R30
	ROL  R31
	OR   R30,R26
	OR   R31,R27
	MOVW R12,R30
; 0000 012B     if(off_button_state == 0xC000 ) {
	LDI  R30,LOW(49152)
	LDI  R31,HIGH(49152)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0xF2
; 0000 012C 
; 0000 012D         if(machine_state == 1) {
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0xF3
; 0000 012E 
; 0000 012F             machine_state = 0;
	CLR  R5
; 0000 0130         }
; 0000 0131     }
_0xF3:
; 0000 0132 
; 0000 0133     frequency_count = read_adc(0x03);
_0xF2:
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	LDI  R26,LOW(_frequency_count)
	LDI  R27,HIGH(_frequency_count)
	CALL SUBOPT_0x0
	CALL __PUTDP1
; 0000 0134 
; 0000 0135     frequency_count = ((frequency_count / 1024) * (UL - LL)) + LL;
	CALL SUBOPT_0xF
	CALL SUBOPT_0x2
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x5
	CALL SUBOPT_0x10
; 0000 0136 
; 0000 0137     frequency_count = (frequency_count - frequency_count_old)*0.1 + frequency_count_old;
	CALL SUBOPT_0x11
	CALL SUBOPT_0xE
	CALL __SUBF12
	__GETD2N 0x3DCCCCCD
	CALL __MULF12
	CALL SUBOPT_0x11
	CALL __ADDF12
	CALL SUBOPT_0x10
; 0000 0138 
; 0000 0139     frequency_count_old = frequency_count;
	CALL SUBOPT_0xE
	STS  _frequency_count_old,R30
	STS  _frequency_count_old+1,R31
	STS  _frequency_count_old+2,R22
	STS  _frequency_count_old+3,R23
; 0000 013A 
; 0000 013B     if (frequency_count < 140 && machine_state == 1) {
	CALL SUBOPT_0xF
	__GETD1N 0x430C0000
	CALL __CMPF12
	BRSH _0xF5
	LDI  R30,LOW(1)
	CP   R30,R5
	BREQ _0xF6
_0xF5:
	RJMP _0xF4
_0xF6:
; 0000 013C         machine_state = 0;
	CLR  R5
; 0000 013D         freq_error_flag = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 013E     } else if (frequency_count > 145 && freq_error_flag == 1){
	RJMP _0xF7
_0xF4:
	CALL SUBOPT_0xF
	__GETD1N 0x43110000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xF9
	LDI  R30,LOW(1)
	CP   R30,R6
	BREQ _0xFA
_0xF9:
	RJMP _0xF8
_0xFA:
; 0000 013F         machine_state = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0140         freq_error_flag = 0;
	CLR  R6
; 0000 0141 
; 0000 0142         mult_factor = 50;
; 0000 0143         duty_cycle_count = mult_factor * frequency_count / 100;
; 0000 0144         OCR1A = duty_cycle_count;
; 0000 0145         ICR1 = frequency_count;
; 0000 0146     } else {
_0xF8:
; 0000 0147         mult_factor = 50;
_0x117:
	__GETD1N 0x42480000
	STS  _mult_factor,R30
	STS  _mult_factor+1,R31
	STS  _mult_factor+2,R22
	STS  _mult_factor+3,R23
; 0000 0148         duty_cycle_count = mult_factor * frequency_count / 100;
	CALL SUBOPT_0xE
	LDS  R26,_mult_factor
	LDS  R27,_mult_factor+1
	LDS  R24,_mult_factor+2
	LDS  R25,_mult_factor+3
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x42C80000
	CALL __DIVF21
	STS  _duty_cycle_count,R30
	STS  _duty_cycle_count+1,R31
	STS  _duty_cycle_count+2,R22
	STS  _duty_cycle_count+3,R23
; 0000 0149         OCR1A = duty_cycle_count;
	CALL __CFD1U
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 014A         ICR1 = frequency_count;
	CALL SUBOPT_0xE
	CALL __CFD1U
	OUT  0x26+1,R31
	OUT  0x26,R30
; 0000 014B     }
_0xF7:
; 0000 014C 
; 0000 014D }
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
;
;// Get a character from the USART1 Receiver
;#pragma used+
;
;char getchar1(void) {
; 0000 0152 char getchar1(void) {
; 0000 0153     char status, data;
; 0000 0154     while (1) {
;	status -> R17
;	data -> R16
; 0000 0155         while (((status = UCSR1A) & RX_COMPLETE) == 0);
; 0000 0156         data = UDR1;
; 0000 0157         if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN)) == 0)
; 0000 0158             return data;
; 0000 0159     }
; 0000 015A }
;
;#pragma used-
;
;
;#pragma used+
;// Write a character to the USART1 Transmitter
;void putchar1(char c) {
; 0000 0161 void putchar1(char c) {
; 0000 0162     while ((UCSR1A & DATA_REGISTER_EMPTY) == 0);
;	c -> Y+0
; 0000 0163     UDR1 = c;
; 0000 0164 }
;
;#pragma used-
;
;void main(void) {
; 0000 0168 void main(void) {
_main:
; 0000 0169 
; 0000 016A     initialize();
	RCALL _initialize
; 0000 016B 
; 0000 016C     indicate_machine_off();
	RCALL _indicate_machine_off
; 0000 016D 
; 0000 016E     delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 016F 
; 0000 0170     // Global enable interrupts
; 0000 0171     #asm("sei")
	sei
; 0000 0172 
; 0000 0173     while (1) {
_0x106:
; 0000 0174 
; 0000 0175         check_sensor_states();
	RCALL _check_sensor_states
; 0000 0176 
; 0000 0177         if (old_machine_state != machine_state) {
	CP   R5,R4
	BREQ _0x109
; 0000 0178             if (machine_state == 1 && error_flag == 0 && freq_error_flag == 0) {
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x10B
	LDI  R30,LOW(0)
	CP   R30,R7
	BRNE _0x10B
	CP   R30,R6
	BREQ _0x10C
_0x10B:
	RJMP _0x10A
_0x10C:
; 0000 0179                 ETIMSK = 0x00;  // disable all timer ISRs
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 017A                 soft_start();
	RCALL _soft_start
; 0000 017B                 ETIMSK = 0x04;  // enable timer 3 ISR
	LDI  R30,LOW(4)
	STS  125,R30
; 0000 017C 
; 0000 017D                 indicate_machine_on();
	RCALL _indicate_machine_on
; 0000 017E 
; 0000 017F                 old_machine_state = machine_state;
	RJMP _0x118
; 0000 0180             } else if (machine_state == 0) {
_0x10A:
	TST  R5
	BRNE _0x10E
; 0000 0181                 ETIMSK = 0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 0182                 soft_stop();
	RCALL _soft_stop
; 0000 0183                 ETIMSK = 0x04;
	LDI  R30,LOW(4)
	STS  125,R30
; 0000 0184 
; 0000 0185                 indicate_machine_off();
	RCALL _indicate_machine_off
; 0000 0186 
; 0000 0187                 old_machine_state = machine_state;
_0x118:
	MOV  R4,R5
; 0000 0188             }
; 0000 0189         }
_0x10E:
; 0000 018A     }
_0x109:
	RJMP _0x106
; 0000 018B }
_0x10F:
	RJMP _0x10F

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.DSEG
_prevLet_G000:
	.BYTE 0x2
_stat_G000:
	.BYTE 0x1
_prevX_G000:
	.BYTE 0x1
_prevY_G000:
	.BYTE 0x1
_frequency_count:
	.BYTE 0x4
_frequency_count_old:
	.BYTE 0x4
_duty_cycle_count:
	.BYTE 0x4
_mult_factor:
	.BYTE 0x4
_x:
	.BYTE 0x4
_UL:
	.BYTE 0x4
_LL:
	.BYTE 0x4
_TIME:
	.BYTE 0x4
_delay_time_stop:
	.BYTE 0x4
_delay_time_start:
	.BYTE 0x4
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	LDS  R26,_x
	LDS  R27,_x+1
	LDS  R24,_x+2
	LDS  R25,_x+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	__GETD1N 0x44800000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x3:
	LDS  R26,_LL
	LDS  R27,_LL+1
	LDS  R24,_LL+2
	LDS  R25,_LL+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x4:
	LDS  R30,_UL
	LDS  R31,_UL+1
	LDS  R22,_UL+2
	LDS  R23,_UL+3
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	CALL __MULF12
	RCALL SUBOPT_0x3
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x6:
	STS  _x,R30
	STS  _x+1,R31
	STS  _x+2,R22
	STS  _x+3,R23
	LDS  R26,_TIME
	LDS  R27,_TIME+1
	LDS  R24,_TIME+2
	LDS  R25,_TIME+3
	__GETD1N 0x42C80000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	RCALL SUBOPT_0x3
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDS  R30,_UL
	LDS  R31,_UL+1
	LDS  R22,_UL+2
	LDS  R23,_UL+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x9:
	LDS  R30,_LL
	LDS  R31,_LL+1
	LDS  R22,_LL+2
	LDS  R23,_LL+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xA:
	IN   R30,0x26
	IN   R31,0x26+1
	RCALL SUBOPT_0x0
	__GETD2N 0x3F000000
	CALL __MULF12
	CALL __CFD1U
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDS  R30,_x
	LDS  R31,_x+1
	LDS  R22,_x+2
	LDS  R23,_x+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	MOVW R26,R8
	CALL __CWD2
	CALL __CDF2
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	CALL __CFD1U
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xE:
	LDS  R30,_frequency_count
	LDS  R31,_frequency_count+1
	LDS  R22,_frequency_count+2
	LDS  R23,_frequency_count+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF:
	LDS  R26,_frequency_count
	LDS  R27,_frequency_count+1
	LDS  R24,_frequency_count+2
	LDS  R25,_frequency_count+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	STS  _frequency_count,R30
	STS  _frequency_count+1,R31
	STS  _frequency_count+2,R22
	STS  _frequency_count+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDS  R26,_frequency_count_old
	LDS  R27,_frequency_count_old+1
	LDS  R24,_frequency_count_old+2
	LDS  R25,_frequency_count_old+3
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
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

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

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

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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

;END OF CODE MARKER
__END_OF_CODE:
