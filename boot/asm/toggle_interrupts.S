#define PORT_NMI_TOGGLE 0x70
#define NMI_ENABLE_MASK 0x7F
#define NMI_DISABLE_MASK 0x80

enable_interrupts:
  sti

  in $PORT_NMI_TOGGLE, %al
  and $NMI_ENABLE_MASK, %al
  out %al, $PORT_NMI_TOGGLE

  ret

disable_interrupts:
  cli

  in $PORT_NMI_TOGGLE, %al
  or $NMI_DISABLE_MASK, %al
  out %al, $PORT_NMI_TOGGLE

  ret
