.extern PASCALMAIN

.text
.global _entry
_entry:
  mov rsp, stack_top
  jmp PASCALMAIN

.bss
.align 0x1000
.space 0x1000
stack_top:
