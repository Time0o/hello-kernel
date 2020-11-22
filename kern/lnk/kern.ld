#include "config.hpp"

OUTPUT_FORMAT("elf32-i386")

ENTRY(kernel_start)

SECTIONS
{
  . = KERN_LOAD_ADDR;
  .text : AT(KERN_LINK_ADDR) {
    *(.text)
  }

  /DISCARD/ : {
    *(.eh_frame)
    *(.comment)
  }
}
