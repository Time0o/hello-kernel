%macro BIOS_PRINT 1

  cld              ; clear DF flag in EFLAGS register, this makes lodsb increment SI
  mov si, word %1

bios_print_loop:
  lodsb            ; load character at DS:SI into AL
  test al, al
  jz bios_print_done
  mov ah, 0x0E     ; int 0x10 arg: print character in AL
  mov bh, 0        ; int 0x10 arg: page number
  int 0x10         ; video service interrupt
  jmp bios_print_loop
bios_print_done:

%endmacro
