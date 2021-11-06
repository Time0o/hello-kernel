#include "mem.hpp"

#define CR0_PE 0x00000001
#define CR0_WP 0x00010000
#define CR0_PG 0x80000000

.global _start

_start = KERN_TEXT_LOAD_ADDR

_start_virtual:
  // Map the first 4MB of physical memory to the link address of the kernel via
  // a single static page table. We will map the rest of the kernel address
  // space later on.
  movl $KERN_PD_KENTRY_LOAD_ADDR, %eax
  movl %eax, %cr3

  movl %cr0, %eax
  orl $(CR0_PE | CR0_WP | CR0_PG), %eax
  movl %eax, %cr0

  // Start running kernel at the correct virtual address, the move prevents the
  // assembler from inserting a relative jump here.
  mov $kernel_start, %eax
  jmp *%eax
