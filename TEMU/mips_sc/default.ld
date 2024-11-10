OUTPUT_ARCH(mips)
ENTRY(main)
SECTIONS
{
        . = 0xbfc00000;
        .text : 
        {
            *(.text)
            _etext = .;
        }

        . = 0x80400000;
        .data : 
        {
            *(.data)              
        }

	.bss :
        {
            *(.bss)
        }

} 
