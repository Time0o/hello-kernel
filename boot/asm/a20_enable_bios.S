#define BIOS_INT_A20 0x15
#define BIOS_INT_A20_SUPPORT 0x2403
#define BIOS_INT_A20_ENABLE 0x2401

a20_enable_bios:
  mov $BIOS_INT_A20_SUPPORT, %ax // check A20 gate support
  int $BIOS_INT_A20
  jc a20_enable_bios_failure

  mov $BIOS_INT_A20_ENABLE, %ax // enable A20 gate
  int $BIOS_INT_A20
  jc a20_enable_bios_failure

  mov 1, %ax
  jmp a20_enable_bios_done

a20_enable_bios_failure:
  mov 0, %ax

a20_enable_bios_done:
  ret
