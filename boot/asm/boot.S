#include "config.hpp"

// real mode code
.code16

.global _start

jmp _start

#include "toggle_interrupts.S"
#include "a20_enable.S"
#include "gdt.S"
#include "protected_mode_enable.S"

_start:
  // set up segment registers
  xor %ax, %ax
  mov %ax, %ds
  mov %ax, %es

  mov $BOOT_STACK_SEG, %bx
  mov %bx, %ss
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
  call protected_mode_enable

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
