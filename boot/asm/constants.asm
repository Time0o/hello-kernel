BOOT_ID equ 0xAA55

BOOT_SEGMENT equ 0x60
BOOT_SECTORS equ 1

BOOT_STACKSIZE equ 32 * 1024

%define MSG(NAME, CONTENT) NAME db CONTENT, 0xA, 0xD, 0

MSG(MSG_GREETING, 'Hello from the bootloader')
MSG(MSG_RELOC_FAILURE, 'Failed to relocate bootloader')
