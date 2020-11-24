#include "a20_is_enabled.S"
#include "a20_enable_bios.S"

#define CHECK_A20_ENABLED \
  call a20_is_enabled; \
  test %ax, %ax; \
  jnz a20_enable_success

a20_enable:
  CHECK_A20_ENABLED

a20_enable_try_bios:
  call a20_enable_bios

  test %ax, %ax
  jz a20_enable_try_keyboard

  CHECK_A20_ENABLED

a20_enable_try_keyboard:
  // TODO

a20_enable_failure:
  mov $0, %ax
  jmp a20_enable_done

a20_enable_success:
  mov $1, %ax

a20_enable_done:
  ret
