#pragma once

#include <cstdint>
#include <array>
#include <initializer_list>
#include <utility>

#include "mem.hpp"

template<uint32_t INDEX_SHIFT>
class PageLookup
{
public:
  enum { SIZE = 1024 };

private:
  enum : uint32_t
  {
    ADDR_SHIFT = 12,
    ADDR_MASK = (1 << (32 - ADDR_SHIFT)) - 1,
  };

public:
  class Entry
  {
  public:
    Entry() = default;

    template<typename ...FLAGS>
    explicit constexpr Entry(uint32_t addr, FLAGS &&...flags)
    : entry((addr & (ADDR_MASK << ADDR_SHIFT)) | (flags | ...))
    {}

    uint32_t entry;
  };

  enum Flags : uint16_t
  {
    W = 0x002, // Write-Through
    P = 0x001  // Present
  };

  using Mapping = std::pair<std::size_t, Entry>;

  constexpr PageLookup(std::initializer_list<Mapping> mappings)
  : _entries{}
  {
    for (auto [i, entry] : mappings)
      _entries[i] = entry;
  }

  using MappingRange = std::pair<std::pair<std::size_t, std::size_t>, Entry>;

  constexpr PageLookup(std::initializer_list<MappingRange> mapping_ranges)
  : _entries{}
  {
    for (auto [range, entry] : mapping_ranges) {
      auto [beg, end] = range;

      for (std::size_t i = beg; i < end; ++i) {
        _entries[i] = entry;
        entry.entry += (1 << INDEX_SHIFT);
      }
    }
  }

  static constexpr std::size_t idx(uint32_t addr)
  { return (addr >> INDEX_SHIFT) & (SIZE - 1); }

private:
  std::array<Entry, SIZE> _entries;
};

using PageTable = PageLookup<12>;
using PageDirectory = PageLookup<22>;
