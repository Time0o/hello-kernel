%macro BIOS_RELOC 0
bios_reloc:
  mov ax, BOOT_SEGMENT
  mov es, ax

  mov ah, 0x02
  mov al, BOOT_SECTORS
  xor bx, bx
  mov ch, 0
  mov cl, 1
  xor dx, dx

  int 0x13

  jc bios_reloc_failure

  cmp al, 1
  jne bios_reloc_failure

  jmp BOOT_SEGMENT:bios_reloc_done

bios_reloc_failure:
  BIOS_PRINT MSG_RELOC_FAILURE
  jmp boot_error

bios_reloc_done:
  mov ax, BOOT_SEGMENT
  mov ds, ax
  mov es, ax
  mov ss, ax
  mov sp, BOOT_SEGMENT + BOOT_STACKSIZE
%endmacro
