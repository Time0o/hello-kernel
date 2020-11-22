#include "config.hpp"

OUTPUT_FORMAT("elf32-i386");

ENTRY(_start);

SECTIONS
{
  . = BOOT_ORG;
  .text : {
      BOOT_ASM_OBJ(.text);
      *(.text);
  }

  .data : SUBALIGN(2) {
      *(.data);
      *(.rodata*);
  }

  .sig BOOT_SIG_OFFS : {
      SHORT(BOOT_SIG);
  }

  .bss : SUBALIGN(4) {
    __bss_start = .;
    *(.COMMON);
    *(.bss)
    . = ALIGN(4);
    __bss_end = .;
  }

  __bss_size = SIZEOF(.bss);

  /DISCARD/ : {
      *(.eh_frame);
      *(.comment);
  }
}
