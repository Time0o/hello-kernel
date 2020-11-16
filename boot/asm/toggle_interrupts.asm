enable_interrupts:
  sti

  in al, 0x70
  and al, 0x7F
  out 0x70, al

  ret

disable_interrupts:
  cli

  in al, 0x70
  or al, 0x80
  out 0x70, al

  ret
