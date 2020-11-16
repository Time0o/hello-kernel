a20_is_enabled:
  push ds
  push si
  push es
  push di

  xor ax, ax
  mov ds, ax
  mov si, BOOT_ID_OFFS

  mov ax, BOOT_ID_OFFS_PLUS_1MB_SEGMENT
  mov es, ax
  mov di, BOOT_ID_OFFS_PLUS_1MB_OFFS

  cmp word [es:di], BOOT_ID

  mov ax, 1
  jne a20_is_enabled_done

  mov ax, word [ds:si]
  xor ax, 0xFFFF
  mov [ds:si], ax

  cmp word [es:di], BOOT_ID

  mov word [ds:si], BOOT_ID

  mov ax, 1
  jne a20_is_enabled_done

  mov ax, 0

a20_is_enabled_done:
  pop di
  pop es
  pop si
  pop ds

  ret
