# assembler
AS := nasm

ASFLAGS += -f elf32
ASFLAGS += -g -F dwarf
ASFLAGS += -Wall -Werror

# compiler
CC := gcc
CXX := g++

CXXFLAGS += -I $(INC_DIR)
CXXFLAGS += -m32 -fno-PIC
CXXFLAGS += -std=c++11
CXXFLAGS += -ffreestanding -fno-rtti -fno-exceptions -fno-threadsafe-statics
CXXFLAGS += -g -gdwarf
CXXFLAGS += -Wall -Werror

# linker
LD := ld

LDFLAGS := -melf_i386

# preprocessor
ASPPFLAGS := -I $(ASM_DIR)
CPPFLAGS := -I $(INC_DIR)
LDPPFLAGS := -I $(INC_DIR)

# utility functions
define preprocess_asm
  $(AS) $(ASPPFLAGS) -E $(1) | sed 's/^%line.*/\n/g' | cat -s > $(2)
endef

define preprocess_linker_script
  $(CC) $(LDPPFLAGS) -E -x c $(1) | grep -v "^#" > $(2)
endef
