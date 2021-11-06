# pragma once

#define BOOT_SIG 0xAA55
#define BOOT_SIG_SEG 0x0000
#define BOOT_SIG_OFFS 0x7DFE
#define BOOT_SIG_A20_SEG 0xFFFF
#define BOOT_SIG_A20_OFFS (BOOT_SIG_OFFS + (1 << 20) - (BOOT_SIG_A20_SEG << 4))

#define BOOT_STACK_TOP 0x80000
#define BOOT_STACK_SEG (BOOT_STACK_TOP >> 4)
