# directories
ASM_DIR := asm
CPP_DIR := cpp
INC_DIR := inc
LNK_DIR := lnk
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
BOOT_LNK := $(LNK_DIR)/boot.ld
BOOT_LNK_PREPROCESSED := $(OUT_DIR)/boot.ld
BOOT_ELF := $(OUT_DIR)/boot.elf
BOOT_IMG := $(OUT_DIR)/boot.img

# images
DISK_IMG := $(IMG_DIR)/$(OS).img
DISK_IMG_BS := 512
DISK_IMG_COUNT := 2048
IMGS := $(BOOT_IMG) $(DISK_IMG)

# emulator
QEMU := qemu-system-i386
QEMU_OPTS := -nographic
QEMU_DBG_OPTS := -S -s
QEMU_DBG_GDBINIT := gdbinit_real_mode.txt

# assembler
AS := nasm

ASFLAGS += -f elf32
ASFLAGS += -g -F dwarf
ASFLAGS += -Wall -Werror

ASFLAGS_PP := -I $(ASM_DIR)

# compiler
CC := g++

CXXFLAGS += -m32 -fno-PIC
CXXFLAGS += -std=c++11
CXXFLAGS += -ffreestanding -fno-rtti -fno-exceptions -fno-threadsafe-statics
CXXFLAGS += -Os -fomit-frame-pointer
CXXFLAGS += -g -gdwarf
CXXFLAGS += -Wall -Werror

# linker
LD := ld

LDFLAGS := -T$(BOOT_LNK_PREPROCESSED) -melf_i386

LDFLAGS_PP := -DBOOT_ASM_OBJ=$(BOOT_ASM_OBJ) -I $(INC_DIR)

# targets
all: $(IMGS)

# objects
$(BOOT_ASM_PREPROCESSED): $(wildcard $(ASM_DIR)/*.asm)
	$(AS) $(ASFLAGS_PP) -E $(BOOT_ASM) | sed 's/^%line.*/\n/g' | cat -s > $@

$(BOOT_ASM_OBJ): $(BOOT_ASM_PREPROCESSED)
	$(AS) $(ASFLAGS) $< -o $@

$(BOOT_CPP_OBJ): $(BOOT_CPP)
	$(CC) $(CXXFLAGS) -c $< -o $@

# linker script
$(BOOT_LNK_PREPROCESSED): $(BOOT_LNK)
	$(CC) $(LDFLAGS_PP) -E -x c $< | grep -v "^#" > $@

# ELF
$(BOOT_ELF): $(BOOT_ASM_OBJ) $(BOOT_CPP_OBJ) $(BOOT_LNK_PREPROCESSED)
	$(LD) $(LDFLAGS) $(BOOT_ASM_OBJ) $(BOOT_CPP_OBJ) -o $@

# images
define assert_boot_size
  FSIZE=$$(stat -c %s $(1)); \
  if (( $$(stat -c %s $(1)) > $(DISK_IMG_BS) )); then \
    echo "bootloader image too large" >&2; \
    exit 1; \
  fi;
endef

$(BOOT_IMG): $(BOOT_ELF)
	objcopy -O binary $< $@
	$(call assert_boot_size,$@)

$(DISK_IMG): $(BOOT_IMG)
	dd if=/dev/zero of=$@ bs=$(DISK_IMG_BS) count=$(DISK_IMG_COUNT)
	dd if=$< of=$@ bs=$(DISK_IMG_BS) count=1 conv=notrunc

# phony targets
.PHONY: clean, boot, boot_dbg

clean:
	rm -f $(OUT_DIR)/* $(IMG_DIR)/*

boot_qemu = $(QEMU) $(QEMU_OPTS) -drive format=raw,file=$(1),index=0,$(2)

define boot_qemu_dbg
  tmux \
    new-session '$(QEMU) $(QEMU_OPTS) -drive format=raw,file=$(1) $(QEMU_DBG_OPTS)' \; \
    split-window 'gdb $(2) \
                      -ex "target remote localhost:1234" \
                      -ex "break bootloader_start" \
                      -ex "continue"' \; \
    select-layout even-vertical
endef

boot:
	$(call boot_qemu,$(DISK_IMG))

boot_dbg:
	$(call boot_qemu_dbg,$(DISK_IMG),$(BOOT_ELF))
