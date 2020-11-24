#define GDT_ENTRY_NULL .quad 0

#define GDT_ENTRY(base, limit, access) \
  .word limit & 0xFFFF, base & 0xFFFF; \
  .byte (base >> 16) & 0xFF, 0x80 | access, 0xC0 | ((limit >> 16) & 0xF), (base >> 24) & 0xFF

#define GDT_S 0x10
#define GDT_EX 0x08
#define GDT_RW 0x02

#define GDT_SELECTOR_KERNEL_CODE 0x8
#define GDT_SELECTOR_KERNEL_DATA 0x10

.p2align 3

gdt_begin:
  GDT_ENTRY_NULL
  GDT_ENTRY(0x0, 0x000FFFFF, GDT_S | GDT_EX | GDT_RW)
  GDT_ENTRY(0x0, 0x000FFFFF, GDT_S | GDT_RW)
gdt_end:

gdt_descriptor:
  .word gdt_end - gdt_begin - 1
  .long gdt_begin
