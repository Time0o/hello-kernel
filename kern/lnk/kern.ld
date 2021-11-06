#include "mem.hpp"

OUTPUT_FORMAT("elf32-i386")

ENTRY(_start)

SECTIONS
{
  . = KERN_LINK_ADDR;

  // Place the initial page table here so that it's address is known at compile
  // time which makes setting up the initial page directory significantly easier.
  .pt_kentry : AT(KERN_PT_KENTRY_LOAD_ADDR) {
    KEEP(*(.pt_kentry))
  }

  .pd_kentry : AT(KERN_PD_KENTRY_LOAD_ADDR) {
    KEEP(*(.pd_kentry))
  }

  .text : AT(KERN_TEXT_LOAD_ADDR) {
    *(.text)
  }

  . = ALIGN(PAGE_SIZE);

  .data : {
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
    *(.comment)
    *(.eh_frame)
    *(.note.gnu.property)
  }
}
