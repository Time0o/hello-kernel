#pragma once

#include <cstdint>

#include "asm.hpp"

namespace cmos {

enum : uint16_t
{
  PORT_SELECT = 0x70,
  PORT_INOUT = 0x71
};

enum : uint8_t
{
  REG_MEM_LOW_LO = 0x15,
  REG_MEM_EXT_1MB_LO = 0x17,
  REG_MEM_EXT_16MB_LO = 0x30,
  REG_NMI_ENABLE_MASK = 0x7F,
  REG_NMI_DISABLE_MASK = 0x80
};

inline uint8_t read(uint8_t reg)
{
  x86::outb(PORT_SELECT, reg | (REG_NMI_DISABLE_MASK));
  return x86::inb(PORT_INOUT);
}

} // end namespace cmos
