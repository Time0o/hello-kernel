# programs
AS := nasm
ASFLAGS := -i asm -O0 -Wall -Werror

# directories
ASM_DIR := asm
OUT_DIR := out
IMG_DIR := imgs

# OS
OS = os

# bootloader
BOOT_SRC := $(ASM_DIR)/boot.asm
BOOT_SRC_PREPROCESSED := $(OUT_DIR)/boot.asm
BOOT_OBJ := $(OUT_DIR)/boot.o
BOOT_ELF := $(OUT_DIR)/boot.elf
BOOT_IMG := $(OUT_DIR)/boot.img

# images
FLOPPY_IMG := $(IMG_DIR)/$(OS).flp
IMGS := $(BOOT_IMG) $(FLOPPY_IMG)

# emulator
QEMU := qemu-system-i386
QEMU_OPTS := -nographic
QEMU_DBG_OPTS := -S -s
QEMU_DBG_GDBINIT := gdbinit_real_mode.txt

all: $(IMGS)

# boot loader
$(BOOT_SRC_PREPROCESSED): $(wildcard $(ASM_DIR)/*.asm)
	$(AS) $(ASFLAGS) -E $(BOOT_SRC) | sed 's/^%line.*/\n/g' | cat -s > $@

$(BOOT_ELF): $(BOOT_SRC_PREPROCESSED)
	$(AS) $(ASFLAGS) -f elf32 -g -F dwarf $< -o $(BOOT_OBJ)
	ld -Ttext=0x0000 -melf_i386 $(BOOT_OBJ) -o $@

$(BOOT_IMG): $(BOOT_ELF)
	objcopy -O binary $< $@

# floppy image
$(FLOPPY_IMG): $(BOOT_IMG)
	dd if=/dev/zero of=$@ bs=512 count=2880
	dd if=$< of=$@ bs=512 count=1 conv=notrunc

# phony targets
.PHONY: clean, boot_floppy, boot_floppy_dbg

clean:
	rm -f $(OUT_DIR)/* $(IMG_DIR)/*

boot_qemu = $(QEMU) $(QEMU_OPTS) -drive format=raw,file=$(1),index=0,$(2)

define boot_qemu_dbg
  tmux \
    new-session '$(QEMU) $(QEMU_OPTS) -drive format=raw,file=$(1),index=0,$(3) $(QEMU_DBG_OPTS)' \; \
    split-window 'gdb $(2) \
                      -ex "target remote localhost:1234" \
                      -x $(QEMU_DBG_GDBINIT) \
                      -ex "add-symbol-file $(BOOT_ELF) 0x600" \
                      -ex "break _start" \
                      -ex "continue"' \; \
    select-layout even-vertical
endef

boot_floppy:
	$(call boot_qemu,$(FLOPPY_IMG),if=floppy)

boot_floppy_dbg:
	$(call boot_qemu_dbg,$(FLOPPY_IMG),$(BOOT_ELF),if=floppy)
