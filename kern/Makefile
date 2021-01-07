ROOT_DIR = ..
MAKE_DIR = $(ROOT_DIR)/make

include $(MAKE_DIR)/project.mk
include $(MAKE_DIR)/build.mk
include $(MAKE_DIR)/disk.mk

# files
KERN_BASENAME := kern

KERN_ENTRY_ASM     := $(ASM_DIR)/$(KERN_BASENAME)_entry.S
KERN_ENTRY_ASM_OBJ := $(OUT_DIR)/$(KERN_BASENAME)_entry.o
KERN_OBJS          := $(KERN_ENTRY_ASM_OBJ) \
                      $(patsubst $(CXX_DIR)/%.cpp,$(OUT_DIR)/%.o,$(wildcard $(CXX_DIR)/*.cpp))
KERN_LNK           := $(LNK_DIR)/$(KERN_BASENAME).ld
KERN_LNK_PP        := $(OUT_DIR)/$(KERN_BASENAME).ld

# flags
CXXFLAGS += -O0
LDFLAGS  += -T$(KERN_LNK_PP)

# targets
all: $(KERN_IMG)

# objects
$(KERN_ENTRY_ASM_OBJ): $(KERN_ENTRY_ASM) $(CFG)
	$(AS) $(ASFLAGS) -c $< -o $@

$(OUT_DIR)/%.o: $(CXX_DIR)/%.cpp $(wildcard $(INC_DIR)/*.hpp)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# linker script
$(KERN_LNK_PP): $(KERN_LNK)
	$(call ldpp,$<,$@)

# ELF
$(KERN_ELF): $(KERN_OBJS) $(KERN_LNK_PP)
	$(LD) $(LDFLAGS) $(KERN_OBJS) -o $@

# clean
clean:
	rm -f $(OUT_DIR)/* $(KERN_ELF) $(KERN_IMG)
