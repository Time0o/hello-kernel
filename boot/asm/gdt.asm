%define GDT_ENTRY_NULL dq 0

%macro GDT_ENTRY 3
  dw %2 & 0xFFFF, %1 & 0xFFFF
  db (%1 >> 16) & 0xFF, 0x80 | %3, 0xC0 | ((%2 >> 16) & 0xF), (%1 >> 24) & 0xFF
%endmacro

GDT_S equ 0x10
GDT_EX equ 0x08
GDT_RW equ 0x02

GDT_SELECTOR_KERNEL_CODE equ 0x8
GDT_SELECTOR_KERNEL_DATA equ 0x10

%macro GDT 0
align 8

gdt_begin:
  GDT_ENTRY_NULL
  GDT_ENTRY 0x0, 0x000FFFFF, GDT_S | GDT_EX | GDT_RW
  GDT_ENTRY 0x0, 0x000FFFFF, GDT_S | GDT_RW
gdt_end:

gdt_descriptor:
  dw gdt_end - gdt_begin
  dd gdt_begin
%endmacro GDT
