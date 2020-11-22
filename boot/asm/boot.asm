extern bootloader_start

global _start

; real mode code
bits 16

jmp _start

; TODO relocate bootloader
;jmp reloc

%include "bios_print.asm"
%include "bios_reloc.asm"

%include "toggle_interrupts.asm"
%include "a20_enable.asm"
%include "protected_mode_enable.asm"
%include "gdt.asm"

; TODO relocate bootloader
;reloc:
;  BIOS_RELOC

_start:
  ; set up segment registers
  xor ax, ax
  mov ds, ax
  mov ss, ax
  mov sp, BOOT_ORG

  ; print greeting
  BIOS_PRINT MSG_GREETING

  ; disable all interrupts
  call disable_interrupts

  ; enable a20 line
  call a20_enable

  test ax, ax
  jz real_mode_boot_error

  ; switch to protected mode
  call protected_mode_enable

  jmp GDT_SELECTOR_KERNEL_CODE:protected_mode_start

real_mode_boot_error:
  jmp real_mode_boot_error

; protected mode code
bits 32

protected_mode_start:
  ; set up segment registers
  mov ax, GDT_SELECTOR_KERNEL_DATA
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax
  mov esp, BOOT_ORG

  call bootloader_start

%include "constants.asm"

GDT
