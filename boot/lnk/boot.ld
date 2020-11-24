#include "config.hpp"

OUTPUT_FORMAT("elf32-i386");

ENTRY(_start);

SECTIONS
{
  . = BOOT_RELOC_ADDR;
  .text : {
    BOOT_ASM_OBJ(.text);
    . = DISK_SECT_SIZE - 2;
    SHORT(BOOT_SIG);
  }

  .data : SUBALIGN(2) {
      *(.data);
      *(.rodata*);
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
