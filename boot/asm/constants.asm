%define KB(n) (n * 1024)
%define MB(n) (n * 1024 * 1024)

BOOT_ID equ 0xAA55
BOOT_ID_OFFS equ 0x7FE
BOOT_ID_OFFS_PLUS_1MB_SEGMENT equ 0xFFFF
BOOT_ID_OFFS_PLUS_1MB_OFFS equ BOOT_ID_OFFS + MB(1) - (BOOT_ID_OFFS_PLUS_1MB_SEGMENT << 4)

BOOT_SEGMENT equ 0x60
BOOT_SECTORS equ 1

BOOT_STACKSIZE equ KB(32)

%define MSG(NAME, CONTENT) NAME db CONTENT, 0xA, 0xD, 0

MSG(MSG_GREETING, 'Hello from the bootloader')
MSG(MSG_RELOC_FAILURE, 'Failed to relocate bootloader')
MSG(MSG_A20_TRY_BIOS, 'Trying to enable A20 line via BIOS interrupt')
MSG(MSG_A20_SUCCESS, 'Successfully enabled A20 line')
MSG(MSG_A20_FAILURE, 'Failed to enable A20 line')
