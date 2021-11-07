#pragma once

#include <cstdint>
#include <cstring>
#include <utility>

#include "bss.hpp"
#include "cmos.hpp"
#include "mem.hpp"
#include "page_frame.hpp"
#include "string.hpp"

class KMem
{
  friend KMem &kmem();

public:
  void init()
  {
    alloc_init();
    mem_init();
  }

private:
  KMem() = default;

  void alloc_init()
  { _alloc_next_free = PAGE_ROUND_UP(reinterpret_cast<uint32_t>(bss::end)); }

  template<typename T>
  T *alloc(uint32_t bytes, bool zero = false)
  {
    // XXX Check if memory is available.

    void *mem { reinterpret_cast<void *>(_alloc_next_free) };

    _alloc_next_free = PAGE_ROUND_UP(_alloc_next_free + bytes);

    if (zero)
      std::memset(mem, 0, bytes);

    return static_cast<T *>(mem);
  }

  void mem_init()
  {
    auto [mem_low, mem_ext] { mem_size() };

    // Total number of page frames.
    uint32_t num_page_frames { (mem_low + mem_ext) / PAGE_SIZE };

    // Initialize page frame list / free list.
    _page_frames = alloc<PageFrame>(num_page_frames * sizeof(PageFrame), true);
    _page_frames_free = nullptr;

    // Check whether physical address falls into upper memory region.
    auto is_upper { [&](uint32_t phys_addr){
      return phys_addr >= mem_low && phys_addr < MB(1);
    } };

    // Check whether physical address falls into upper memory already used by kernel.
    auto is_kernel { [&](uint32_t phys_addr){
      return phys_addr >= KERN_MEM_LOAD_ADDR &&
             phys_addr < _alloc_next_free - KERN_MEM_LINK_ADDR ;
    } };

    // XXX This still ignores real mode data structures / possible memory holes.

    for (uint32_t i { num_page_frames }; i >= 1; --i) {
      PageFrame *next { nullptr }, *next_free { nullptr };

      if (i < num_page_frames)
        next = _page_frames + (i + 1);

      // Check if page frame is already in use.
      uint32_t phys_addr { (i - 1) * PAGE_SIZE };

      if (!is_upper(phys_addr) && !is_kernel(phys_addr))
        next_free = _page_frames_free;

      // Append page frame to list / free list.
      _page_frames[i] = PageFrame{next, next_free};

      if (next_free)
        _page_frames_free = _page_frames + i;
    }
  }

  static std::pair<uint32_t, uint32_t> mem_size()
  {
    uint32_t mem_low, mem_ext_1mb, mem_ext_16mb, mem_ext;

    // KBs of low memory available.
    mem_low = mem_size(cmos::REG_MEM_LOW_LO);

    // KBs of memory available above 1MB.
    mem_ext_1mb = mem_size(cmos::REG_MEM_EXT_1MB_LO);

    // KBs of memory available above 16MB.
    mem_ext_16mb = mem_size(cmos::REG_MEM_EXT_16MB_LO);

    if (mem_ext_16mb > 0) {
      mem_ext = MB(15) + mem_ext_16mb * KB(1);
    } else if (mem_ext_1mb > 0) {
      mem_ext = mem_ext_16mb * KB(1);
    } else {
      mem_ext = 0;
    }

    return { mem_low, mem_ext };
  }

  static uint16_t mem_size(uint8_t reg_lo)
  {
    auto mem_lo { static_cast<uint16_t>(cmos::read(reg_lo)) };
    auto mem_hi { static_cast<uint16_t>(cmos::read(reg_lo + 1)) };

    return (mem_hi << 8) | mem_lo;
  }

  uint32_t _alloc_next_free;

  PageFrame *_page_frames;
  PageFrame *_page_frames_free;
};

inline KMem &kmem()
{
  static KMem inst;
  return inst;
}
