extern "C" void bootloader_start();

#include "elf.hpp"

void bootloader_start()
{
  Elf_file kernel(KERN_LOAD_ADDR, BOOT_SECT_COUNT * DISK_SECT_SIZE);

  kernel.load_header();

  if (kernel.valid()) {
    kernel.load();
    kernel.run();
  }

  for (;;)
    ; // TODO: print error, halt
}
