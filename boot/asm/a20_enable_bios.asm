a20_enable_bios:
  mov ax, 0x2403 ; check A20 gate support
  int 0x15
  jc a20_enable_bios_failure

  mov ax, 0x2401 ; enable A20 gate
  int 0x15
  jc a20_enable_bios_failure

  mov ax, 1
  jmp a20_enable_bios_done

a20_enable_bios_failure:
  mov ax, 0

a20_enable_bios_done:
  ret
