ROOT_DIR = ..
MAKE_DIR = $(ROOT_DIR)/make

include $(MAKE_DIR)/project.mk
include $(MAKE_DIR)/build.mk

# files
KERN_BASENAME := kern

KERN_OBJS   := $(patsubst $(CPP_DIR)/%.cpp,$(OUT_DIR)/%.o,$(wildcard $(CPP_DIR)/*.cpp))
KERN_LNK    := $(LNK_DIR)/$(KERN_BASENAME).ld
KERN_LNK_PP := $(OUT_DIR)/$(KERN_BASENAME).ld

# flags
LDFLAGS += -T$(KERN_LNK_PP)

# targets
all: $(KERN_IMG)

# objects
$(OUT_DIR)/%.o: $(CPP_DIR)/%.cpp
	$(CC) $(CXXFLAGS) -c $< -o $@

# linker script
$(KERN_LNK_PP): $(KERN_LNK)
	$(call preprocess_linker_script,$<,$@)

# ELF
$(KERN_ELF): $(KERN_OBJS) $(KERN_LNK_PP)
	$(LD) $(LDFLAGS) $(KERN_OBJS) -o $@

# image
$(KERN_IMG): $(KERN_ELF)
	ln -s $$(readlink -f $<) $@

# clean
clean:
	rm -f $(OUT_DIR)/* $(KERN_ELF) $(KERN_IMG)
