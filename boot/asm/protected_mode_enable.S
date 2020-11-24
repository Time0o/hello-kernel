protected_mode_enable:
  lgdt gdt_descriptor
  mov %cr0, %eax
  or $1, %al
  mov %eax, %cr0

  ret
