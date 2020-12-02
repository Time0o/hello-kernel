# pragma once

#define KB(n) (n * 1024)
#define MB(n) (n * KB(1024))

#define PAGE_SIZE (DISK_SECT_SIZE << 3)

#define BOOT_SIG 0xAA55
#define BOOT_SIG_SEG 0x0000
#define BOOT_SIG_OFFS 0x7DFE
#define BOOT_SIG_A20_SEG 0xFFFF
#define BOOT_SIG_A20_OFFS (BOOT_SIG_OFFS + MB(1) - (BOOT_SIG_A20_SEG << 4))

#define BOOT_STACK_TOP 0x80000
#define BOOT_STACK_SEG (BOOT_STACK_TOP >> 4)

#define KERN_LOAD_ADDR 0x100000
#define KERN_LINK_ADDR 0xf0100000
