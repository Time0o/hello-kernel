#pragma once

#include <cstdint>

#include "asm.hpp"

struct Disk_driver
{
  virtual void read_sects(uint32_t pa_dest,
                          uint64_t da_src,
                          uint16_t sect_count) const = 0;
};

class Disk_iface
{
public:
  Disk_iface(Disk_driver const *drv)
  : _drv(drv)
  {}

  void read(uint32_t pa_dest, uint32_t da_src, uint32_t count) const
  {
    _drv->read_sects(sect_floor(pa_dest),
                     da_src / DISK_SECT_SIZE,
                     sect_count_ceil(count));
  }

private:
  static uint32_t sect_floor(uint32_t pa)
  { return pa & ~(DISK_SECT_SIZE - 1u); }

  static uint32_t sect_count_ceil(uint32_t count)
  { return (count + (DISK_SECT_SIZE - 1u)) / DISK_SECT_SIZE; }

  Disk_driver const *_drv;
};

class Disk_driver_ata : public Disk_driver
{
  enum : uint32_t
  {
    ATA_PORT_DATA = 0x1F0,
    ATA_PORT_SECT_COUNT = 0x1F2,
    ATA_PORT_LBA_LO = 0x1F3,
    ATA_PORT_LBA_MID = 0x1F4,
    ATA_PORT_LBA_HI = 0x1F5,
    ATA_PORT_DRIVE_HEAD = 0x1F6,
    ATA_PORT_STATUS = 0x1F7,
    ATA_PORT_CMD = 0x1F7
  };

  enum : uint8_t
  {
    ATA_PIO48_MASTER = 0x40,
    ATA_PIO48_CMD_READ = 0x24,
    ATA_STATUS_BSY = 0x80,
    ATA_STATUS_DRQ = 0x08
  };

public:
  void read_sects(uint32_t pa_dest,
                  uint64_t sect_offs,
                  uint16_t sect_count) const override
  { read_sects_pio48(pa_dest, sect_offs, sect_count); }

private:
  static void read_sects_pio48(uint32_t pa_dest,
                               uint64_t sect_offs,
                               uint16_t sect_count)
  {
    x86::outb(ATA_PORT_DRIVE_HEAD, ATA_PIO48_MASTER);

    x86::outb(ATA_PORT_SECT_COUNT, (sect_count >> 8) & 0xFF);
    x86::outb(ATA_PORT_LBA_LO, (sect_offs >> 24) & 0xFF);
    x86::outb(ATA_PORT_LBA_MID, (sect_offs >> 32) & 0xFF);
    x86::outb(ATA_PORT_LBA_HI, (sect_offs >> 40) & 0xFF);
    x86::outb(ATA_PORT_SECT_COUNT, sect_count & 0xFF);
    x86::outb(ATA_PORT_LBA_LO, sect_offs & 0xFF);
    x86::outb(ATA_PORT_LBA_MID, (sect_offs >> 8) & 0xFF);
    x86::outb(ATA_PORT_LBA_HI, (sect_offs >> 16) & 0xFF);

    x86::outb(ATA_PORT_CMD, ATA_PIO48_CMD_READ);

    for (uint8_t sec = 0u; sec < sect_count; ++sec) {
      poll();

      x86::insw(ATA_PORT_DATA, pa_dest, DISK_SECT_SIZE / 2);

      pa_dest += DISK_SECT_SIZE;
    }
  }

  static void poll()
  {
    for (;;) {
      uint8_t status = x86::in<uint8_t>(ATA_PORT_STATUS);
      if (!(status & ATA_STATUS_BSY) && (status & ATA_STATUS_DRQ))
        break;
    }
  }
};

// XXX more drivers

inline Disk_iface const &disk()
{
  static Disk_driver_ata disk_driver;
  static Disk_iface disk_iface(&disk_driver);

  return disk_iface;
}
