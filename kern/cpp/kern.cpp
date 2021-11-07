extern "C" void kernel_start();

#include <cstdint>

#include "asm.hpp"
#include "bss.hpp"
#include "cons.hpp"
#include "kmem.hpp"

void print_greeting()
{
  puts("\nhello from the kernel\n");
}

void kernel_start()
{
  // Initialize BSS.
  bss::init();

  // Initialize dynamic memory.
  kmem().init();

  print_greeting();

  x86::halt();
}
