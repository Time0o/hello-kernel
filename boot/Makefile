# programs
AS := nasm
ASFLAGS_ARCH := -f elf32
ASFLAGS_DBG := -g -F dwarf
ASFLAGS_WARN := -Wall -Werror
ASFLAGS := $(ASFLAGS_ARCH) $(ASFLAGS_DBG) $(ASFLAGS_WARN)

CC := g++
CXXFLAGS_ARCH := -m32 -fno-PIC
CXXFLAGS_STD := -std=c++11
CXXFLAGS_RUNTIME := -ffreestanding -fno-rtti -fno-exceptions -fno-threadsafe-statics
CXXFLAGS_COMPRESS := -Os -fomit-frame-pointer
CXXFLAGS_DBG := -g -gdwarf
CXXFLAGS_WARN := -Wall -Werror
CXXFLAGS := $(CXXFLAGS_ARCH) \
            $(CXXFLAGS_STD) \
            $(CXXFLAGS_RUNTIME) \
            $(CXXFLAGS_COMPRESS) \
            $(CXXFLAGS_DBG) \
            $(CXXFLAGS_WARN)

LD := ld
LDFLAGS := -Ttext=0x7C00 -melf_i386

# directories
ASM_DIR := asm
CPP_DIR := cpp
OUT_DIR := out
IMG_DIR := imgs

# OS
OS = os

# bootloader
BOOT_ASM := $(ASM_DIR)/boot.asm
BOOT_ASM_PREPROCESSED := $(OUT_DIR)/boot.asm
BOOT_ASM_OBJ := $(OUT_DIR)/boot_asm.o
BOOT_CPP := $(CPP_DIR)/boot.cpp
BOOT_CPP_OBJ := $(OUT_DIR)/boot_cpp.o
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
$(BOOT_ASM_PREPROCESSED): $(wildcard $(ASM_DIR)/*.asm)
	$(AS) -I $(ASM_DIR) -E $(BOOT_ASM) | sed 's/^%line.*/\n/g' | cat -s > $@

$(BOOT_ASM_OBJ): $(BOOT_ASM_PREPROCESSED)
	$(AS) $(ASFLAGS) $< -o $@

$(BOOT_CPP_OBJ): $(BOOT_CPP)
	$(CC) $(CXXFLAGS) -c $< -o $@

$(BOOT_ELF): $(BOOT_ASM_OBJ) $(BOOT_CPP_OBJ)
	$(LD) $(LDFLAGS) $^ -o $@

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
                      -ex "break protected_mode_start" \
                      -ex "continue"' \; \
    select-layout even-vertical
endef

boot_floppy:
	$(call boot_qemu,$(FLOPPY_IMG),if=floppy)

boot_floppy_dbg:
	$(call boot_qemu_dbg,$(FLOPPY_IMG),$(BOOT_ELF),if=floppy)
