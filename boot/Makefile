ROOT_DIR = ..
MAKE_DIR = $(ROOT_DIR)/make

include $(MAKE_DIR)/project.mk
include $(MAKE_DIR)/build.mk
include $(MAKE_DIR)/disk.mk

# files
BOOT_BASENAME := boot

BOOT_ASM       := $(ASM_DIR)/$(BOOT_BASENAME).asm
BOOT_ASM_FILES := $(wildcard $(ASM_DIR)/*.asm)
BOOT_ASM_PP    := $(OUT_DIR)/$(BOOT_BASENAME).asm
BOOT_ASM_OBJ   := $(OUT_DIR)/$(BOOT_BASENAME)_asm.o
BOOT_CXX       := $(CXX_DIR)/$(BOOT_BASENAME).cpp
BOOT_CXX_OBJ   := $(OUT_DIR)/$(BOOT_BASENAME)_cpp.o
BOOT_LNK       := $(LNK_DIR)/$(BOOT_BASENAME).ld
BOOT_LNK_PP    := $(OUT_DIR)/$(BOOT_BASENAME).ld

# flags
CXXFLAGS += -Os -fomit-frame-pointer

LDPPFLAGS += -DBOOT_ASM_OBJ=$(BOOT_ASM_OBJ)
LDFLAGS += -T$(BOOT_LNK_PP)

# targets
all: $(BOOT_IMG)

# objects
$(BOOT_ASM_PP): $(BOOT_ASM_FILES)
	$(call preprocess_asm,$(BOOT_ASM),$@)

$(BOOT_ASM_OBJ): $(BOOT_ASM_PP)
	$(AS) $(ASFLAGS) $< -o $@

$(BOOT_CXX_OBJ): $(BOOT_CXX)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# linker script
$(BOOT_LNK_PP): $(BOOT_LNK)
	$(call preprocess_linker_script,$<,$@)

# ELF
$(BOOT_ELF): $(BOOT_ASM_OBJ) $(BOOT_CXX_OBJ) $(BOOT_LNK_PP)
	$(LD) $(LDFLAGS) $(BOOT_ASM_OBJ) $(BOOT_CXX_OBJ) -o $@

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
