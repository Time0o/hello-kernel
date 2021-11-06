#pragma once

#define PAGE_SIZE           (DISK_SECT_SIZE << 3)
#define PAGE_ROUND_UP(x)    ((static_cast<uint32_t>(x) + PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
#define PAGE_ROUND_DOWN(x)  (static_cast<uint32_t>(x) & ~(PAGE_SIZE - 1))

#define KERN_LINK_ADDR            0xF0100000
#define KERN_LOAD_ADDR            0x100000
#define KERN_PT_KENTRY_LOAD_ADDR  KERN_LOAD_ADDR
#define KERN_PD_KENTRY_LOAD_ADDR  KERN_PT_KENTRY_LOAD_ADDR + PAGE_SIZE
#define KERN_TEXT_LOAD_ADDR       KERN_PD_KENTRY_LOAD_ADDR + PAGE_SIZE
