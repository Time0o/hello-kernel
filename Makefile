ROOT_DIR := .
MAKE_DIR := $(ROOT_DIR)/make

include $(MAKE_DIR)/project.mk
include $(MAKE_DIR)/disk.mk

# targets
all: boot

# disk image
.PHONY: boot

boot:
	make -C $(BOOT_DIR)

disk: boot
	dd if=/dev/zero of=$(DISK_IMG) bs=$(DISK_SECT_SIZE) count=$(DISK_SECT_COUNT) 2> /dev/null
	dd if=$(BOOT_IMG) of=$(DISK_IMG) bs=$(DISK_SECT_SIZE) count=1 conv=notrunc 2>/dev/null

# qemu
QEMU := qemu-system-i386
QEMU_OPTS := -nographic
QEMU_DBG_OPTS := -S -s

.PHONY: qemu qemu_dbg

boot_qemu = $(QEMU) $(QEMU_OPTS) -drive format=raw,file=$(1)

define boot_qemu_dbg
  tmux \
    new-session '$(QEMU) $(QEMU_OPTS) -drive format=raw,file=$(1) $(QEMU_DBG_OPTS)' \; \
    split-window 'gdb -q $(2) \
                      -ex "target remote localhost:1234" \
                      -ex "break bootloader_start" \
                      -ex "continue" \
                      -ex "shell clear" \
                      -ex "layout src"' \; \
    select-layout even-horizontal
endef

qemu:
	$(call boot_qemu,$(DISK_IMG))

qemu_dbg:
	$(call boot_qemu_dbg,$(DISK_IMG),$(BOOT_ELF))

# clean
.PHONY: clean

clean:
	make -C boot clean
	rm -f $(DISK_IMG)
