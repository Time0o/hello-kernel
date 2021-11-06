#include "mem.hpp"
#include "page_lookup.hpp"

using PT = PageTable;
using PD = PageDirectory;

// Initial page table only used during kernel startup.
__attribute__((section(".pt_kentry")))
constexpr PT pt_kentry {
  // Map entry 0 to physical page zero, entry 1 to physical page 1 and so on
  // for the first 4MB of physical memory.
  { {0, PT::SIZE - 1}, PT::Entry{0x0, PT::W, PT::P} }
};

// Initial page directory only used during kernel startup.
__attribute__((section(".pd_kentry")))
constexpr PD pd_kentry {
  // Map the bottom 4MB of virtual memory to the bottom 4MB of physical memory.
  // This mapping is only used right after paging is enabled before the
  // instruction pointer is updated to a virtual kernel address.
  { 0, PD::Entry{KERN_PT_KENTRY_LOAD_ADDR, PD::W, PD::P} },

  // Map 4MB of the virtual address space starting at the link address of the
  // kernel to the same bottom 4MB of physical memory. We will later increase
  // the number of pages available to the kernel by creating mappings for the
  // entire virtual kernel address range 0xF0000000-0xFFFFFFFF.
  { PD::idx(KERN_LINK_ADDR), PD::Entry{KERN_PT_KENTRY_LOAD_ADDR, PD::W, PD::P} }
};
