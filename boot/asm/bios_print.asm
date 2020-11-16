bios_print:
  lodsb
  test al, al
  jz bios_print_done
  mov ah, 0x0E
  mov bh, 0
  int 0x10
  jmp bios_print

bios_print_done:
  ret

%macro BIOS_PRINT 1
  push si

  mov si, word %1
  call bios_print

  pop si
%endmacro
