protected_mode_enable:
  lgdt [gdt_descriptor]
  mov eax, cr0
  or al, 1
  mov cr0, eax

  ret
