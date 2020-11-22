ROOT_DIR = ..
MAKE_DIR = $(ROOT_DIR)/make

include $(MAKE_DIR)/project.mk
include $(MAKE_DIR)/build.mk
include $(MAKE_DIR)/disk.mk

# files
BOOT_BASENAME := boot

BOOT_ASM              := $(ASM_DIR)/$(BOOT_BASENAME).asm
BOOT_ASM_PREPROCESSED := $(OUT_DIR)/$(BOOT_BASENAME).asm
BOOT_ASM_OBJ          := $(OUT_DIR)/$(BOOT_BASENAME)_asm.o
BOOT_CPP              := $(CPP_DIR)/$(BOOT_BASENAME).cpp
BOOT_CPP_OBJ          := $(OUT_DIR)/$(BOOT_BASENAME)_cpp.o
BOOT_LNK              := $(LNK_DIR)/$(BOOT_BASENAME).ld
BOOT_LNK_PREPROCESSED := $(OUT_DIR)/$(BOOT_BASENAME).ld

# flags
CXXFLAGS += -Os -fomit-frame-pointer

LDPPFLAGS += -DBOOT_ASM_OBJ=$(BOOT_ASM_OBJ)
LDFLAGS += -T$(BOOT_LNK_PREPROCESSED)

# targets
all: $(BOOT_IMG)

# objects
$(BOOT_ASM_PREPROCESSED): $(wildcard $(ASM_DIR)/*.asm)
	$(AS) $(ASPPFLAGS) -E $(BOOT_ASM) | sed 's/^%line.*/\n/g' | cat -s > $@

$(BOOT_ASM_OBJ): $(BOOT_ASM_PREPROCESSED)
	$(AS) $(ASFLAGS) $< -o $@

$(BOOT_CPP_OBJ): $(BOOT_CPP)
	$(CC) $(CXXFLAGS) -c $< -o $@

# linker script
$(BOOT_LNK_PREPROCESSED): $(BOOT_LNK)
	$(CC) $(LDPPFLAGS) -E -x c $< | grep -v "^#" > $@

# ELF
$(BOOT_ELF): $(BOOT_ASM_OBJ) $(BOOT_CPP_OBJ) $(BOOT_LNK_PREPROCESSED)
	$(LD) $(LDFLAGS) $(BOOT_ASM_OBJ) $(BOOT_CPP_OBJ) -o $@

# image
define assert_boot_size
  FSIZE=$$(stat -c %s $(1)); \
  if (( $$(stat -c %s $(1)) > $(DISK_SECT_SIZE) )); then \
    echo "bootloader image too large" >&2; \
    exit 1; \
  fi;
endef

$(BOOT_IMG): $(BOOT_ELF)
	objcopy -O binary $< $@
	@$(call assert_boot_size,$@)

# clean
.PHONY: clean

clean:
	rm -f $(OUT_DIR)/* $(BOOT_ELF) $(BOOT_IMG)
