#pragma once

#include <cstdint>

extern uint8_t __bss_start;
extern uint8_t __bss_end;

namespace bss {

inline uint8_t *start { reinterpret_cast<uint8_t *>(&__bss_start) };
inline uint8_t *end { reinterpret_cast<uint8_t *>(&__bss_end) };

inline void init()
{
  for (uint8_t *addr { start }; addr < end; ++addr)
    *addr = 0x00;
}

} // end namespace bss
