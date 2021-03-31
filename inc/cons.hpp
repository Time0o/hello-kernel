#pragma once

#include <cstdint>

#include "asm.hpp"

class Cons_serial
{
  enum : uint16_t
  {
    COM1 = 0x3F8,
  };

  enum
  {
    COM_BAUD_RATE = 9600,
    COM_BAUD_RATE_MAX = 115200
  };

  enum
  {
    COM_RBR = 0,
    COM_THR = 0,
    COM_DLL = 0,
    COM_IER = 1,
    COM_DLM = 1,
    COM_IIR = 2,
    COM_FCR = 2,
    COM_LCR = 3,
    COM_MCR = 4,
    COM_LSR = 5,
    COM_MSR = 6,
    COM_SCR = 7
  };

  enum : uint8_t
  {
    COM_DLAB_ENABLE = 0x80,
    COM_LINE_PROTOCOL_8N1 = 0x03,
    COM_FIFO_ENABLE = 0xC7,
    COM_IRQ_ENABLE = 0x0B,
    COM_LOOPBACK_MODE = 0x1E,
    COM_NORMAL_MODE = 0x0F,
    COM_INT_RECEIVE_ENABLE = 0x01,
    COM_TRANSMIT_READY = 0x20
  };

public:
  Cons_serial()
  : _enabled(com_enable(COM1))
  {}

  bool enabled() const
  { return _enabled; }

  void putc(int c)
  {
    while (!(x86::inb(COM1 + COM_LSR) & COM_TRANSMIT_READY))
      ;

    x86::outb(COM1 + COM_THR, c & 0xFF);
  }

private:
  static bool com_enable(uint16_t port)
  {
    x86::outb(COM1 + COM_IER, 0x00);
    x86::outb(COM1 + COM_LCR, COM_DLAB_ENABLE);

    uint16_t div = COM_BAUD_RATE_MAX / COM_BAUD_RATE;
    x86::outb(COM1 + COM_DLL, div & 0xFF);
    x86::outb(COM1 + COM_DLM, (div >> 8) & 0xFF);

    x86::outb(COM1 + COM_LCR, COM_LINE_PROTOCOL_8N1);
    x86::outb(COM1 + COM_FCR, COM_FIFO_ENABLE);
    x86::outb(COM1 + COM_MCR, COM_IRQ_ENABLE);

    x86::outb(COM1 + COM_MCR, COM_LOOPBACK_MODE);
    x86::outb(COM1 + COM_THR, 0xAE);

    if (x86::inb(COM1 + COM_RBR) == 0xAE) {
      x86::outb(COM1 + COM_MCR, COM_NORMAL_MODE);
      return true;
    } else {
     return false;
    }
  }

  bool _enabled;
};

// XXX more drivers

inline void putc(int c)
{
  static Cons_serial serial;

  if (serial.enabled())
    serial.putc(c);
}

inline void puts(char const *s)
{
  while (*s != '\0') {
    putc(*s);
    ++s;
  }
}
