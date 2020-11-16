bits 16

%include "bios_print.asm"

global _start

_start:
  ; zero DS
  xor ax, ax
  mov ds, ax

  ; print greeting
  cld

  BIOS_PRINT MSG_GREETING

loop:
  jmp loop

  ; constants
  MSG_GREETING db 'Hello from the bootloader', 0

  times 510-($-$$) db 0 ; zero out rest of section
  dw 0xAA55             ; add boot signature (needed by QEMU)
