bits 16

[ORG 0x7c00] ; program expects to be loaded at this address

global _start

_start:
  xor ax, ax
  mov ds, ax

  mov si, MSG_GREETING
  cld          ; clear DF flag in EFLAGS register, this makes lodsb increment SI
print:
  lodsb        ; load character at DS:SI into AL
  test al, al
  jz loop
  mov ah, 0x0E ; int 0x10 arg: print character in AL
  mov bh, 0    ; int 0x10 arg: page number
  int 0x10     ; video service interrupt
  jmp print

loop:
  jmp loop

  MSG_GREETING db 'Hello from the bootloader', 0

  times 510-($-$$) db 0 ; zero out rest of section
  dw 0xAA55             ; add boot signature (needed by QEMU)
