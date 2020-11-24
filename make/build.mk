# common
GCCFLAGS_COMMON := -m32 -fno-PIC
GCCFLAGS_COMMON += -g -gdwarf
GCCFLAGS_COMMON += -Wall -Werror

# preprocessor
CPPFLAGS = -I$(INC_DIR)

# assembler
AS := gcc

ASFLAGS = $(GCCFLAGS_COMMON)
ASFLAGS += $(CPPFLAGS)

# compiler
CC := gcc
CXX := g++

CXXFLAGS = $(GCCFLAGS_COMMON)
CXXFLAGS += $(CPPFLAGS)
CXXFLAGS += -std=c++11
CXXFLAGS += -ffreestanding -fno-rtti -fno-exceptions -fno-threadsafe-statics

# linker
LD := ld

define ldpp
  $(CC) $(CPPFLAGS) -E -x c $(1) | grep -v "^#" > $(2)
endef

LDFLAGS = -melf_i386
