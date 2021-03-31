extern "C" void bootloader_start();

#include "asm.hpp"
#include "elf.hpp"

void bootloader_start()
{
  uint32_t boot_size = BOOT_SECT_COUNT * DISK_SECT_SIZE;

  Elf_file kernel(boot_size);

  kernel.load_headers(BOOT_RELOC_ADDR + boot_size);

  if (kernel.valid()) {
    kernel.load();
    kernel.run();
  }

  x86::halt();
}
