#define BIOS_INT_DISK 0x13
#define BIOS_INT_DISK_READ_SECTORS 2

.macro BIOS_RELOC
  mov $BOOT_RELOC_ADDR >> 4, %ax
  mov %ax, %es
  xor %bx, %bx

  mov $BIOS_INT_DISK_READ_SECTORS, %ah
  mov $BOOT_SECT_COUNT, %al
  mov $0, %ch
  mov $1, %cl
  xor %dh, %dh

  int $BIOS_INT_DISK
.endm
