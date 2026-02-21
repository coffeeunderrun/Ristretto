extern PASCALMAIN

; == TEXT =====================================================================
section .text

global _entry
_entry:
  ; Limine and FPC's Linux register calling convention both use System V ABI.
  call PASCALMAIN

global _halt
_halt:
  hlt
  jmp _halt

; == BSS ======================================================================
section .bss

global _heap_start
  align 0x1000
_heap_start:
  resb 0x100000
_heap_end:

global _heap_size
_heap_size: equ _heap_end - _heap_start
