%include "a20_is_enabled.asm"
%include "a20_enable_bios.asm"

%macro CHECK_A20_ENABLED 0
  call a20_is_enabled
  test ax, ax
  jnz a20_enable_success
%endmacro

a20_enable:
  CHECK_A20_ENABLED

a20_enable_try_bios:
  BIOS_PRINT MSG_A20_TRY_BIOS

  call a20_enable_bios

  test ax, ax
  jz a20_enable_try_keyboard

  CHECK_A20_ENABLED

a20_enable_try_keyboard:
  ; TODO

a20_enable_failure:
  BIOS_PRINT MSG_A20_FAILURE

  mov ax, 0
  jmp a20_enable_done

a20_enable_success:
  BIOS_PRINT MSG_A20_SUCCESS

  mov ax, 1

a20_enable_done:
  ret
