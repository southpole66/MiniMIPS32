
build/shift:     file format elf32-tradlittlemips
build/shift


Disassembly of section .text:

80000000 <main>:
80000000:	3c088934 	lui	t0,0x8934
80000004:	35085678 	ori	t0,t0,0x5678
80000008:	00084900 	sll	t1,t0,0x4
8000000c:	00095102 	srl	t2,t1,0x4
80000010:	00095903 	sra	t3,t1,0x4
80000014:	3c080000 	lui	t0,0x0
80000018:	35080008 	ori	t0,t0,0x8
8000001c:	01286004 	sllv	t4,t0,t1
80000020:	01286806 	srlv	t5,t0,t1
80000024:	01287007 	srav	t6,t0,t1
80000028:	4a000000 	c2	0x0

Disassembly of section .reginfo:

00000000 <.reginfo>:
   0:	00007f00 	sll	t7,zero,0x1c
	...
