#define CR0_PROTECTED_MODE_ENABLE_MASK 0x1

.macro PROTECTED_MODE_ENABLE
  lgdt gdt_descriptor
  mov %cr0, %eax
  or $CR0_PROTECTED_MODE_ENABLE_MASK, %al
  mov %eax, %cr0
.endm
