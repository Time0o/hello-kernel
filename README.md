# Hello Kernel

## Introduction

This is a simple 32 bit x86 bootloader that loads and runs a kernel ELF file
from disk.  The kernel in turn prints a greeting to the serial console and
halts. I wrote this mainly for educational purposes, in particular to improve
my understanding of bootloaders. In the future I might add actual functionality
to the kernel itself.

The `boot/` directory contains the bootloader code. Most of it is written in
assembly, `kern/` contains the kernel code. Parts of the bootloader and kernel
can also be found under `inc/`. I chose to use C++ wherever possible, this makes
for some nice zero cost abstractions (see e.g. `boot/cpp/boot.cpp`).

## Building

To build the bootloader and kernel, simply run `make`. You can then create a
bootable disk image containing the bootloader code and kernel ELF file using
`make disk` (this will use the `dd` command). Generated ELF files will be
written to `elf/` and the disk image will be written to `img/`.

## Running

Run `make qemu` to start the kernel under QEMU, alternatively run `make
qemu_dbg` to also attach a gdb server to the kernel, for this you will need
tmux.

`make qemu` should output something like following inside your terminal
(use "Ctrl+a x" to quit):

```
SeaBIOS (version ArchLinux 1.14.0-1)


iPXE (http://ipxe.org) 00:03.0 CA00 PCI2.10 PnP PMM+07F91500+07EF1500 CA00


Booting from Hard Disk..
hello from the kernel
```
