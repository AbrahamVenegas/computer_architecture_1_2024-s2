SECTIONS
{
    . = 0x08000000; /* Custom base address for code */

    .text :
    {
        *(.text)  /* Include all .text sections */
    }
}
