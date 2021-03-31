extern "C" void kernel_start();

#include <cstdint>

#include "asm.hpp"
#include "cons.hpp"

extern uint8_t __bss_start;
extern uint8_t __bss_end;

void zero_bss()
{
  uint8_t *bss_start = reinterpret_cast<uint8_t *>(&__bss_start);
  uint8_t *bss_end = reinterpret_cast<uint8_t *>(&__bss_end);

  for (uint8_t *bss_addr = bss_start; bss_addr < bss_end; ++bss_addr)
    *bss_addr = 0x00;
}

void print_greeting()
{
  puts("\nhello from the kernel\n");
}

void kernel_start()
{
  zero_bss();

  print_greeting();

  x86::halt();
}
