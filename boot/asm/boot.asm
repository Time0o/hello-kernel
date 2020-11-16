bits 16

global _start

jmp reloc

%include "bios_print.asm"
%include "bios_reloc.asm"

%include "toggle_interrupts.asm"
%include "a20_enable.asm"

reloc:
  ; relocate bootloader
  BIOS_RELOC

_start:
  ; print greeting
  BIOS_PRINT MSG_GREETING

  ; disable all interrupts
  call disable_interrupts

  ; enable a20 line
  call a20_enable

  test ax, ax
  jz boot_error
  ; TODO

boot_error:
  jmp boot_error

%include "constants.asm"

times 510-($-$$) db 0 ; zero out rest of section
dw BOOT_ID            ; add boot signature (needed by QEMU)
