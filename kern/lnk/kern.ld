#include "config.hpp"

OUTPUT_FORMAT("elf32-i386")

ENTRY(_start)

SECTIONS
{
  . = KERN_LOAD_ADDR;
  .text : AT(KERN_LOAD_ADDR) {
    *(.text)
  }

  .data : SUBALIGN(2) {
    *(.data);
    *(.rodata*);
  }

  .bss : SUBALIGN(4) {
    __bss_start = .;
    *(.COMMON);
    *(.bss*)
    . = ALIGN(4);
    __bss_end = .;
  }

  /DISCARD/ : {
    *(.eh_frame)
    *(.comment)
  }
}
