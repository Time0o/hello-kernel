#pragma once

inline void *memset(void *dst, int val, std::size_t count)
{
  // XXX Make this more efficient.

  char *dst_char = static_cast<char *>(dst);

  for (std::size_t i = 0; i < count; ++i)
    dst_char[i] = val & 0xFF;

  return dst;
}
