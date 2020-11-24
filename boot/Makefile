ROOT_DIR = ..
MAKE_DIR = $(ROOT_DIR)/make

include $(MAKE_DIR)/project.mk
include $(MAKE_DIR)/build.mk
include $(MAKE_DIR)/disk.mk

# files
BOOT_BASENAME := boot

CFG            := $(INC_DIR)/config.hpp
BOOT_ASM       := $(ASM_DIR)/$(BOOT_BASENAME).S
BOOT_ASM_FILES := $(wildcard $(ASM_DIR)/*.S)
BOOT_ASM_PP    := $(OUT_DIR)/$(BOOT_BASENAME).S
BOOT_ASM_OBJ   := $(OUT_DIR)/$(BOOT_BASENAME)_S.o
BOOT_CXX       := $(CXX_DIR)/$(BOOT_BASENAME).cpp
BOOT_CXX_OBJ   := $(OUT_DIR)/$(BOOT_BASENAME)_cpp.o
BOOT_LNK       := $(LNK_DIR)/$(BOOT_BASENAME).ld
BOOT_LNK_PP    := $(OUT_DIR)/$(BOOT_BASENAME).ld

# flags
CPPFLAGS += -DBOOT_ASM_OBJ=$(BOOT_ASM_OBJ) -DBOOT_CXX_OBJ=$(BOOT_CXX_OBJ)
CXXFLAGS += -Os -fomit-frame-pointer
LDFLAGS  += -T$(BOOT_LNK_PP)

# targets
all: $(BOOT_IMG)

# objects
$(BOOT_ASM_OBJ): $(BOOT_ASM_FILES) $(CFG)
	$(AS) $(ASFLAGS) -c $(BOOT_ASM) -o $@

$(BOOT_CXX_OBJ): $(BOOT_CXX) $(CFG)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# linker script
$(BOOT_LNK_PP): $(BOOT_LNK) $(CFG)
	$(call ldpp,$<,$@)

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
