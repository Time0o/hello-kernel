# programs
AS := nasm
ASFLAGS := -f bin -i asm

# OS
OS = os

# bootloader
BOOT_SRC := asm/boot.asm
BOOT_BIN := out/boot.s

# images
FLOPPY_IMG := imgs/$(OS).flp
IMGS := $(FLOPPY_IMG)

# emulator
QEMU := qemu-system-x86_64
QEMU_COMMON_OPTS := -nographic

all: $(BOOT_BIN) $(IMGS)

# boot loader
$(BOOT_BIN): $(wildcard asm/*)
	$(AS) $(ASFLAGS) $(BOOT_SRC) -o $@

# floppy image
$(FLOPPY_IMG): $(BOOT_BIN)
	dd if=/dev/zero of=$@ bs=512 count=1000
	dd if=$< of=$@ bs=512 count=1 conv=notrunc

# phony targets
.PHONY: clean, boot_floppy

clean:
	rm $(BOOT_BIN) $(IMGS)

boot_floppy:
	$(QEMU) $(QEMU_COMMON_OPTS) -drive format=raw,file=$(FLOPPY_IMG),index=0,if=floppy
