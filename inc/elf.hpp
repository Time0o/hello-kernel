#pragma once

#include <cstdint>

#include "disk.hpp"
#include "mem.hpp"

class Elf_file
{
  enum : uint32_t { ELF_MAGIC = 0x464c457f };

  using elf_addr = uint32_t;
  using elf_offs = uint32_t;

  struct Elf_hdr
  {
    uint32_t e_magic;
    uint8_t e_ident[12];
    uint16_t e_type;
    uint16_t e_machine;
    uint32_t e_version;
    elf_addr e_entry;
    elf_offs e_phoff;
    elf_offs e_shoff;
    uint32_t e_flags;
    uint16_t e_ehsize;
    uint16_t e_phentsize;
    uint16_t e_phnum;
    uint16_t e_shentsize;
    uint16_t e_shnum;
    uint16_t e_shstrndx;
  };

  struct Prog_hdr
  {
    uint32_t p_type;
    elf_offs p_offset;
    elf_addr p_va;
    elf_addr p_pa;
    uint32_t p_filesz;
    uint32_t p_memsz;
    uint32_t p_flags;
    uint32_t p_align;
  };

  // we currently don't care about the section header table

public:
  Elf_file(uint32_t da_src)
  : _da_src(da_src)
  {}

  void load_headers(uint32_t pa_dest)
  {
    disk().read(pa_dest, _da_src, PAGE_SIZE);

    _elf_hdr = reinterpret_cast<Elf_hdr const *>(pa_dest);
    _prog_hdr_tbl = reinterpret_cast<Prog_hdr const *>(pa_dest + _elf_hdr->e_phoff);
  }

  bool valid() const
  { return _elf_hdr && _prog_hdr_tbl && _elf_hdr->e_magic == ELF_MAGIC; }

  void load() const
  {
    auto const *ph = _prog_hdr_tbl;

    for (uint32_t i = 0u; i < _elf_hdr->e_phnum; ++i) {
      if (ph->p_memsz == 0u)
        continue;

      disk().read(ph->p_pa, ph->p_offset + _da_src, ph->p_memsz);

      ++ph;
    }
  }

  [[noreturn]] void run() const
  {
    void *entry = reinterpret_cast<void *>(_elf_hdr->e_entry);

    goto *entry;

    __builtin_unreachable();
  }

private:
  uint32_t _da_src;

  Elf_hdr const *_elf_hdr = nullptr;
  Prog_hdr const *_prog_hdr_tbl = nullptr;
};
