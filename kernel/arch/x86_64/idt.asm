extern _handler

; ISR_STUB vector, [code]
%macro ISR_STUB 1-2
%define ISR_STUB%1
global _isr_stub%1
_isr_stub%1:
%if %0 = 2
  push %2 ; Code
%endif
  push %1 ; Vector
  jmp handler
%endmacro

; TRY_ISR_STUB vector
%macro TRY_ISR_STUB 1
%ifdef ISR_STUB%1
  dq _isr_stub%1
%else
  dq 0
%endif
%endmacro


; == TEXT =====================================================================
section .text

handler:
  push r15
  push r14
  push r13
  push r12
  push r11
  push r10
  push r9
  push r8
  push rdi
  push rsi
  push rbp
  push rdx
  push rcx
  push rbx
  push rax

  mov rdi, rsp
  call _handler

  pop rax
  pop rbx
  pop rcx
  pop rdx
  pop rbp
  pop rsi
  pop rdi
  pop r8
  pop r9
  pop r10
  pop r11
  pop r12
  pop r13
  pop r14
  pop r15

  add rsp, 16 ; Remove IRQ vector and (error) code from stack
  iretq

  ISR_STUB 0, 0   ; Divide by zero
  ISR_STUB 1, 0   ; Debug
  ISR_STUB 2, 0   ; Non-maskable
  ISR_STUB 3, 0   ; Breakpoint
  ISR_STUB 4, 0   ; Overflow
  ISR_STUB 5, 0   ; Bound range exceeded
  ISR_STUB 6, 0   ; Invalid opcode
  ISR_STUB 7, 0   ; Device not available
  ISR_STUB 8      ; Double fault
  ISR_STUB 10     ; Invalid TSS
  ISR_STUB 11     ; Segment not present
  ISR_STUB 12     ; Stack segment fault
  ISR_STUB 13     ; General protection fault
  ISR_STUB 14     ; Page fault
  ISR_STUB 16, 0  ; x87 floating point exception
  ISR_STUB 17     ; Alignment check
  ISR_STUB 18, 0  ; Machine check
  ISR_STUB 19, 0  ; SIMD floating point exception
  ISR_STUB 21     ; Control protection exception
  ISR_STUB 28, 0  ; Hypervisor injection exception
  ISR_STUB 29     ; VMM communication exception
  ISR_STUB 30     ; Security exception
  ISR_STUB 32, 0  ; PIT
  ISR_STUB 33, 1  ; Keyboard
  ISR_STUB 34, 2  ; PIC cascade
  ISR_STUB 35, 3  ; COM2/COM4
  ISR_STUB 36, 4  ; COM1/COM3
  ISR_STUB 37, 5  ; LPT2
  ISR_STUB 38, 6  ; FDC
  ISR_STUB 39, 7  ; LPT1
  ISR_STUB 40, 8  ; RTC
  ISR_STUB 41, 9  ; Available
  ISR_STUB 42, 10 ; Available
  ISR_STUB 43, 11 ; Available
  ISR_STUB 44, 12 ; Mouse
  ISR_STUB 45, 13 ; FPU
  ISR_STUB 46, 14 ; HDC1
  ISR_STUB 47, 15 ; HDC2

; == RODATA ===================================================================
section .rodata

global _isr_stubs
_isr_stubs:
%assign vector 0
%rep 256
  TRY_ISR_STUB vector
%assign vector vector + 1
%endrep

; == BSS ======================================================================
section .bss

global _idt
  align 0x1000
_idt:
  resb 0x1000
