bits 16

global _start

cld

jmp reloc

%include "bios_print.asm"
%include "bios_reloc.asm"

reloc:
  ; relocate bootloader
  BIOS_RELOC

_start:
  ; print greeting
  BIOS_PRINT MSG_GREETING

  ; TODO

boot_error:
  jmp boot_error

%include "constants.asm"

times 510-($-$$) db 0 ; zero out rest of section
dw BOOT_ID            ; add boot signature (needed by QEMU)
