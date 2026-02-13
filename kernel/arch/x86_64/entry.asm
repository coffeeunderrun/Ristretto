extern PASCALMAIN

; == TEXT =====================================================================
section .text

global _entry
_entry:
  mov rsp, _stack_top

  ; Limine and FPC's Linux register calling convention both use System V ABI.
  call PASCALMAIN

global _halt
_halt:
  hlt
  jmp _halt

; == BSS ======================================================================
section .bss

global _stack_top
  align 0x1000
  resb 0x4000
_stack_top:
