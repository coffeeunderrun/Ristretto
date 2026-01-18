.extern PASCALMAIN

.text
.global _entry
_entry:
  mov rsp, stack_top
  call PASCALMAIN

.global _halt
_halt:
  hlt
  jmp _halt

.bss
.align 0x1000
.space 0x1000
stack_top:
