bits 16

[ORG 0x7c00] ; program expects to be loaded at this address

%include "bios_print.asm"

global _start

_start:
  ; zero DS
  xor ax, ax
  mov ds, ax

  ; print greeting
  BIOS_PRINT MSG_GREETING

loop:
  jmp loop

  ; constants
  MSG_GREETING db 'Hello from the bootloader', 0

  times 510-($-$$) db 0 ; zero out rest of section
  dw 0xAA55             ; add boot signature (needed by QEMU)
