# common
GCCFLAGS_COMMON := -m32 -fno-PIC
GCCFLAGS_COMMON += -g
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
CXXFLAGS += -std=c++17
CXXFLAGS += -ffreestanding -fno-rtti -fno-exceptions -fno-threadsafe-statics -fno-stack-protector

# linker
LD := ld

define ldpp
  $(CC) $(CPPFLAGS) -E -x c $(1) | grep -v "^#" > $(2)
endef

LDFLAGS = -melf_i386
