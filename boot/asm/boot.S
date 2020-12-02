#include "config.hpp"

// real mode code
.code16

.global _start

jmp _start

#include "bios_reloc.S"
#include "toggle_interrupts.S"
#include "a20_enable.S"
#include "protected_mode_enable.S"
#include "gdt.S"

_start:
  // relocate and load remaining bootloader code
  BIOS_RELOC

reloc_jmp:
  jmp $0x0, $reloc_done

reloc_done:
  // set up segment registers
  xor %ax, %ax
  mov %ax, %ds
  mov %ax, %es

  // set up stack
  xor %ax, %ax
  mov %ax, %ss
  mov %ax, %sp

  // clear direction flag
  cld

  // zero BSS
  mov $__bss_size, %cx
  mov $__bss_start, %di
  rep stosb

  // disable all interrupts
  call disable_interrupts

  // enable a20 line
  call a20_enable

  test %ax, %ax
  jz real_mode_boot_error

  // switch to protected mode
  PROTECTED_MODE_ENABLE

  jmp $GDT_SELECTOR_KERNEL_CODE, $protected_mode_start

real_mode_boot_error:
  jmp real_mode_boot_error

// protected mode code
.code32

protected_mode_start:
  // set up segment registers
  mov $GDT_SELECTOR_KERNEL_DATA, %ax
  mov %ax, %ds
  mov %ax, %es
  mov %ax, %fs
  mov %ax, %gs

  mov %ax, %ss
  mov $BOOT_STACK_TOP, %esp

  call bootloader_start
