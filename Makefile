ROOT_DIR := .
MAKE_DIR := $(ROOT_DIR)/make

include $(MAKE_DIR)/project.mk
include $(MAKE_DIR)/disk.mk

# targets
all: boot kern

# disk image
.PHONY: boot kern

boot:
	make -C $(BOOT_DIR)

kern:
	make -C $(KERN_DIR)

disk: boot kern
	dd if=/dev/zero of=$(DISK_IMG) bs=$(DISK_SECT_SIZE) count=$(DISK_SECT_COUNT) 2> /dev/null
	dd if=$(BOOT_IMG) of=$(DISK_IMG) bs=$(DISK_SECT_SIZE) count=$(BOOT_SECT_COUNT)1 conv=notrunc 2>/dev/null
	dd if=$(KERN_IMG) of=$(DISK_IMG) bs=$(DISK_SECT_SIZE) seek=$(BOOT_SECT_COUNT) conv=notrunc 2>/dev/null

# qemu
QEMU := qemu-system-i386
QEMU_OPTS := -nographic
QEMU_DBG_OPTS := -S -s

.PHONY: qemu qemu_dbg

qemu_boot = $(QEMU) $(QEMU_OPTS) -drive format=raw,file=$(1)

define qemu_check_disk
  if [ ! -f "$(DISK_IMG)" ]; then \
    echo "run 'disk' target first" >&2; \
    exit 1; \
  fi;
endef

define qemu_dbg_boot
  tmux \
    new-session '$(QEMU) $(QEMU_OPTS) -drive format=raw,file=$(1) $(QEMU_DBG_OPTS)' \; \
    split-window 'gdb -q $(2) $(BOOT_RELOC_ADDR) \
                      -ex "target remote localhost:1234" \
                      -ex "set confirm off" \
                      -ex "add-symbol-file $(2) $(BOOT_RELOC_ADDR)" \
                      -ex "set confirm on" \
                      -ex "break bootloader_start" \
                      -ex "continue" \
                      -ex "shell clear" \
                      -ex "layout src"' \; \
    select-layout even-horizontal
endef

qemu:
	@$(call qemu_check_disk)
	$(call qemu_boot,$(DISK_IMG))

qemu_dbg:
	@$(call qemu_check_disk)
	$(call qemu_dbg_boot,$(DISK_IMG),$(BOOT_ELF))

# clean
.PHONY: clean

clean:
	make -C boot clean
	make -C kern clean
	rm -f $(DISK_IMG)
