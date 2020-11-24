a20_is_enabled:
  push %ds
  push %si
  push %es
  push %di

  xor %ax, %ax
  mov %ax, %ds
  mov $BOOT_SIG_OFFS, %si

  mov $BOOT_SIG_A20_SEG, %ax
  mov %ax, %es
  mov $BOOT_SIG_A20_OFFS, %di

  cmpw $BOOT_SIG, %es:(%di)

  mov $1, %ax
  jne a20_is_enabled_done

  movw %ds:(%si), %ax
  xor $0xFFFF, %ax
  movw %ax, %ds:(%si)

  cmpw $BOOT_SIG, %es:(%di)

  movw $BOOT_SIG, %ds:(%si)

  mov $1, %ax
  jne a20_is_enabled_done

  mov $0, %ax

a20_is_enabled_done:
  pop %di
  pop %es
  pop %si
  pop %ds

  ret
