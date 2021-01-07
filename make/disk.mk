DISK_SECT_SIZE  := 512
DISK_SECT_COUNT := 2048

BOOT_SECT_COUNT := 4
BOOT_LOAD_ADDR  := 0x7C00
BOOT_RELOC_ADDR := 0x600

KERN_LOAD_ADDR := 0x100000

CPPFLAGS += -DDISK_SECT_SIZE=$(DISK_SECT_SIZE) \
            -DDISK_SECT_COUNT=$(DISK_SECT_COUNT) \
            -DBOOT_SECT_COUNT=$(BOOT_SECT_COUNT) \
            -DBOOT_LOAD_ADDR=$(BOOT_LOAD_ADDR) \
            -DBOOT_RELOC_ADDR=$(BOOT_RELOC_ADDR) \
            -DKERN_LOAD_ADDR=$(KERN_LOAD_ADDR)
