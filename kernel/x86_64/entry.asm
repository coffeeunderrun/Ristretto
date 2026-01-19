.extern PASCALMAIN

.text
.global _entry
_entry:
  mov rsp, stack_top
  // Limine protocol states interrupt and direction flags will be cleared on entry.
  // FPC default 'register' calling convention expects direction flag to be cleared.
  call PASCALMAIN

.global _halt
_halt:
  hlt
  jmp _halt

.bss
.align 0x1000
.space 0x1000
stack_top:
